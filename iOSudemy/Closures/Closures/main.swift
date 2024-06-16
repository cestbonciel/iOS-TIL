//
//  main2.swift
//  Closures
//
//  Created by Seohyun Kim on 2023/10/28.
//

import Foundation

let array = [6, 2, 4, 3, 1, 5]

func addOne(n1: Int) -> Int {
	return n1 + 1
}

/*
 { (n1: Int) -> Int in
	return n1 + 1
 }
 */
/*
 array.map({(n1: Int) -> Int in
	 return n1 + 1
	 }
 )
 
 array.map({(n1) in
		n1 + 1
	 }
 )
 
 */
//array.map(addOne)
print(array.map(addOne))

// Challenge -> Closure
print("use Closure: \(array.map { $0 + 1 })")

let newArray = array.map{"\($0)"}
print(newArray)
