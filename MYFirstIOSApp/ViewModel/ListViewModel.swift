//
//  ListViewModel.swift
//  MYFirstIOSApp
//
//  Created by Ankit Bawanthade on 18/11/24.
//

import Foundation

class ListViewModel: ObservableObject {
    @Published var items: [ItemModel] = [] {
        didSet {
            saveItems()
        }
    }
    let itemKey: String = "items_key"
    
    init() {
        Task {
            do {
                try await getItems()
            } catch {
                print("Failed to fetch items: \(error)")
            }
        }
    }
    
    func getItems() async throws {
        
        let endpoint = "http://192.168.1.142:8081/fetch"
        guard let url = URL(string: endpoint) else {
            print("Invalid URL error")
            return
        }
        
        let (data, res) = try await URLSession.shared.data(from: url)
        
        guard let httpResponse = res as? HTTPURLResponse, httpResponse.statusCode == 200 else {
            throw URLError(.badServerResponse)
        }
        
        let wrapper = try JSONDecoder().decode([ItemModel].self, from: data)
        DispatchQueue.main.async {
            self.items = wrapper
            print(self.items)
        }
    }
    
    func addItem(title: String) {
        let noteId = UUID().uuidString
        let newItem = ItemModel(noteId: noteId, title: title, isCompleted: false)

        // Add the new item locally
        DispatchQueue.main.async {
            self.items.append(newItem)
        }

        let endpoint = "http://192.168.1.142:8081/create"
        guard let url = URL(string: endpoint) else {
            print("Invalid URL error")
            return
        }

        var request = URLRequest(url: url)
        request.httpMethod = "POST"


        request.setValue(newItem.noteId, forHTTPHeaderField: "noteId")
        request.setValue(newItem.title, forHTTPHeaderField: "title")
        request.setValue(newItem.isCompleted, forHTTPHeaderField: "isCompleted")
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")
        

        let task = URLSession.shared.dataTask(with: request) { data, response, error in
            // Check for errors
            if let error = error {
                print("Request error: \(error.localizedDescription)")
                return
            }
            
            // Validate HTTP response
            guard let httpResponse = response as? HTTPURLResponse else {
                print("Invalid response")
                return
            }
            
            // Check status code
            if httpResponse.statusCode == 200 {
                print("SUCCESS")
                
                // Decode and print response data if available
                if let data = data, let jsonString = String(data: data, encoding: .utf8) {
                    print("Response JSON: \(jsonString)")
                }
            } else {
                print("FAILURE: Status code \(httpResponse.statusCode)")
                if let data = data, let errorMessage = String(data: data, encoding: .utf8) {
                    print("Error response: \(errorMessage)")
                }
            }
        }

        task.resume()

    }
    
    func moveItem(indexSet: IndexSet, moveTo: Int) {
        items.move(fromOffsets: indexSet, toOffset: moveTo)
    }
    
    func deleteItem(indexSet: IndexSet) {
        guard let item = indexSet.first else { return }
        deleteNote(item: items[item])
        items.remove(atOffsets: indexSet)
    }
    
    func deleteNote(item: ItemModel) {
        let endpoint = "http://192.168.1.142:8081/delete"
        guard let url = URL(string: endpoint) else {
            print("Invalid URL error")
            return
        }

        var request = URLRequest(url: url)
        request.httpMethod = "POST"

        do {
//            let data = try JSONEncoder().encode(item)
            request.setValue(item._id, forHTTPHeaderField: "id")
        } catch {
            print("Failed to encode new item: \(error)")
            return
        }

        let task = URLSession.shared.dataTask(with: request) { data, response, error in
            // Check for errors
            if let error = error {
                print("Request error: \(error.localizedDescription)")
                return
            }
            
            // Validate HTTP response
            guard let httpResponse = response as? HTTPURLResponse else {
                print("Invalid response")
                return
            }
            
            // Check status code
            if httpResponse.statusCode == 200 {
                print("SUCCESS")
                
                // Decode and print response data if available
                if let data = data, let jsonString = String(data: data, encoding: .utf8) {
                    print("Response JSON: \(jsonString)")
                }
            } else {
                print("FAILURE: Status code \(httpResponse.statusCode)")
                if let data = data, let errorMessage = String(data: data, encoding: .utf8) {
                    print("Error response: \(errorMessage)")
                }
            }
        }

        task.resume()

    }
    
    func updateItem(item: ItemModel) {
        if let index = items.firstIndex(where: { $0._id == item._id}) {
            items[index] = items[index].updateCompletion()
            postUpdates(item: items[index])
        }
    }
    
    func postUpdates(item: ItemModel) {
        let endpoint = "http://192.168.1.142:8081/update"
        guard let url = URL(string: endpoint) else {
            print("Invalid URL error")
            return
        }

        var request = URLRequest(url: url)
        request.httpMethod = "POST"

        do {
//            let data = try JSONEncoder().encode(item)
            request.setValue(item._id, forHTTPHeaderField: "id")
            request.setValue(item.noteId, forHTTPHeaderField: "noteId")
            request.setValue(item.title, forHTTPHeaderField: "title")
            request.setValue(item.isCompleted, forHTTPHeaderField: "isCompleted")
            request.setValue("application/json", forHTTPHeaderField: "Content-Type")
        } catch {
            print("Failed to encode new item: \(error)")
            return
        }

        let task = URLSession.shared.dataTask(with: request) { data, response, error in
            // Check for errors
            if let error = error {
                print("Request error: \(error.localizedDescription)")
                return
            }
            
            // Validate HTTP response
            guard let httpResponse = response as? HTTPURLResponse else {
                print("Invalid response")
                return
            }
            
            // Check status code
            if httpResponse.statusCode == 200 {
                print("SUCCESS")
                
                // Decode and print response data if available
                if let data = data, let jsonString = String(data: data, encoding: .utf8) {
                    print("Response JSON: \(jsonString)")
                }
            } else {
                print("FAILURE: Status code \(httpResponse.statusCode)")
                if let data = data, let errorMessage = String(data: data, encoding: .utf8) {
                    print("Error response: \(errorMessage)")
                }
            }
        }

        task.resume()

    }
    
    func saveItems() {
        if let encodedData = try? JSONEncoder().encode(items) {
            UserDefaults.standard.set(encodedData, forKey: itemKey)
        }
            
    }
}
