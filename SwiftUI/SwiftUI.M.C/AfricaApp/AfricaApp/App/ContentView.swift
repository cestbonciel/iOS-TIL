//
//  ContentView.swift
//  AfricaApp
//
//  Created by Nat Kim on 2023/12/26.
//

import SwiftUI

struct ContentView: View {
    var body: some View {
        // MARK: - PROPERTIES
        let animals: [Animal] = Bundle.main.decode("animals.json")
        // MARK: - BODY
        NavigationStack {
            List {
                CoverImageView()
                    .frame(height: 300)
                    .listRowInsets(EdgeInsets(top: 0, leading: 0, bottom: 0, trailing: 0))
                
                ForEach(animals) { animal in
                    AnimalListItemView(animal: animal)
                }
            }//: LIST
            .navigationTitle("Africa")
            //.navigationBarTitleDisplayMode(.large)
        } //: NAVIGAITON
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
