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
        navigationItem.rightBarButtonItem?.isEnabled = false
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
        textView.backgroundColor = UIColor(named: "BackSecondary")
        textView.isScrollEnabled = false
        textView.layer.cornerRadius = Constants.cornerRadius
        textView.font = .systemFont(ofSize: Constants.fontSize, weight: .regular)
        textView.textContainerInset = UIEdgeInsets(
            top: Constants.margin,
            left: Constants.margin,
            bottom: Constants.margin,
            right: Constants.margin
        )
//        textView.text = Constants.fish
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
    
// MARK: - Actions
    
    @objc private func didTapCancelButton() {
        
    }
    
    @objc private func didTapSaveButton() {
        
    }

}

// MARK: - Constants

extension TodoViewController {
    struct Constants {
        static let margin: CGFloat = 16
        static let textDefaultHeight: CGFloat = 120
        static let fontSize: CGFloat = 17
        static let cornerRadius: CGFloat = 16
        
//        static let fish = "В рамках спецификации современных стандартов, непосредственные участники технического прогресса могут быть ассоциативно распределены по отраслям. Господа, начало повседневной работы по формированию позиции не даёт нам иного выбора, кроме определения позиций, занимаемых участниками в отношении поставленных задач. Сложно сказать, почему действия представителей оппозиции преданы социально-демократической анафеме. Следует отметить, что понимание сути ресурсосберегающих технологий способствует подготовке и реализации направлений прогрессивного развития. Противоположная точка зрения подразумевает, что базовые сценарии поведения пользователей лишь добавляют фракционных разногласий и заблокированы в рамках своих собственных рациональных ограничений! И нет сомнений, что явные признаки победы институционализации, вне зависимости от их уровня, должны быть в равной степени предоставлены сами себе. Приятно, граждане, наблюдать, как активно развивающиеся страны третьего мира объективно рассмотрены соответствующими инстанциями. Значимость этих проблем настолько очевидна, что дальнейшее развитие различных форм деятельности предопределяет высокую востребованность экономической целесообразности принимаемых решений. В целом, конечно, высокое качество позиционных исследований не даёт нам иного выбора, кроме определения форм воздействия. Являясь всего лишь частью общей картины, представители современных социальных резервов могут быть указаны как претенденты на роль ключевых факторов."
    }
}
