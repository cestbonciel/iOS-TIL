//
//  ThemeView.swift
//  Scrumdinger
//
//  Created by Seohyun Kim on 2023/07/25.
//

import SwiftUI

struct ThemeView: View {
	let theme: Theme
	
    var body: some View {
		Text(theme.name)
			.padding(4)
			.frame(maxWidth: .infinity)
			.background(theme.mainColor)
			.foregroundColor(theme.accentColor)
			.clipShape(RoundedRectangle(cornerRadius: 10))
    }
}

struct ThemeView_Previews: PreviewProvider {
    static var previews: some View {
		ThemeView(theme: .buttercup)
    }
}
