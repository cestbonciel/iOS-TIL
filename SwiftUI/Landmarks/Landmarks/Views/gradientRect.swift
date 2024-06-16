//
//  gradientRect.swift
//  Landmarks
//
//  Created by Seohyun Kim on 2023/08/02.
//

import SwiftUI

// MARK: Path와 .fill(.linearGradient 로 그리기 연습 
struct gradientRect: View {
    var body: some View {
		Path { path in
			path.move(to: CGPoint(x: 20, y: 0))
			path.addLine(to: CGPoint(x: 20, y: 200))
			path.addLine(to: CGPoint(x: 220, y: 200))
//			path.addLine(to: CGPoint(x:250,y:0))
		}
		.fill(
			.linearGradient(
				colors: [.blue, .pink],
				startPoint: .init(x: 0.5, y: 0),
				endPoint: .init(x: 0.5, y: 0.5))
		)
    }
}

struct gradientRect_Previews: PreviewProvider {
    static var previews: some View {
        gradientRect()
    }
}
