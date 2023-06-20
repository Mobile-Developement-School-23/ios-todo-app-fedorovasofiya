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
    private lazy var deleteButton = UIButton()
    
// MARK: - Life Cycle

    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = UIColor(named: "BackPrimary")
        
        setupNavigationItem()
        setupScrollView()
        setupTextView()
        setupDeleteButton()
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
        view.addSubview(scrollView)
        
        scrollView.translatesAutoresizingMaskIntoConstraints = false
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
        textView.textContainerInset = UIEdgeInsets(
            top: Constants.margin,
            left: Constants.margin,
            bottom: Constants.margin,
            right: Constants.margin
        )
        textView.text = L10n.todoTextPlaceholder
        textView.textColor = UIColor(named: "LabelTertiary")
        scrollView.addSubview(textView)
        
        textView.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            textView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: Constants.margin),
            textView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -Constants.margin),
            textView.topAnchor.constraint(equalTo: scrollView.topAnchor, constant: Constants.margin),
            textView.bottomAnchor.constraint(equalTo: scrollView.bottomAnchor, constant: -Constants.margin),
            textView.heightAnchor.constraint(greaterThanOrEqualToConstant: Constants.textDefaultHeight)
        ])
    }
    
    private func setupDeleteButton() {
        deleteButton.backgroundColor = UIColor(named: "BackSecondary")
        deleteButton.layer.cornerRadius = Constants.cornerRadius
        deleteButton.titleLabel?.font = .systemFont(ofSize: Constants.fontSize, weight: .regular)
        deleteButton.setTitle(L10n.deleteButtonTitle, for: .normal)
        deleteButton.setTitleColor(UIColor(named: "Red"), for: .normal)
        deleteButton.setTitleColor(UIColor(named: "LabelTertiary"), for: .disabled)
        scrollView.addSubview(deleteButton)
        
        deleteButton.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            deleteButton.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: Constants.margin),
            deleteButton.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -Constants.margin),
            deleteButton.topAnchor.constraint(equalTo: textView.bottomAnchor, constant: Constants.margin),
            deleteButton.heightAnchor.constraint(equalToConstant: Constants.buttonHeight)
        ])
    }
    
// MARK: - Actions
    
    @objc private func didTapCancelButton() {
        
    }
    
    @objc private func didTapSaveButton() {
        
    }

}

// MARK: - Constants

extension TodoViewController {
    
    private struct Constants {
        static let margin: CGFloat = 16
        static let textDefaultHeight: CGFloat = 120
        static let fontSize: CGFloat = 17
        static let cornerRadius: CGFloat = 16
        static let buttonHeight: CGFloat = 56
    }
    
}
