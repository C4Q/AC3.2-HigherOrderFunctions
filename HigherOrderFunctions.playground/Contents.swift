//: Playground - noun: a place where people can play

import UIKit

// ----
// MARK: using map()
// Usage: Use map() to loop over a collection and apply the same operation to each element in the collection.


// let's take a theoretical function that could be used to get the square of a number, x:
func square(x: Int) -> Int {
  return x * x
}

// if we had an Array<Int>, going through them in order to square each value, we could use a for-in loop like:
let awaitingSquare = [1, 2, 3, 4, 5, 6]
var squared: [Int] = []
for n in awaitingSquare {
  squared.append(square(x: n))
}
print(squared) // prints [1, 4, 9, 16, 25, 36]

// Let's take a look at how to do the same thing with map()
let squaredSequence = awaitingSquare.map { (x: Int) -> Int in
  return square(x: x)
}

// A bit neater, but due to Swift's type inference and implicit parameter and return values, we can condense this code even further

// return value is implicit and not stated
let implicitSequence = awaitingSquare.map { (x: Int) in
  return square(x: x)
}

// paramter can also be implicit
let moreImplicitSequence = awaitingSquare.map {
  return square(x: $0)
}

// returning is implicit
let evenMoreImplicit = awaitingSquare.map { square(x: $0) }

// argueably, this is more readable
let bareBonesImplicit = awaitingSquare.map { $0 * $0 }

let names = ["Alan" : "Turning", "Ada" : "Lovelace", "Grace" : "Hopper"]
let fullNames = names.map { (key: String, value: String) -> String in
  return key + " " + value
}

struct NameFormatter {
  // makes a best guess that this is string interpolation judging by the + operator w/ a String
  static let lastNameFirstname = { $1 + ", " + $0 }
  static let firstLast = { $0 + " " + $1 }
  
  // a little too much ambiguity, so we specify the type here
  static let initialsOnly: (String, String) -> String = { "\($0.characters.first!). \($1.characters.first!)." }
  static let firstInitialLastName: (String, String) -> String = {
    "\($0.characters.first!). \($1)."
  }
}

names.map(NameFormatter.lastNameFirstname)
names.map(NameFormatter.firstLast)
names.map(NameFormatter.initialsOnly)
names.map(NameFormatter.firstInitialLastName)

// and what's great is that the original object isn't changed
print(names)


// ----
// MARK: using flatMap()
// This is a fairly simple example, but could also be extended to other data types, for slightly more complicated functions. Let's say we have a list of files that we've retrieved from a folder on our iphone, but we needed to seperate the file name from their extension (as we had to do when parsing the file name in a URL in order to search fro it in our Bundle.main
let filenameList: [Any] = ["cute_cat.jpg", "cute_dog.jpg", "essay_cats-are-the-best.doc", "turtles_are_ok.png", "baby_otters.svg"]

var separatedValues: [String : String] = [:]
for file in filenameList as! [String] {
  
  let components = file.components(separatedBy: ".")
  guard
    let key = components.first,
    let value = components.last else {
      continue
  }
  
  separatedValues[key] = value
}
print(separatedValues)

// And now with map
let mapSeparatedValues = filenameList.flatMap { (filename: Any) -> [String : String]? in
  let components = (filename as! String).components(separatedBy: ".")
  guard
    let key = components.first,
    let value = components.last else {
      return nil
  }
  
  return [key : value]
  }


let optionalInts: [Int?]  = [1, 2, nil, 4, nil, 5]
let validInts: [Int] = optionalInts.flatMap { $0 }
print(validInts)

// ----
// MARK: using reduce()
// The most oft used example of reduce is with math functions:
let integerArray = [1, 1, 2, 3, 5, 8, 13, 21]
let sum = integerArray.reduce(0, +)

// It might be easier to understand expanded out
let showYourWorkSum = integerArray.reduce(0) { (runningTotal: Int, current: Int) -> Int in
  print("\(runningTotal) + \(current) = \(runningTotal + current)")
  return runningTotal + current
}

// but you can extend this to other data types, such as strings
let stringsArray = ["This", "might", "sound", "crazy", "but", "here's", "my", "collection", "so", "map", "me", "maybe"]
let concat = stringsArray.reduce("", { $0 + " " + $1 })
print(concat)

// let's get crazy now...
let chained = names.map( NameFormatter.firstInitialLastName ).reduce("",  { $0 + "Honoree: " + $1 + "\n" })
print(chained)


// ----
// MARK: using filter()

// doing some basic even/odd filtering using %
let intArray: [Int] = [1, 2, 3, 4, 5, 6, 7, 8, 9, 10]
let evens: [Int] = intArray.filter { (number: Int) -> Bool in
  if number % 2 == 0 {
    return true
  }
  return false
}

let odds: [Int] = intArray.filter { (number: Int) -> Bool in
  if number % 2 == 0 {
    return false
  }
  return true
}

print(evens)
print(odds)

// works with words too
let wordsTheContainM = stringsArray.filter { (word: String) -> Bool in
  if word.characters.contains("m") {
    return true
  }
  return false
}

print(wordsTheContainM)