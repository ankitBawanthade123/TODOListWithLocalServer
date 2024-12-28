//
//  ItemModel.swift
//  MYFirstIOSApp
//
//  Created by Ankit Bawanthade on 15/11/24.
//

import Foundation

struct ItemModel: Codable {
    let _id: String?
    let noteId: String
    let title: String
    let isCompleted: String
    
    init(noteId: String, title: String, isCompleted: Bool) {
        self._id = nil
        self.noteId = noteId
        self.title = title
        self.isCompleted = String(isCompleted)
    }
    
    init(_id: String?, noteId: String, title: String, isCompleted: Bool) {
        self._id = _id
        self.noteId = noteId
        self.title = title
        self.isCompleted = String(isCompleted)
    }
    
    func encode(to encoder: Encoder) throws {
            var container = encoder.container(keyedBy: CodingKeys.self)
            try container.encode(noteId, forKey: .noteId)
            try container.encode(title, forKey: .title)
            try container.encode(isCompleted, forKey: .isCompleted)
        }
    
    init(from decoder: Decoder) throws {
            let container = try decoder.container(keyedBy: CodingKeys.self)
            _id = try container.decodeIfPresent(String.self, forKey: ._id)
            noteId = try container.decode(String.self, forKey: .noteId)
            title = try container.decode(String.self, forKey: .title)
            isCompleted = try container.decode(String.self, forKey: .isCompleted)
        }
    
    private enum CodingKeys: String, CodingKey {
            case _id
            case noteId
            case title
            case isCompleted
        }
    
    
    func updateCompletion() -> ItemModel {
        let updatedState = isCompleted == "true" ? false : true
        return ItemModel(_id: _id, noteId: noteId, title: title, isCompleted: updatedState)
    }
}
