//
//  ListRowView.swift
//  MYFirstIOSApp
//
//  Created by Ankit Bawanthade on 15/11/24.
//

import SwiftUI

struct ListRowView: View {
    let item: ItemModel
    var body: some View {
        HStack {
            Image(systemName: item.isCompleted == "true" ? "checkmark.circle" : "circle" )
                .foregroundColor(item.isCompleted == "true" ? Color.green: Color.red)
            Text(item.title)
            Spacer()
        }
        .font(.title2)
        .padding(.vertical, 8)
    }
}

struct ListRowView_Previews: PreviewProvider {
    static var previewItem1 = ItemModel(noteId: "randomID1", title: "Preview Item 1", isCompleted: false)
    static var previewItem2 = ItemModel(noteId: "randomId2", title: "Preview Item 2", isCompleted: true)

    static var previews: some View {
        Group {
            ListRowView(item: previewItem1)
            ListRowView(item: previewItem2)
        }
        .previewLayout(.sizeThatFits)
    }
}
