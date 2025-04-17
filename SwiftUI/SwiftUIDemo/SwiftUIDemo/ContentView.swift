//
//  ContentView.swift
//  SwiftUIDemo
//
//  Created by Nat Kim on 4/17/25.
//

import SwiftUI

struct ContentView: View {
    var colors: [Color] = [.red, .green, .blue, .orange, .purple]
    var colorsname = ["Red", "Green", "Blue", "Orange", "Purple"]
    
    @State private var colorIndex = 0
    @State private var rotation: Double = 0.0
    @State private var text: String = "Welcome to SwiftUI"
    var body: some View {
        VStack {
            Spacer()
            Text(text)
                .font(.largeTitle)
                .fontWeight(.heavy)
                .rotationEffect(.degrees(rotation))
                .animation(.easeInOut(duration: 5), value: rotation)
                .foregroundColor(colors[colorIndex])
            Spacer()
            Divider()
            Slider(value: $rotation, in: 0...360, step: 0.1)
                .padding()
            
            TextField("Enter Text here", text: $text)
                .textFieldStyle(RoundedBorderTextFieldStyle())
                .padding()
            
            Picker(selection: $colorIndex, label: Text("Color")) {
                ForEach(0..<colorsname.count, id: \.self) {
                    Text(colorsname[$0])
                        .foregroundColor(colors[$0])
                }
            }
            .pickerStyle(.wheel)
            .padding()
                
        }
    }
}

#Preview {
    ContentView()
}
