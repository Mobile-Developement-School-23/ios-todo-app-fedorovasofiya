//
//  TodoListView.swift
//  ToDoAppSwiftUI
//
//  Created by Sonya Fedorova on 18.07.2023.
//

import SwiftUI

struct TodoListView: View {

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
            List {
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
            }
            .background(Color("BackPrimary"))
            .scrollContentBackground(.hidden)
            .navigationTitle("Мои дела")
        }
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        TodoListView()
    }
}
