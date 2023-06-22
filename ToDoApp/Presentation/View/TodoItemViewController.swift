//
//  TodoItemViewController.swift
//  ToDoApp
//
//  Created by Sonya Fedorova on 16.06.2023.
//

import UIKit

final class TodoItemViewController: UIViewController {
    
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
    
    private var viewOutput: TodoItemViewOutput
    private var dateService: DateService
    
    // MARK: - Life Cycle
    
    init(viewOutput: TodoItemViewOutput, dateService: DateService) {
        self.viewOutput = viewOutput
        self.dateService = dateService
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    deinit {
        NotificationCenter.default.removeObserver(self)
    }

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
        
        registerKeyboardNotifications()
        addDateLabelTapGestureRecognizer()
        addTapGestureRecognizerToDismissKeyboard()
        
        bindViewModel()
        viewOutput.loadItem()
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
        textView.delegate = self
        textView.isScrollEnabled = false
        textView.backgroundColor = UIColor(named: "BackSecondary")
        textView.layer.cornerRadius = Constants.cornerRadius
        textView.font = .systemFont(ofSize: Constants.fontSize, weight: .regular)
        textView.text = L10n.todoTextPlaceholder
        textView.textColor = UIColor(named: "LabelTertiary")
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
        importanceControl.selectedSegmentIndex = 1
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
        datePicker.translatesAutoresizingMaskIntoConstraints = false
        dateView.addSubview(datePicker)
        
        NSLayoutConstraint.activate([
            datePicker.leadingAnchor.constraint(equalTo: dateView.leadingAnchor, constant: 8),
            datePicker.trailingAnchor.constraint(equalTo: dateView.trailingAnchor, constant: -8),
            datePicker.centerYAnchor.constraint(equalTo: dateView.centerYAnchor)
        ])
        
        datePicker.addTarget(self, action: #selector(handleDatePicker), for: .valueChanged)
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
    }
    
    // MARK: - Actions
    
    @objc private func didTapCancelButton() {
        
    }
    
    @objc private func didTapSaveButton() {
        dismissKeyboard()
        
        guard
            let text = textView.textColor == UIColor(named: "LabelTertiary") ? nil : textView.text
        else {
            self.presentAlert(title: L10n.textIsEmpty)
            return
        }
        let importance = Importance.getValue(index: importanceControl.selectedSegmentIndex)
        let deadline = deadlineSwitch.isOn ? dateService.getDate(from: dateLabel.text ?? "") : nil
        viewOutput.saveItem(text: text, importance: importance, deadline: deadline)
    }
    
    @objc private func switchChanged() {
        if deadlineSwitch.isOn {
            guard let nextDay = dateService.getNextDay() else { return }
            dateLabel.text = dateService.getString(from: nextDay)
        } else {
            dateLabel.text = nil
            if detailsStackView.arrangedSubviews.count == 3 {
                hideDateView()
            }
        }
    }
    
    @objc private func handleDatePicker() {
        dateLabel.text = dateService.getString(from: datePicker.date)
    }
    
    @objc private func dateLabelTapped() {
        guard
            let selectedDateString = dateLabel.text,
            let selectedDate = dateService.getDate(from: selectedDateString)
        else {
            return
        }
        datePicker.date = selectedDate
        let currentDate = Date()
        datePicker.minimumDate = selectedDate < currentDate ? selectedDate : currentDate
        toggleDateViewVisibility()
    }
    
    @objc private func keyboardWillShow(notification: Notification) {
        guard
            let userInfo = notification.userInfo,
            let keyboardFrame = (userInfo[UIResponder.keyboardFrameEndUserInfoKey] as? NSValue)?.cgRectValue
        else {
            return
        }
        let keyboardHeight = keyboardFrame.height
        let contentInsets = UIEdgeInsets(top: 0, left: 0, bottom: keyboardHeight, right: 0)
        scrollView.contentInset = contentInsets
        scrollView.scrollIndicatorInsets = contentInsets
    }
    
    @objc private func keyboardWillHide() {
        scrollView.contentInset = .zero
        scrollView.scrollIndicatorInsets = .zero
    }
    
    @objc private func dismissKeyboard() {
        textView.endEditing(true)
    }
    
    // MARK: - NotificationCenter
    
    private func registerKeyboardNotifications() {
        NotificationCenter.default.addObserver(
            self,
            selector: #selector(keyboardWillShow),
            name: UIResponder.keyboardWillShowNotification,
            object: nil
        )
        NotificationCenter.default.addObserver(
            self,
            selector: #selector(keyboardWillHide),
            name: UIResponder.keyboardWillHideNotification,
            object: nil
        )
    }
    
    // MARK: - GestureRecognizers
    
    private func addTapGestureRecognizerToDismissKeyboard() {
        let tapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(dismissKeyboard))
        tapGestureRecognizer.cancelsTouchesInView = false
        view.addGestureRecognizer(tapGestureRecognizer)
    }
    
    private func addDateLabelTapGestureRecognizer() {
        let tapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(dateLabelTapped))
        dateLabel.isUserInteractionEnabled = true
        dateLabel.addGestureRecognizer(tapGestureRecognizer)
    }
    
    // MARK: - Tools
    
    private func bindViewModel() {
        viewOutput.todoItemLoaded = { [weak self] todoItem in
            self?.updateText(text: todoItem.text)
            self?.updateImportanceControl(importance: todoItem.importance)
            if let deadline = todoItem.deadline {
                self?.updateDeadline(deadline: deadline)
            }
        }
        
        viewOutput.successfullySaved = { [weak self] in
            self?.presentAlert(title: L10n.successAlertTitle, message: L10n.successfullSavingMessage)
        }
        
        viewOutput.errorOccurred = { [weak self] description in
            self?.presentAlert(title: L10n.errorAlertTitle, message: description)
        }
    }
    
    private func updateText(text: String) {
        if !text.isEmpty {
            textView.text = text
            textView.textColor = .label
        } else {
            textView.text = L10n.todoTextPlaceholder
            textView.textColor = UIColor(named: "LabelTertiary")
        }
    }
    
    private func updateImportanceControl(importance: Importance) {
        importanceControl.selectedSegmentIndex = importance.index
    }
    
    private func updateDeadline(deadline: Date) {
        dateLabel.text = dateService.getString(from: deadline)
        deadlineSwitch.isOn = true
        datePicker.date = deadline
    }
    
    private func toggleDateViewVisibility() {
        if detailsStackView.arrangedSubviews.count == 2 {
            showDateView()
        } else if detailsStackView.arrangedSubviews.count == 3 {
            hideDateView()
        }
    }
    
    private func showDateView() {
        UIView.animate(withDuration: 0.5) {
            self.detailsStackView.addArrangedSubview(self.dateView)
            self.view.layoutIfNeeded()
        }
    }
    
    private func hideDateView() {
        UIView.animate(withDuration: 0.5) {
            self.dateView.removeFromSuperview()
            self.view.layoutIfNeeded()
        }
    }

}

// MARK: - UITextViewDelegate

extension TodoItemViewController: UITextViewDelegate {
    
    func textViewDidBeginEditing(_ textView: UITextView) {
        if textView.textColor == UIColor(named: "LabelTertiary") {
            textView.text = nil
            textView.textColor = .label
        }
    }
    
    func textViewDidEndEditing(_ textView: UITextView) {
        if !textView.hasText {
            textView.text = L10n.todoTextPlaceholder
            textView.textColor = UIColor(named: "LabelTertiary")
        }
    }
    
}

// MARK: - Constants

extension TodoItemViewController {
    
    private struct Constants {
        static let margin: CGFloat = 16
        static let smallMargin: CGFloat = 12
        static let textDefaultHeight: CGFloat = 120
        static let fontSize: CGFloat = 17
        static let smallFontSize: CGFloat = 13
        static let cornerRadius: CGFloat = 16
        static let defaultHeight: CGFloat = 56
        static let separatorHeight: CGFloat = 1 / UIScreen.main.scale
    }
    
}
