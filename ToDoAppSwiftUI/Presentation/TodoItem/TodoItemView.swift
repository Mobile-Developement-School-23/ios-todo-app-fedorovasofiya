//
//  TodoItemView.swift
//  ToDoAppSwiftUI
//
//  Created by Sonya Fedorova on 21.07.2023.
//

import SwiftUI

struct TodoItemView: View {
    var model: TodoItem?
    @State var text: String

    init(model: TodoItem?) {
        self.model = model
        _text = State(initialValue: model?.text ?? "")
    }

    var body: some View {
        VStack(spacing: 16) {
            textView
            Spacer()
        }
        .background(Color("BackPrimary"))
        .navigationTitle("Дело")
        .navigationBarTitleDisplayMode(.inline)
    }

    private var textView: some View {
        ZStack(alignment: .topLeading) {
            TextEditor(text: $text)
                .padding(.vertical, 12)
                .padding(.horizontal, 16)
                .font(.system(size: 17))
                .background(Color(uiColor: .systemBackground))
                .cornerRadius(16)
                .padding(EdgeInsets(top: 16, leading: 16, bottom: 0, trailing: 16))
                .frame(height: 120)

            if text.isEmpty {
                Text("Что надо сделать?")
                    .foregroundColor(Color("LabelTertiary"))
                    .font(.system(size: 17))
                    .padding(EdgeInsets(top: 36, leading: 36, bottom: 0, trailing: 32))
            }
        }
    }

}

struct TodoItemView_Previews: PreviewProvider {
    static var previews: some View {
        TodoItemView(model: TodoItem(
            text: "Важное задание",
            importance: .important,
            deadline: Date(),
            isDone: false
        ))
    }
}
