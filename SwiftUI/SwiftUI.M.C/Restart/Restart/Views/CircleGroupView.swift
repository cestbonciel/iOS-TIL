//
//  CircleGroupView.swift
//  Restart
//
//  Created by Seohyun Kim on 2023/09/22.
//

import SwiftUI

struct CircleGroupView: View {
	//MARK: - Property
	
	@State var shapeColor: Color
	@State var shapeOpacity: Double
    var body: some View {
			ZStack {
				Circle()
					.stroke(shapeColor.opacity(shapeOpacity), lineWidth: 40)
					.frame(width: 260, height: 260, alignment: .center)
				Circle()
					.stroke(shapeColor.opacity(shapeOpacity), lineWidth: 80)
					.frame(width: 260, height: 260, alignment: .center)
			}//: ZSTACK
    }
}

struct CircleGroupView_Previews: PreviewProvider {
    static var previews: some View {
			ZStack {
				Color("ColorGreen")
					.ignoresSafeArea(.all, edges: .all)
				CircleGroupView(shapeColor: .white, shapeOpacity: 0.2)
			}
    }
}
