//
//  TodoItemCellView.swift
//  ToDoAppSwiftUI
//
//  Created by Sonya Fedorova on 18.07.2023.
//

import SwiftUI

struct TodoItemCellView: View {

    @State var model: TodoItem

    var verticalPadding: CGFloat {
        model.deadline == nil ? 16 : 12
    }

    private let dateFormatter: DateFormatter = {
        var dateFormatter = DateFormatter()
        dateFormatter.locale = Locale(identifier: "ru")
        dateFormatter.setLocalizedDateFormatFromTemplate("d MMMM")
        return dateFormatter
    }()

    var body: some View {
        HStack(alignment: .center, spacing: 12) {
            checkmarkImageView
                .onTapGesture {
                    withAnimation(.easeInOut(duration: 0.5)) {
                        model.isDone.toggle()
                    }
                }
            VStack(alignment: .leading, spacing: 0) {
                HStack(spacing: 2) {
                    if model.importance != .regular {
                        Text(Image(systemName: model.importance == .important ? "exclamationmark.2" : "arrow.down"))
                            .fontWeight(.bold)
                            .foregroundColor(Color(model.importance == .important ? "Red" : "Gray"))
                    }
                    Text(model.text)
                        .lineLimit(3)
                        .lineSpacing(0)
                        .strikethrough(model.isDone)
                        .foregroundColor(model.isDone ? Color("LabelTertiary") : nil)
                        .font(.system(size: 17, weight: .regular))
                }
                if model.deadline != nil {
                    deadlineView
                }
            }
        }
        .padding(EdgeInsets(top: verticalPadding, leading: 16, bottom: verticalPadding, trailing: 8))
        .frame(maxWidth: .infinity, alignment: .leading)
    }

    private var checkmarkImageView: some View {
        Image(getCheckmarkImageName())
            .renderingMode(model.isDone || model.importance == .important ? .original : .template)
            .foregroundColor(model.isDone || model.importance == .important ? nil : Color("Separator"))
    }

    private var deadlineView: some View {
        HStack(alignment: .center, spacing: 2) {
            Image(systemName: "calendar")
                .imageScale(.small)
            Text(dateFormatter.string(from: model.deadline ?? Date()))
                .font(.system(size: 15, weight: .regular))

        }
        .foregroundColor(Color("LabelTertiary"))
    }

    private func getCheckmarkImageName() -> String {
        if model.isDone {
            return "GreenCircle"
        } else {
            return model.importance == .important ? "RedCircle" : "GrayCircle"
        }
    }

}

struct TodoItemCellView_Previews: PreviewProvider {
    static var previews: some View {
        Group {
            TodoItemCellView(
                model: TodoItem(
                    text: "Важное задание с дедлайном",
                    importance: .important,
                    deadline: Date(),
                    isDone: false
                )
            )
            TodoItemCellView(
                model: TodoItem(
                    text: "Выполненное задание длинное очень очень очень очень очень очень очень очень очень"
                        .appending("очень очень очень очень очень очень очень очень очень очень"),
                    importance: .regular,
                    deadline: nil,
                    isDone: true
                )
            )
            TodoItemCellView(
                model: TodoItem(
                    text: "Неважное задание с дедлайном в две строчки",
                    importance: .unimportant,
                    deadline: Date(),
                    isDone: false
                )
            )
        }
        .border(.black)
    }
}
