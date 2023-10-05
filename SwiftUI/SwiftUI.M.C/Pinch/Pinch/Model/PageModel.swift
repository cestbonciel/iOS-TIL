//
//  PageModel.swift
//  Pinch
//
//  Created by Seohyun Kim on 2023/10/05.
//

import Foundation

struct Page: Identifiable {
	let id: Int
	let imageName: String
	
}

extension Page {
	var thumbnailName: String {
		return "thumb-" + imageName
	}
	
}
