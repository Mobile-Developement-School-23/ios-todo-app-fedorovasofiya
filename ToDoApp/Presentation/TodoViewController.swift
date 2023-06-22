//
//  TodoViewController.swift
//  ToDoApp
//
//  Created by Sonya Fedorova on 16.06.2023.
//

import UIKit

final class TodoViewController: UIViewController {
    
// MARK: - Private Properties
    
    private lazy var scrollView = UIScrollView()
    private lazy var textView = UITextView()
    private lazy var importanceLabel = UILabel()
    private lazy var importanceControl = UISegmentedControl()
    private lazy var importanceView = UIView()
    private lazy var deadlineLabel = UILabel()
    private lazy var dateLabel = UILabel()
    private lazy var deadlineSwitch = UISwitch()
    private lazy var deadlineView = UIView()
    private lazy var datePicker = UIDatePicker()
    private lazy var dateView = UIView()
    private lazy var detailsStackView = UIStackView()
    private lazy var deleteButton = UIButton()
    
// MARK: - Life Cycle

    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = UIColor(named: "BackPrimary")
        
        setupNavigationItem()
        setupScrollView()
        setupTextView()
        setupImportanceView()
        setupDeadlineView()
        setupDateView()
        setupDetailsStackView()
        setupDeleteButton()
        
        addDateLabelTapGestureRecognizer()
    }
    
// MARK: - UI Setup
    
    private func setupNavigationItem() {
        navigationItem.title = L10n.todoScreenTitle
        navigationItem.leftBarButtonItem = UIBarButtonItem(
            title: L10n.cancelButtonTitle,
            style: .plain,
            target: self,
            action: #selector(didTapCancelButton)
        )
        navigationItem.rightBarButtonItem = UIBarButtonItem(
            title: L10n.saveButtonTitle,
            style: .done,
            target: self,
            action: #selector(didTapSaveButton)
        )
    }
    
    private func setupScrollView() {
        scrollView.contentSize = view.bounds.size
        scrollView.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(scrollView)
        
        NSLayoutConstraint.activate([
            scrollView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            scrollView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            scrollView.topAnchor.constraint(equalTo: view.topAnchor),
            scrollView.bottomAnchor.constraint(equalTo: view.bottomAnchor)
        ])
    }
    
    private func setupTextView() {
        textView.isScrollEnabled = false
        textView.backgroundColor = UIColor(named: "BackSecondary")
        textView.layer.cornerRadius = Constants.cornerRadius
        textView.font = .systemFont(ofSize: Constants.fontSize, weight: .regular)
//        textView.text = L10n.todoTextPlaceholder
//        textView.textColor = UIColor(named: "LabelTertiary")
        textView.text = Constants.fish //заменить
        textView.textContainerInset = UIEdgeInsets(
            top: Constants.margin,
            left: Constants.margin,
            bottom: Constants.smallMargin,
            right: Constants.margin
        )
        textView.translatesAutoresizingMaskIntoConstraints = false
        scrollView.addSubview(textView)
        
        NSLayoutConstraint.activate([
            textView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: Constants.margin),
            textView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -Constants.margin),
            textView.topAnchor.constraint(equalTo: scrollView.topAnchor, constant: Constants.margin),
            textView.heightAnchor.constraint(greaterThanOrEqualToConstant: Constants.textDefaultHeight)
        ])
    }
    
    private func setupImportanceLabel() {
        importanceLabel.text = L10n.importanceLabelText
        importanceLabel.font = .systemFont(ofSize: Constants.fontSize, weight: .regular)
        importanceLabel.translatesAutoresizingMaskIntoConstraints = false
        importanceView.addSubview(importanceLabel)
        
        NSLayoutConstraint.activate([
            importanceLabel.leadingAnchor.constraint(
                equalTo: importanceView.leadingAnchor,
                constant: Constants.margin
            ),
            importanceLabel.centerYAnchor.constraint(equalTo: importanceView.centerYAnchor)
        ])
    }
    
    private func setupImportanceControl() {
        let scaleConfig = UIImage.SymbolConfiguration(scale: .small)
        let weightConfig = UIImage.SymbolConfiguration(weight: .bold)
        let arrowImage = UIImage(
            systemName: "arrow.down",
            withConfiguration: scaleConfig.applying(weightConfig)
        )?.withTintColor(UIColor(named: "Gray") ?? .gray, renderingMode: .alwaysOriginal)
        let exclamationmarkImage = UIImage(
            systemName: "exclamationmark.2",
            withConfiguration: scaleConfig.applying(weightConfig)
        )?.withTintColor(UIColor(named: "Red") ?? .red, renderingMode: .alwaysOriginal)
        
        importanceControl.insertSegment(with: arrowImage, at: 0, animated: true)
        importanceControl.insertSegment(withTitle: L10n.regularImportanceChoice, at: 1, animated: true)
        importanceControl.insertSegment(with: exclamationmarkImage, at: 2, animated: true)
        importanceControl.translatesAutoresizingMaskIntoConstraints = false
        importanceView.addSubview(importanceControl)
        
        NSLayoutConstraint.activate([
            importanceControl.trailingAnchor.constraint(
                equalTo: importanceView.trailingAnchor,
                constant: -Constants.smallMargin
            ),
            importanceControl.centerYAnchor.constraint(equalTo: importanceView.centerYAnchor)
        ])
    }
    
    private func setupImportanceView() {
        setupImportanceLabel()
        setupImportanceControl()
        
        let separator = UIView()
        separator.backgroundColor = UIColor(named: "Separator")
        separator.translatesAutoresizingMaskIntoConstraints = false
        importanceView.addSubview(separator)
    
        NSLayoutConstraint.activate([
            separator.heightAnchor.constraint(equalToConstant: Constants.separatorHeight),
            separator.bottomAnchor.constraint(equalTo: importanceView.bottomAnchor),
            separator.leadingAnchor.constraint(equalTo: importanceView.leadingAnchor, constant: Constants.margin),
            separator.trailingAnchor.constraint(equalTo: importanceView.trailingAnchor, constant: -Constants.margin),
            importanceView.heightAnchor.constraint(equalToConstant: Constants.defaultHeight + Constants.separatorHeight)
        ])
    }
    
    private func setupDeadlineLabel() {
        deadlineLabel.text = L10n.toDoByLabelText
        deadlineLabel.font = .systemFont(ofSize: Constants.fontSize, weight: .regular)
        deadlineLabel.translatesAutoresizingMaskIntoConstraints = false
        deadlineView.addSubview(deadlineLabel)
        
//        NSLayoutConstraint.activate([
//            deadlineLabel.leadingAnchor.constraint(equalTo: deadlineView.leadingAnchor, constant: Constants.margin),
//            deadlineLabel.centerYAnchor.constraint(equalTo: deadlineView.centerYAnchor)
//        ])
        NSLayoutConstraint.activate([
            deadlineLabel.leadingAnchor.constraint(equalTo: deadlineView.leadingAnchor, constant: Constants.margin),
            deadlineLabel.topAnchor.constraint(lessThanOrEqualTo: deadlineView.topAnchor, constant: 17),
            deadlineLabel.bottomAnchor.constraint(lessThanOrEqualTo: deadlineView.bottomAnchor, constant: -17)
        ])
    }
    
    private func setupDateLabel() {
        dateLabel.textColor = UIColor(named: "Blue")
        dateLabel.font = .systemFont(ofSize: Constants.smallFontSize, weight: .semibold)
        dateLabel.translatesAutoresizingMaskIntoConstraints = false
        deadlineView.addSubview(dateLabel)
        
        NSLayoutConstraint.activate([
            dateLabel.leadingAnchor.constraint(equalTo: deadlineView.leadingAnchor, constant: Constants.margin),
            dateLabel.topAnchor.constraint(equalTo: deadlineLabel.bottomAnchor),
            dateLabel.bottomAnchor.constraint(equalTo: deadlineView.bottomAnchor, constant: -9)
        ])
    }
    
    private func setupDeadlineSwitch() {
        deadlineSwitch.translatesAutoresizingMaskIntoConstraints = false
        deadlineSwitch.addTarget(self, action: #selector(switchChanged), for: .valueChanged)
        deadlineView.addSubview(deadlineSwitch)
        
        NSLayoutConstraint.activate([
            deadlineSwitch.trailingAnchor.constraint(
                equalTo: deadlineView.trailingAnchor,
                constant: -Constants.smallMargin
            ),
            deadlineSwitch.centerYAnchor.constraint(equalTo: deadlineView.centerYAnchor)
        ])
    }
    
    private func setupDeadlineView() {
        setupDeadlineLabel()
        setupDateLabel()
        setupDeadlineSwitch()
    
        deadlineView.heightAnchor.constraint(equalToConstant: Constants.defaultHeight).isActive = true
    }
    
    private func setupDatePicker() {
        datePicker.datePickerMode = .date
        datePicker.preferredDatePickerStyle = .inline
//        datePicker.date = Calendar.current.date(byAdding: DateComponents(day: 1), to: Date()) ?? Date()
        datePicker.translatesAutoresizingMaskIntoConstraints = false
        dateView.addSubview(datePicker)
        
        NSLayoutConstraint.activate([
            datePicker.leadingAnchor.constraint(equalTo: dateView.leadingAnchor, constant: 8),
            datePicker.trailingAnchor.constraint(equalTo: dateView.trailingAnchor, constant: -8),
            datePicker.centerYAnchor.constraint(equalTo: dateView.centerYAnchor)
        ])
    }
    
    private func setupDateView() {
        setupDatePicker()
        
        let separator = UIView()
        separator.backgroundColor = UIColor(named: "Separator")
        separator.translatesAutoresizingMaskIntoConstraints = false
        dateView.addSubview(separator)
        
        NSLayoutConstraint.activate([
            separator.heightAnchor.constraint(equalToConstant: Constants.separatorHeight),
            separator.topAnchor.constraint(equalTo: dateView.topAnchor),
            separator.leadingAnchor.constraint(equalTo: dateView.leadingAnchor, constant: Constants.margin),
            separator.trailingAnchor.constraint(equalTo: dateView.trailingAnchor, constant: -Constants.margin),
            dateView.heightAnchor.constraint(equalToConstant: 332)
        ])
    }
    
    private func setupDetailsStackView() {
        detailsStackView.axis = .vertical
        detailsStackView.backgroundColor = UIColor(named: "BackSecondary")
        detailsStackView.layer.cornerRadius = Constants.cornerRadius
        detailsStackView.addArrangedSubview(importanceView)
        detailsStackView.addArrangedSubview(deadlineView)
        scrollView.addSubview(detailsStackView)
        
        detailsStackView.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            detailsStackView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: Constants.margin),
            detailsStackView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -Constants.margin),
            detailsStackView.topAnchor.constraint(equalTo: textView.bottomAnchor, constant: Constants.margin)
        ])
    }
    
    private func setupDeleteButton() {
        deleteButton.backgroundColor = UIColor(named: "BackSecondary")
        deleteButton.layer.cornerRadius = Constants.cornerRadius
        deleteButton.titleLabel?.font = .systemFont(ofSize: Constants.fontSize, weight: .regular)
        deleteButton.setTitle(L10n.deleteButtonTitle, for: .normal)
        deleteButton.setTitleColor(UIColor(named: "Red"), for: .normal)
        deleteButton.setTitleColor(UIColor(named: "LabelTertiary"), for: .disabled)
        deleteButton.translatesAutoresizingMaskIntoConstraints = false
        scrollView.addSubview(deleteButton)

        NSLayoutConstraint.activate([
            deleteButton.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: Constants.margin),
            deleteButton.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -Constants.margin),
            deleteButton.topAnchor.constraint(equalTo: detailsStackView.bottomAnchor, constant: Constants.margin),
            deleteButton.heightAnchor.constraint(equalToConstant: Constants.defaultHeight),
            deleteButton.bottomAnchor.constraint(equalTo: scrollView.bottomAnchor)
        ])
//        deleteButton.isEnabled = false
    }
    
// MARK: - Actions
    
    @objc private func didTapCancelButton() {
        
    }
    
    @objc private func didTapSaveButton() {
        
    }
    
    @objc private func switchChanged() {
        if deadlineSwitch.isOn {
            dateLabel.text = "2 июня 2021"
        } else {
            dateLabel.text = ""
            hideDateView()
        }
    }
    
    @objc private func dateLabelTapped() {
        updateDateViewVisibility()
    }
    
// MARK: - Tools
    
    private func addDateLabelTapGestureRecognizer() {
        let dateLabelTap = UITapGestureRecognizer(target: self, action: #selector(dateLabelTapped))
        dateLabel.isUserInteractionEnabled = true
        dateLabel.addGestureRecognizer(dateLabelTap)
    }
    
    private func updateDateViewVisibility() {
        if detailsStackView.arrangedSubviews.count == 2 {
            detailsStackView.addArrangedSubview(dateView)
        } else {
            hideDateView()
        }
    }
    
    private func hideDateView() {
        if detailsStackView.arrangedSubviews.count == 3 {
            let view = detailsStackView.arrangedSubviews.last
            view?.removeFromSuperview()
        }
    }

}

// MARK: - Constants

extension TodoViewController {
    
    private struct Constants {
        static let margin: CGFloat = 16
        static let smallMargin: CGFloat = 12
        static let textDefaultHeight: CGFloat = 120
        static let fontSize: CGFloat = 17
        static let smallFontSize: CGFloat = 13
        static let cornerRadius: CGFloat = 16
        static let defaultHeight: CGFloat = 56
        static let separatorHeight: CGFloat = 1 / UIScreen.main.scale
        
        static let fish = "Lorem ipsum dolor sit amet, consectetuer adipiscing elit. Aenean commodo ligula eget dolor. Aenean massa. Cum sociis natoque penatibus et magnis dis parturient montes, nascetur ridiculus mus. Donec quam felis, ultricies nec, pellentesque eu, pretium quis, sem. "
    }
    
}
