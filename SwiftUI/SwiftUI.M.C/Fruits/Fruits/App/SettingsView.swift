//
//  SettingsView.swift
//  Fruits
//
//  Created by Seohyun Kim on 2023/11/03.
//

import SwiftUI

struct SettingsView: View {
	//MARK: - PROPERTIES
	@Environment(\.presentationMode) var presentationMode
	@AppStorage("isOnboarding") var isOnboarding: Bool = false
	//MARK: - BODY
	var body: some View {
		NavigationStack {
			ScrollView(.vertical, showsIndicators: false) {
				VStack(spacing: 20) {
					//MARK: - SECTION 1
					
					GroupBox(
						label:
							SettingsLabelView(labelText: "Fruits", labelImage: "info.circle")
					) {
						Divider().padding(.vertical, 4)
						
						HStack(alignment: .center, spacing: 10) {
							Image("logo")
								.resizable()
								.scaledToFit()
								.frame(width: 80, height: 80)
								.cornerRadius(9)
							Text("Most fruits are naturally low in fat, sodium, and calories. None have cholesterol. Fuits are sources of many essential nutrients, including potassium, dietary fiber, vitamins, and much more.")
								.font(.footnote)
						}
					}
					
					//MARK: - SECTION 2
					GroupBox(
						label: SettingsLabelView(labelText: "Customization", labelImage: "paintbrush")
					) { 
						Divider().padding(.vertical, 4)
						
						Text("If you wish, you can restart the application by toggle the switch in this box. That way it starts the onboarding process and you will see the welcome screen again.")
							.padding(.vertical, 8)
							.frame(minHeight: 60)
							.layoutPriority(1)
							.font(.footnote)
							.multilineTextAlignment(.leading)
						
						Toggle(isOn: $isOnboarding) {
							if isOnboarding {
								Text("Restarted".uppercased())
									.fontWeight(.bold)
									.foregroundColor(Color.green)
							} else {
								Text("Restart".uppercased())
									.fontWeight(.bold)
									.foregroundColor(Color.secondary)
							}
						}
						.padding()
						.background(
							Color(UIColor.tertiarySystemBackground)
								.clipShape(RoundedRectangle(cornerRadius: 8, style: .continuous))
						)
					}
					//MARK: - SECTION 3
					GroupBox(
						label:
						SettingsLabelView(labelText: "Application", labelImage: "apps.iphone")
					) {
						SettingsRowView(name: "Developer", content: "John / Jane")
						SettingsRowView(name: "Designer", content: "Seohyun Kim")
						SettingsRowView(name: "Compatibility", content: "iOS 16")
						SettingsRowView(name: "Website", linkLabel: "Seohyun", linkDestination: "github.com/cestbonciel/iOS-TIL/tree/master/SwiftUI")
						SettingsRowView(name: "WWDC", linkLabel: "Apple", linkDestination: "developer.apple.com/wwdc23/")
						SettingsRowView(name: "SwiftUI",content: "5.0")
						SettingsRowView(name: "Version",content: "1.0.0")
					}
					
				}//: VSTACK
				.navigationBarTitle(Text("Settings"), displayMode: .large)
				.navigationBarItems(
					trailing:
						Button(action: {
							presentationMode.wrappedValue.dismiss()
						}, label: {
							Image(systemName: "xmark")
						})
				)
				.padding()
			}//: SCROLL
		}//: NAVIGATION
	}
}

//MARK: PREVIEW
struct SettingsView_Previews: PreviewProvider {
	static var previews: some View {
		SettingsView()
			.preferredColorScheme(.dark)
			.previewDevice("iPhone 14 Pro")
	}
}
