//
//  MYFirstIOSAppApp.swift
//  MYFirstIOSApp
//
//  Created by Ankit Bawanthade on 06/11/24.
//

import SwiftUI

@main
struct MYFirstIOSAppApp: App {
    
    @StateObject var listViewModel: ListViewModel = ListViewModel()
    
    var body: some Scene {
        WindowGroup {
            NavigationView {
                ListView()
            }
            .environmentObject(listViewModel)
            
        }
    }
}
