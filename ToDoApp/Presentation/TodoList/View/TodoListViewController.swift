//
//  TodoListViewController.swift
//  ToDoApp
//
//  Created by Sonya Fedorova on 28.06.2023.
//

import UIKit

final class TodoListViewController: UIViewController {
    
    enum Section: Hashable {
        case main
    }
    
    // MARK: - Private Properties
    
    private lazy var tableView = UITableView(frame: .zero, style: .insetGrouped)
    private lazy var dataSource = TodoListDataSource(tableView, viewOutput: viewOutput)
    private lazy var plusButton = UIButton()
    
    private var viewOutput: TodoListViewOutput
    
    // MARK: - Life Cycle
    
    init(viewOutput: TodoListViewOutput) {
        self.viewOutput = viewOutput
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = UIColor(named: "BackPrimary")
        
        setupNavigationBar()
        setupTableView()
        setupPlusButton()
        
        bindViewModel()
        viewOutput.loadItems()
    }
    
    // MARK: - UI Setup
    
    private func setupNavigationBar() {
        navigationController?.navigationBar.prefersLargeTitles = true
        navigationController?.navigationBar.layoutMargins.left = Constants.titleMargin
        navigationItem.title = L10n.listScreenTitle
    }
    
    private func setupTableView() {
        tableView.backgroundColor = nil
        tableView.estimatedRowHeight = Constants.estimatedRowHeight
        tableView.rowHeight = UITableView.automaticDimension
//        tableView.separatorStyle = .none
        tableView.separatorInset = UIEdgeInsets(top: 0, left: Constants.leftInset, bottom: 0, right: 0)
        tableView.register(TodoItemTableViewCell.self, forCellReuseIdentifier: TodoItemTableViewCell.reuseIdentifier)
        tableView.delegate = self
        tableView.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(tableView)
        
        let safeArea = view.safeAreaLayoutGuide
        NSLayoutConstraint.activate([
            tableView.topAnchor.constraint(equalTo: safeArea.topAnchor),
            tableView.bottomAnchor.constraint(equalTo: view.bottomAnchor),
            tableView.leadingAnchor.constraint(equalTo: safeArea.leadingAnchor),
            tableView.trailingAnchor.constraint(equalTo: safeArea.trailingAnchor)
        ])
    }
    
    private func setupPlusButton() {
        let imageConfig = UIImage.SymbolConfiguration(pointSize: 20, weight: .bold, scale: .large)
        let plusImage = UIImage(systemName: "plus", withConfiguration: imageConfig)?
            .withTintColor(.white, renderingMode: .alwaysOriginal)
        plusButton.setImage(plusImage, for: .normal)
        plusButton.backgroundColor = .systemBlue
        plusButton.layer.cornerRadius = Constants.buttonSize / 2
        plusButton.layer.shadowColor = UIColor(named: "Shadow")?.cgColor
        plusButton.layer.shadowRadius = Constants.shadowRadius
        plusButton.layer.shadowOpacity = 1
        plusButton.layer.shadowOffset = CGSize(width: 0, height: Constants.shadowOffsetY)
        plusButton.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(plusButton)
        
        let safeArea = view.safeAreaLayoutGuide
        NSLayoutConstraint.activate([
            plusButton.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            plusButton.bottomAnchor.constraint(equalTo: safeArea.bottomAnchor, constant: -Constants.bottomMargin),
            plusButton.widthAnchor.constraint(equalToConstant: Constants.buttonSize),
            plusButton.heightAnchor.constraint(equalToConstant: Constants.buttonSize)
        ])
        
        plusButton.addAction(
            UIAction(handler: { [weak self] _ in self?.viewOutput.didTapAdd() }),
            for: .touchUpInside
        )
    }
    
    // MARK: - Tools
    
    private func bindViewModel() {
        viewOutput.todoListLoaded = { [weak self] todoList in
            self?.updateDataSource(data: todoList, animated: true)
        }
        
        viewOutput.errorOccurred = { [weak self] description in
            self?.presentAlert(title: L10n.errorAlertTitle, message: description)
        }
    }
    
    private func updateDataSource(data: [TodoItemTableViewCell.DisplayData], animated: Bool = false) {
        var snapshot = NSDiffableDataSourceSnapshot<Section, TodoItemTableViewCell.DisplayData>()
        snapshot.appendSections([.main])
        snapshot.appendItems(data)
        dataSource.apply(snapshot, animatingDifferences: animated)
    }
    
}

// MARK: - UITableViewDelegate

extension TodoListViewController: UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        viewOutput.didSelectItem(at: indexPath.row)
    }
    
    func tableView(_ tableView: UITableView, leadingSwipeActionsConfigurationForRowAt indexPath: IndexPath) -> UISwipeActionsConfiguration? {
        let doneAction = UIContextualAction(style: .normal, title: nil) { [weak self] _, _, completion in
            self?.viewOutput.toggleIsDoneValue(index: indexPath.row)
            completion(true)
        }
        doneAction.image = UIImage(
            systemName: "checkmark.circle.fill",
            withConfiguration: UIImage.SymbolConfiguration(weight: .bold)
        )
        doneAction.backgroundColor = UIColor(named: "Green")
        return UISwipeActionsConfiguration(actions: [doneAction])
    }
    
    func tableView(_ tableView: UITableView, trailingSwipeActionsConfigurationForRowAt indexPath: IndexPath) -> UISwipeActionsConfiguration? {
        let deleteAction = UIContextualAction(style: .destructive, title: nil) { [weak self] _, _, completion in
            self?.viewOutput.deleteItem(at: indexPath.row)
            completion(true)
        }
        deleteAction.image = UIImage(
            systemName: "trash.fill",
            withConfiguration: UIImage.SymbolConfiguration(weight: .bold)
        )
        let infoAction = UIContextualAction(style: .normal, title: nil) { [weak self] _, _, completion in
            self?.viewOutput.didSelectItem(at: indexPath.row)
            completion(true)
        }
        infoAction.image = UIImage(
            systemName: "info.circle.fill",
            withConfiguration: UIImage.SymbolConfiguration(weight: .bold)
        )
        return UISwipeActionsConfiguration(actions: [deleteAction, infoAction])
    }
    
}

// MARK: - Constants

extension TodoListViewController {
    
    private struct Constants {
        static let margin: CGFloat = 16
        static let titleMargin: CGFloat = 32
        static let bottomMargin: CGFloat = 20
        static let buttonSize: CGFloat = 44
        static let shadowRadius: CGFloat = 10
        static let shadowOffsetY: CGFloat = 8
        static let separatorInset: CGFloat = 52
    }
    
}

// MARK: - Data Source

final class TodoListDataSource:
    UITableViewDiffableDataSource<TodoListViewController.Section, TodoItemTableViewCell.DisplayData> {
    
    init(_ tableView: UITableView, viewOutput: TodoListViewOutput) {
        super.init(tableView: tableView) { tableView, indexPath, itemIdentifier in
            guard let cell = tableView.dequeueReusableCell(
                withIdentifier: TodoItemTableViewCell.reuseIdentifier,
                for: indexPath
            ) as? TodoItemTableViewCell
            else {
                return UITableViewCell()
            }
            cell.accessoryType = .disclosureIndicator
            cell.checkmarkCallback = {
                viewOutput.toggleIsDoneValue(id: itemIdentifier.id)
            }
            cell.configure(with: itemIdentifier)
            return cell
        }
    }
    
}
