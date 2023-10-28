//
//  main.swift
//  Closures
//
//  Created by Seohyun Kim on 2023/10/28.
//

import Foundation

func calculator(num1: Int, num2: Int, operationNums: (Int, Int) -> Int) -> Int {
	return operationNums(num1, num2)
}

func truncateRemainder(first: Int, second: Int) -> Int {
	let x = 8.625 * Double(first)
	print("Double First Number: \(first)")
	print("x:\(x)")
	var Changedfirst = first

	let q = Float(x.truncatingRemainder(dividingBy: 3.14))
	print("Float q: \(q)")
	Changedfirst = Int(q)
	print("ChangeFirst:\(Changedfirst)")
	return Int(Changedfirst) + Int(second)
}

func addNums(no1: Int, no2: Int) -> Int {
	return no1 + no2
}

//func addMultiply(no1: Int, no2: Int) -> Int {
//	return no1 * no2
//}


print("1")
print("calculator + truncateRemainder: \(calculator(num1: 3, num2: 1, operationNums: truncateRemainder(first:second:)))")
print("divider: ------")
print("2")
print("calculator + add: \(calculator(num1: 40, num2: 30, operationNums: addNums))")
print("3.")
//print("multiply: \(calculator(num1: 4, num2: 1, operationNums: addMultiply(no1:no2:)))")

// MARK: - Expression of Closure
//calculator(num1: 2, num2: 3, operationNums: { (no1, no2) in no1 * no2 })
//let result = calculator(num1: 2, num2: 3, operationNums: { $0 * $1 })
let result = calculator(num1: 4, num2: 1) { $0 * $1 }
// no1 -> $0, no2 -> $1
print("result: \(result)")
