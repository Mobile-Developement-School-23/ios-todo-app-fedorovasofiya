//
//  CreateNewCellView.swift
//  ToDoAppSwiftUI
//
//  Created by Sonya Fedorova on 21.07.2023.
//

import SwiftUI

struct CreateNewCellView: View {
    var body: some View {
        HStack(alignment: .center, spacing: 12) {
            Image("GrayCircle")
                .opacity(0)
            Text("Новое")
                .foregroundColor(Color("LabelTertiary"))
                .font(.system(size: 17, weight: .regular))
        }
        .padding(EdgeInsets(top: 16, leading: 16, bottom: 16, trailing: 8))
        .frame(maxWidth: .infinity, alignment: .leading)
    }
}

struct CreateNewCellView_Previews: PreviewProvider {
    static var previews: some View {
        CreateNewCellView()
            .border(.black)
    }
}
