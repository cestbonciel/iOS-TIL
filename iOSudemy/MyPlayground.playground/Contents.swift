import UIKit

/*
// This is a comment.
print("Hello, playground!")

/*
 This is a multiple line comment.
 I'm a iOS developer.
 Hello, Playground!
 */

// Print Statement
print("Hello, 2+3 playground!")
// String Interpolation
print("Hello,\(2+3) playground!")

print("The result of 5 + 3 = \(5+3)")
*/
/*
var a = 5

var b = 8

var c = a
a = b
b = c

print ("The value of a is \(a)")

print("The value of b is \(b)")
*/

var numbers = [45, 75, 195, 53]

var computedNumbers = numbers.enumerated().map { $1 * numbers[($0 + 1) % numbers.count] }

print(computedNumbers)


