//
//  TodoListView.swift
//  ToDoAppSwiftUI
//
//  Created by Sonya Fedorova on 18.07.2023.
//

import SwiftUI

struct TodoListView: View {

    @State var isAllVisible: Bool = false

    var items: [TodoItem] = [
        TodoItem(
            text: "Важное задание с дедлайном",
            importance: .important,
            deadline: Date(),
            isDone: false
        ),
        TodoItem(
            text: "Выполненное задание длинное очень очень очень очень очень очень очень очень очень"
                .appending("очень очень очень очень очень очень очень очень очень очень"),
            importance: .regular,
            deadline: nil,
            isDone: true
        ),
        TodoItem(
            text: "Неважное задание с дедлайном в две строчки",
            importance: .unimportant,
            deadline: Date(),
            isDone: false
        )
    ]

    var body: some View {
        NavigationView {
            ZStack(alignment: .bottom) {
                List {
                    Section {
                        ForEach(items) { item in
                            NavigationLink {
                                Text(item.text)
                            } label: {
                                TodoItemCellView(model: item)
                            }
                        }
                        .listRowBackground(Color("BackSecondary"))
                        .listRowInsets(EdgeInsets(top: 0, leading: 0, bottom: 0, trailing: 16))
                        ZStack(alignment: .leading) {
                            CreateNewCellView()
                            NavigationLink(destination: Text("Новое")) {
                                EmptyView()
                            }
                            .opacity(0.0)
                        }
                        .listRowBackground(Color("BackSecondary"))
                        .listRowInsets(EdgeInsets(top: 0, leading: 0, bottom: 0, trailing: 16))
                    } header: {
                        headerView
                            .textCase(.none)
                            .listRowInsets(EdgeInsets(top: 10, leading: 14, bottom: 12, trailing: 14))
                    }
                }
                .background(Color("BackPrimary"))
                .scrollContentBackground(.hidden)
                .navigationTitle("Мои дела")
                .listStyle(.insetGrouped)

                addButton
                    .padding(EdgeInsets(top: 0, leading: 0, bottom: 20, trailing: 0))
            }
        }
    }

    private var headerView: some View {
        HStack {
            Text("Выполнено — 5")
                .font(.system(size: 15))
            Spacer()
            Button(isAllVisible ? "Скрыть" : "Показать") {
                withAnimation {
                    isAllVisible.toggle()
                }
            }
            .font(.system(size: 15, weight: .semibold))
        }
    }

    private var addButton: some View {
        Button {
            print("button")
        } label: {
            Image(systemName: "plus")
                .imageScale(.large)
                .font(.system(size: 20))
                .fontWeight(.bold)
                .foregroundColor(.white)
        }
        .frame(width: 44, height: 44)
        .background(Color(.systemBlue))
        .cornerRadius(22)
        .shadow(color: Color("Shadow"), radius: 10, x: 0, y: 8)
    }

//    private func setupPlusButton() {
//        let imageConfig = UIImage.SymbolConfiguration(pointSize: 20, weight: .bold, scale: .large)
//        let plusImage = UIImage(systemName: "plus", withConfiguration: imageConfig)?
//            .withTintColor(.white, renderingMode: .alwaysOriginal)
//        plusButton.setImage(plusImage, for: .normal)
//        plusButton.backgroundColor = .systemBlue
//        plusButton.layer.cornerRadius = Constants.buttonSize / 2
//        plusButton.layer.shadowColor = UIColor(named: "Shadow")?.cgColor
//        plusButton.layer.shadowRadius = Constants.shadowRadius
//        plusButton.layer.shadowOpacity = 1
//        plusButton.layer.shadowOffset = CGSize(width: 0, height: Constants.shadowOffsetY)
//        plusButton.translatesAutoresizingMaskIntoConstraints = false
//        view.addSubview(plusButton)
//
//        let safeArea = view.safeAreaLayoutGuide
//        NSLayoutConstraint.activate([
//            plusButton.centerXAnchor.constraint(equalTo: view.centerXAnchor),
//            plusButton.bottomAnchor.constraint(equalTo: safeArea.bottomAnchor, constant: -Constants.bottomMargin),
//            plusButton.widthAnchor.constraint(equalToConstant: Constants.buttonSize),
//            plusButton.heightAnchor.constraint(equalToConstant: Constants.buttonSize)
//        ])
//
//        plusButton.addAction(
//            UIAction(handler: { [weak self] _ in self?.viewOutput.didTapAdd() }),
//            for: .touchUpInside
//        )
//    }

}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        TodoListView()
    }
}
