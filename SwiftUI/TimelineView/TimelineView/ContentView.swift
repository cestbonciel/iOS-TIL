//
//  ContentView.swift
//  TimelineView
//
//  Created by Seohyun Kim on 2023/08/09.
//

import SwiftUI

struct ContentView: View {
    var body: some View {
		TimelineView(.periodic(from: Date(), by: 1.0)) { context in
			let date = context.date
			let seconds = Calendar.current.component(.second, from: date)
			Circle()
				.trim(from: 0, to: Double(seconds)/60.0)
				.stroke(seconds < 50 ? .blue : .red, lineWidth: 30)
				.rotationEffect(.degrees(-90))
				.overlay {
					Text("\(seconds)")
				}
				.padding()
		}
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
