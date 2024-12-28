//
//  NoItemsView.swift
//  MYFirstIOSApp
//
//  Created by Ankit Bawanthade on 19/11/24.
//

import SwiftUI

struct NoItemsView: View {
    
    @State var animate:Bool = false
    var body: some View {
        ScrollView {
            VStack(spacing: 20) {
                Text("No items present")
                    .font(.title)
                    .fontWeight(.semibold)
                Text("Add your first item to improve your productivity. Click on below button")
                NavigationLink(destination: AddView(),
                               label: {
                    Text("Add Item")
                        .foregroundColor(.white)
                        .font(.headline)
                        .frame(height: 55)
                        .frame(maxWidth: .infinity)
                        .background(animate ? Color.red : Color.accentColor)
                        .cornerRadius(10)
                })
            }
            .multilineTextAlignment(.center)
            .padding(40)
            .onAppear(perform: addAnimation)
        }
        .frame(maxWidth: .infinity, maxHeight: .infinity)
    }
    
    func addAnimation() {
        guard !animate else { return }
        DispatchQueue.main.asyncAfter(deadline: .now() + 1.5) {
            withAnimation(Animation.easeInOut(duration: 2.5).repeatForever()) {
                animate.toggle()
            }
        }
    }
}

struct NoItemsView_Previews: PreviewProvider {
    static var previews: some View {
        NoItemsView()
    }
}
