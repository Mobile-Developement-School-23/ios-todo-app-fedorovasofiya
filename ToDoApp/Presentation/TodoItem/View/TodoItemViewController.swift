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
    private lazy var colorLabel = UILabel()
    private lazy var selectedColorLabel = UILabel()
    private lazy var paletteButton = UIButton()
    private lazy var colorView = UIView()
    private lazy var colorSlider = ColorSelectionSlider()
    private lazy var lightnessSlider = LightnessSelectionSlider()
    private lazy var colorPickerView = UIView()
    private lazy var deadlineLabel = UILabel()
    private lazy var selectedDateLabel = UILabel()
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
        setupColorView()
        setupColorPickerView()
        setupDeadlineView()
        setupDateView()
        setupDetailsStackView()
        setupDeleteButton()
        
        registerKeyboardNotifications()
        addDateLabelTapGestureRecognizer()
        addTapGestureRecognizerToDismissKeyboard()
        
        bindViewModel()
        viewOutput.loadItemIfExist()
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
            scrollView.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor),
            scrollView.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor),
            scrollView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            scrollView.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor)
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
            bottom: Constants.mediumMargin,
            right: Constants.margin
        )
        textView.translatesAutoresizingMaskIntoConstraints = false
        scrollView.addSubview(textView)
        
        let safeArea = view.safeAreaLayoutGuide
        NSLayoutConstraint.activate([
            textView.leadingAnchor.constraint(equalTo: safeArea.leadingAnchor, constant: Constants.margin),
            textView.trailingAnchor.constraint(equalTo: safeArea.trailingAnchor, constant: -Constants.margin),
            textView.topAnchor.constraint(equalTo: scrollView.topAnchor, constant: Constants.margin),
            textView.heightAnchor.constraint(greaterThanOrEqualToConstant: Constants.bigHeight)
        ])
    }
    
    private func setupImportanceLabel() {
        importanceLabel.text = L10n.importanceLabelText
        importanceLabel.font = .systemFont(ofSize: Constants.fontSize, weight: .regular)
        importanceLabel.translatesAutoresizingMaskIntoConstraints = false
        importanceView.addSubview(importanceLabel)
        
        NSLayoutConstraint.activate([
            importanceLabel.leadingAnchor.constraint(equalTo: importanceView.leadingAnchor, constant: Constants.margin),
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
                constant: -Constants.mediumMargin
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
    
    private func setupColorLabel() {
        colorLabel.text = L10n.colorLabelText
        colorLabel.font = .systemFont(ofSize: Constants.fontSize, weight: .regular)
        colorLabel.translatesAutoresizingMaskIntoConstraints = false
        colorView.addSubview(colorLabel)
        
        NSLayoutConstraint.activate([
            colorLabel.leadingAnchor.constraint(equalTo: colorView.leadingAnchor, constant: Constants.margin),
            colorLabel.centerYAnchor.constraint(equalTo: colorView.centerYAnchor)
        ])
    }
    
    private func setupSelectedColorLabel() {
        let textColor = getTextColor()
        selectedColorLabel.text = textColor.hex
        selectedColorLabel.textColor = textColor
        selectedColorLabel.font = .systemFont(ofSize: Constants.fontSize, weight: .regular)
        selectedColorLabel.translatesAutoresizingMaskIntoConstraints = false
        colorView.addSubview(selectedColorLabel)
        
        NSLayoutConstraint.activate([
            selectedColorLabel.leadingAnchor.constraint(equalTo: colorLabel.trailingAnchor),
            selectedColorLabel.centerYAnchor.constraint(equalTo: colorView.centerYAnchor)
        ])
    }
    
    private func setupPaletteButton() {
        let scaleConfig = UIImage.SymbolConfiguration(scale: .large)
        let weightConfig = UIImage.SymbolConfiguration(weight: .medium)
        paletteButton.setImage(
            UIImage(systemName: "paintpalette", withConfiguration: scaleConfig.applying(weightConfig)),
            for: .normal
        )
        paletteButton.translatesAutoresizingMaskIntoConstraints = false
        paletteButton.addTarget(self, action: #selector(toggleColorPickerVisibility), for: .touchUpInside)
        colorView.addSubview(paletteButton)
        
        NSLayoutConstraint.activate([
            paletteButton.trailingAnchor.constraint(
                equalTo: colorView.trailingAnchor,
                constant: -Constants.mediumMargin
            ),
            paletteButton.centerYAnchor.constraint(equalTo: colorView.centerYAnchor)
        ])
    }
    
    private func setupColorView() {
        setupColorLabel()
        setupSelectedColorLabel()
        setupPaletteButton()
        
        let separator = UIView()
        separator.backgroundColor = UIColor(named: "Separator")
        separator.translatesAutoresizingMaskIntoConstraints = false
        colorView.addSubview(separator)
        
        NSLayoutConstraint.activate([
            separator.heightAnchor.constraint(equalToConstant: Constants.separatorHeight),
            separator.bottomAnchor.constraint(equalTo: colorView.bottomAnchor),
            separator.leadingAnchor.constraint(equalTo: colorView.leadingAnchor, constant: Constants.margin),
            separator.trailingAnchor.constraint(equalTo: colorView.trailingAnchor, constant: -Constants.margin),
            colorView.heightAnchor.constraint(equalToConstant: Constants.defaultHeight + Constants.separatorHeight)
        ])
    }
    
    private func setupColorSlider() {
        colorSlider.colorChanged = { [weak self] color in
            self?.lightnessSlider.mainColor = color
            self?.applySelectedColor()
        }
        colorSlider.translatesAutoresizingMaskIntoConstraints = false
        colorPickerView.addSubview(colorSlider)
        
        NSLayoutConstraint.activate([
            colorSlider.leadingAnchor.constraint(equalTo: colorPickerView.leadingAnchor, constant: Constants.margin),
            colorSlider.trailingAnchor.constraint(equalTo: colorPickerView.trailingAnchor, constant: -Constants.margin),
            colorSlider.bottomAnchor.constraint(equalTo: colorPickerView.centerYAnchor, constant: -Constants.margin),
            colorSlider.heightAnchor.constraint(equalToConstant: Constants.sliderHeight)
        ])
    }
    
    private func setupLightnessSlider() {
        lightnessSlider.lightnessChanged = { [weak self] _ in
            self?.applySelectedColor()
        }
        lightnessSlider.mainColor = colorSlider.color
        lightnessSlider.translatesAutoresizingMaskIntoConstraints = false
        colorPickerView.addSubview(lightnessSlider)
        
        NSLayoutConstraint.activate([
            lightnessSlider.leadingAnchor.constraint(
                equalTo: colorPickerView.leadingAnchor,
                constant: Constants.margin
            ),
            lightnessSlider.trailingAnchor.constraint(
                equalTo: colorPickerView.trailingAnchor,
                constant: -Constants.margin
            ),
            lightnessSlider.topAnchor.constraint(equalTo: colorPickerView.centerYAnchor, constant: Constants.margin),
            lightnessSlider.heightAnchor.constraint(equalToConstant: Constants.sliderHeight)
        ])
    }
    
    private func setupColorPickerView() {
        setupColorSlider()
        setupLightnessSlider()
        
        let separator = UIView()
        separator.backgroundColor = UIColor(named: "Separator")
        separator.translatesAutoresizingMaskIntoConstraints = false
        colorPickerView.addSubview(separator)
        
        NSLayoutConstraint.activate([
            separator.heightAnchor.constraint(equalToConstant: Constants.separatorHeight),
            separator.bottomAnchor.constraint(equalTo: colorPickerView.bottomAnchor),
            separator.leadingAnchor.constraint(equalTo: colorPickerView.leadingAnchor, constant: Constants.margin),
            separator.trailingAnchor.constraint(equalTo: colorPickerView.trailingAnchor, constant: -Constants.margin),
            colorPickerView.heightAnchor.constraint(equalToConstant: Constants.bigHeight + Constants.separatorHeight)
        ])
    }
    
    private func setupDeadlineLabel() {
        deadlineLabel.text = L10n.toDoByLabelText
        deadlineLabel.font = .systemFont(ofSize: Constants.fontSize, weight: .regular)
        deadlineLabel.translatesAutoresizingMaskIntoConstraints = false
        deadlineView.addSubview(deadlineLabel)
        
        NSLayoutConstraint.activate([
            deadlineLabel.leadingAnchor.constraint(equalTo: deadlineView.leadingAnchor, constant: Constants.margin),
            deadlineLabel.centerYAnchor.constraint(lessThanOrEqualTo: deadlineView.centerYAnchor)
        ])
    }
    
    private func setupDateLabel() {
        selectedDateLabel.textColor = UIColor(named: "Blue")
        selectedDateLabel.font = .systemFont(ofSize: Constants.smallFontSize, weight: .semibold)
        selectedDateLabel.translatesAutoresizingMaskIntoConstraints = false
        deadlineView.addSubview(selectedDateLabel)
        
        NSLayoutConstraint.activate([
            selectedDateLabel.leadingAnchor.constraint(equalTo: deadlineView.leadingAnchor, constant: Constants.margin),
            selectedDateLabel.topAnchor.constraint(equalTo: deadlineLabel.bottomAnchor),
            selectedDateLabel.bottomAnchor.constraint(
                equalTo: deadlineView.bottomAnchor,
                constant: -Constants.smallMargin
            )
        ])
    }
    
    private func setupDeadlineSwitch() {
        deadlineSwitch.translatesAutoresizingMaskIntoConstraints = false
        deadlineSwitch.addTarget(self, action: #selector(deadlineSwitchChanged), for: .valueChanged)
        deadlineView.addSubview(deadlineSwitch)
        
        NSLayoutConstraint.activate([
            deadlineSwitch.trailingAnchor.constraint(
                equalTo: deadlineView.trailingAnchor,
                constant: -Constants.mediumMargin
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
        datePicker.locale = Locale(identifier: "ru")
        datePicker.date = dateService.getNextDay() ?? Date()
        datePicker.minimumDate = Date()
        datePicker.datePickerMode = .date
        datePicker.preferredDatePickerStyle = .inline
        datePicker.translatesAutoresizingMaskIntoConstraints = false
        dateView.addSubview(datePicker)
        
        NSLayoutConstraint.activate([
            datePicker.leadingAnchor.constraint(equalTo: dateView.leadingAnchor, constant: Constants.smallMargin),
            datePicker.trailingAnchor.constraint(equalTo: dateView.trailingAnchor, constant: -Constants.smallMargin),
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
            dateView.heightAnchor.constraint(equalTo: datePicker.heightAnchor)
        ])
    }
    
    private func setupDetailsStackView() {
        detailsStackView.axis = .vertical
        detailsStackView.backgroundColor = UIColor(named: "BackSecondary")
        detailsStackView.layer.cornerRadius = Constants.cornerRadius
        detailsStackView.addArrangedSubview(importanceView)
        detailsStackView.addArrangedSubview(colorView)
        detailsStackView.addArrangedSubview(deadlineView)
        detailsStackView.translatesAutoresizingMaskIntoConstraints = false
        scrollView.addSubview(detailsStackView)
        
        let safeArea = view.safeAreaLayoutGuide
        NSLayoutConstraint.activate([
            detailsStackView.leadingAnchor.constraint(equalTo: safeArea.leadingAnchor, constant: Constants.margin),
            detailsStackView.trailingAnchor.constraint(equalTo: safeArea.trailingAnchor, constant: -Constants.margin),
            detailsStackView.topAnchor.constraint(equalTo: textView.bottomAnchor, constant: Constants.margin)
        ])
    }
    
    private func setupDeleteButton() {
        deleteButton.isEnabled = false
        deleteButton.backgroundColor = UIColor(named: "BackSecondary")
        deleteButton.layer.cornerRadius = Constants.cornerRadius
        deleteButton.titleLabel?.font = .systemFont(ofSize: Constants.fontSize, weight: .regular)
        deleteButton.setTitle(L10n.deleteButtonTitle, for: .normal)
        deleteButton.setTitleColor(UIColor(named: "Red"), for: .normal)
        deleteButton.setTitleColor(UIColor(named: "LabelTertiary"), for: .disabled)
        deleteButton.translatesAutoresizingMaskIntoConstraints = false
        scrollView.addSubview(deleteButton)
        
        let safeArea = view.safeAreaLayoutGuide
        NSLayoutConstraint.activate([
            deleteButton.leadingAnchor.constraint(equalTo: safeArea.leadingAnchor, constant: Constants.margin),
            deleteButton.trailingAnchor.constraint(equalTo: safeArea.trailingAnchor, constant: -Constants.margin),
            deleteButton.topAnchor.constraint(equalTo: detailsStackView.bottomAnchor, constant: Constants.margin),
            deleteButton.heightAnchor.constraint(equalToConstant: Constants.defaultHeight),
            deleteButton.bottomAnchor.constraint(equalTo: scrollView.bottomAnchor, constant: -Constants.margin)
        ])
        
        deleteButton.addAction(
            UIAction(handler: { [weak self] _ in
                self?.viewOutput.deleteItem()
            }),
            for: .touchUpInside
        )
    }
    
    // MARK: - Actions
    
    @objc private func didTapCancelButton() {
        viewOutput.close()
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
        let deadline = deadlineSwitch.isOn ? datePicker.date : nil
        let textColor = selectedColorLabel.text ?? getTextColor().hex
        viewOutput.saveItem(text: text, importance: importance, deadline: deadline, textColor: textColor)
    }
    
    @objc private func toggleColorPickerVisibility() {
        if colorPickerView.superview != nil {
            hideColorPickerView()
        } else {
            showColorPickerView()
        }
    }
    
    @objc private func deadlineSwitchChanged() {
        if deadlineSwitch.isOn {
            showDateInDateLabel()
        } else {
            hideDateInDateLabel()
            if dateView.superview != nil {
                hideDateView()
            }
        }
    }
    
    @objc private func handleDatePicker() {
        selectedDateLabel.text = dateService.getString(from: datePicker.date)
    }
    
    @objc private func dateLabelTapped() {
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
        selectedDateLabel.isUserInteractionEnabled = true
        selectedDateLabel.addGestureRecognizer(tapGestureRecognizer)
    }
    
    // MARK: - Tools
    
    private func bindViewModel() {
        viewOutput.todoItemLoaded = { [weak self] todoItem in
            self?.updateText(text: todoItem.text)
            self?.updateImportanceControl(importance: todoItem.importance)
            if let deadline = todoItem.deadline {
                self?.updateDeadline(deadline: deadline)
            }
            let color = UIColor.convertHexToUIColor(hex: todoItem.textColor)
            self?.changeColorOfText(color: color)
            self?.changeTextOfSelectedColorLabel(text: todoItem.textColor)
            
            self?.deleteButton.isEnabled = true
        }
        
        viewOutput.successfullySaved = { [weak self] in
            self?.presentAlert(
                title: L10n.successAlertTitle,
                message: L10n.successfullSavingMessage,
                okActionHandler: { _ in
                    self?.viewOutput.close()
                })
        }
        
        viewOutput.successfullyDeleted = { [weak self] in
            self?.presentAlert(
                title: L10n.successAlertTitle,
                message: L10n.successfullDeletingMessage,
                okActionHandler: { _ in
                    self?.viewOutput.close()
                })
        }
        
        viewOutput.errorOccurred = { [weak self] description in
            self?.presentAlert(title: L10n.errorAlertTitle, message: description)
        }
    }
    
    private func updateText(text: String) {
        if !text.isEmpty {
            textView.text = text
            textView.textColor = getTextColor()
        } else {
            textView.text = L10n.todoTextPlaceholder
            textView.textColor = UIColor(named: "LabelTertiary")
        }
    }
    
    private func updateImportanceControl(importance: Importance) {
        importanceControl.selectedSegmentIndex = importance.index
    }
    
    private func updateDeadline(deadline: Date) {
        selectedDateLabel.text = dateService.getString(from: deadline)
        deadlineSwitch.isOn = true
        datePicker.date = deadline
        let currentDate = Date()
        datePicker.minimumDate = deadline < currentDate ? deadline : currentDate
    }
    
    private func toggleDateViewVisibility() {
        if dateView.superview == nil {
            showDateView()
        } else {
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
    
    private func showColorPickerView() {
        UIView.animate(withDuration: 0.5) {
            self.detailsStackView.insertArrangedSubview(self.colorPickerView, at: 2)
            self.view.layoutIfNeeded()
        }
    }
    
    private func hideColorPickerView() {
        UIView.animate(withDuration: 0.5) {
            self.colorPickerView.removeFromSuperview()
            self.view.layoutIfNeeded()
        }
    }
    
    private func showDateInDateLabel() {
        UIView.animate(withDuration: 0.25) {
            self.selectedDateLabel.text = self.dateService.getString(from: self.datePicker.date)
            self.view.layoutIfNeeded()
        }
    }
    
    private func hideDateInDateLabel() {
        UIView.animate(withDuration: 0.25) {
            self.selectedDateLabel.text = nil
            self.view.layoutIfNeeded()
        }
    }
    
    private func applySelectedColor() {
        let newColor = getTextColor()
        changeColorOfText(color: newColor)
        changeTextOfSelectedColorLabel(text: newColor.hex)
    }
    
    private func changeColorOfText(color: UIColor) {
        if textView.textColor != UIColor(named: "LabelTertiary") {
            textView.textColor = color
        }
        selectedColorLabel.textColor = color
    }
    
    private func changeTextOfSelectedColorLabel(text: String) {
        selectedColorLabel.text = text
    }
    
    private func getTextColor() -> UIColor {
        return colorSlider.color.adjustLightness(by: lightnessSlider.lightness)
    }
    
}

// MARK: - UITextViewDelegate

extension TodoItemViewController: UITextViewDelegate {
    
    func textViewDidBeginEditing(_ textView: UITextView) {
        if textView.textColor == UIColor(named: "LabelTertiary") {
            textView.text = nil
            textView.textColor = getTextColor()
        }
    }
    
    func textViewDidEndEditing(_ textView: UITextView) {
        if textView.text.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty {
            textView.text = L10n.todoTextPlaceholder
            textView.textColor = UIColor(named: "LabelTertiary")
        }
    }
    
}

// MARK: - Constants

extension TodoItemViewController {
    
    private struct Constants {
        static let margin: CGFloat = 16
        static let mediumMargin: CGFloat = 12
        static let smallMargin: CGFloat = 9
        static let sliderHeight: CGFloat = 12
        static let defaultHeight: CGFloat = 56
        static let bigHeight: CGFloat = 120
        static let fontSize: CGFloat = 17
        static let smallFontSize: CGFloat = 13
        static let cornerRadius: CGFloat = 16
        static let separatorHeight: CGFloat = 1 / UIScreen.main.scale
    }
    
}
