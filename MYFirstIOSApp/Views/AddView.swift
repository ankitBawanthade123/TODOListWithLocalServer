//
//  AddView.swift
//  MYFirstIOSApp
//
//  Created by Ankit Bawanthade on 15/11/24.
//

import SwiftUI

struct AddView: View {
    
    @Environment(\.presentationMode) var presentationMode
    @EnvironmentObject var listViewModel: ListViewModel
    @State var textFieldInput: String = ""
    @State var alertTitle: String = ""
    @State var showAlert: Bool = false

    var body: some View {
        ScrollView {
            VStack{
                TextField("Type Something Here......", text: $textFieldInput)
                    .frame(height: 50)
                    .background(Color.white)
                    .cornerRadius(10)
                    .padding(EdgeInsets(top: 20, leading: 10, bottom: 10, trailing: 10))
                Button(action: saveButtonPressed, label: {
                    Text("Save".uppercased())
                        .foregroundColor(.white)
                        .frame(height: 55)
                        .frame(maxWidth: .infinity)
                        .background(Color.blue)
                        .cornerRadius(20)
                        .padding(EdgeInsets(top: 10, leading: 20, bottom: 20, trailing: 10))
                })
            }
        }
        .navigationTitle("Add an item 🖊️")
        .alert(isPresented: $showAlert) {
            getAlert()
        }
    }
    
    func saveButtonPressed() {
        if textIsAppropriate() {
            listViewModel.addItem(title: textFieldInput)
            presentationMode.wrappedValue.dismiss()
        } else {
            showAlert = true
        }
    }
    
    func textIsAppropriate() -> Bool {
        if textFieldInput.count >= 3 {
            return true
        } else {
            alertTitle = "Your text should be greater than 3"
            return false
        }
        
    }
    
    func getAlert() -> Alert {
        return Alert(title: Text(alertTitle))
    }
}

struct AddView_Previews: PreviewProvider {
    static var previews: some View {
        NavigationView {
            AddView()
        }
        .environmentObject(ListViewModel())
    }
}
