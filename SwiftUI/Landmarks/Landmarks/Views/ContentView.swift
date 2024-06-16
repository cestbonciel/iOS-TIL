//
//  ContentView.swift
//  Landmarks
//
//  Created by Seohyun Kim on 2023/07/25.
//

import SwiftUI

struct ContentView: View {
    var body: some View {
		LandmarkList()
	}
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
		ContentView()
			.environmentObject(ModelData())
    }
}
