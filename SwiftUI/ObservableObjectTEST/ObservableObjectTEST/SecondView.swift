//
//  SecondView.swift
//  ObservableObjectTEST
//
//  Created by Seohyun Kim on 2023/11/11.
//

import SwiftUI

struct SecondView: View {
	@EnvironmentObject var timerData: TimerData
	
    var body: some View {
		 VStack {
			 Text("Second View")
				 .font(.largeTitle)
				 .foregroundColor(.indigo)
			 Text("Timer count = ⏳ \(timerData.timeCount)")
				 .padding(8)
				 .font(.headline)
				 .foregroundColor(.black)
		 }
		 
    }
}

struct SecondView_Previews: PreviewProvider {
    static var previews: some View {
		 SecondView().environmentObject(TimerData())
    }
}
