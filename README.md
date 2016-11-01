# AC3.2-HigherOrderFunctions
Exercises on using map(), flatMap(), reduce(), filter()

---
### Related Readings

1. [Swift Guide to Map, Filter, Reduce - Use Your Loaf](http://useyourloaf.com/blog/swift-guide-to-map-filter-reduce/)
  - Nice brief explanation of each
2. [Higher Order Functions - We </3 Swift](https://www.weheartswift.com/higher-order-functions-map-filter-reduce-and-more/)
  - An excellent, and longer, example of each with accompanying for-in loop for comparison
3. [Demo Map, Filter, Reduce - Global Nerdy](http://www.globalnerdy.com/2016/06/26/demonstrating-map-filter-and-reduce-in-swift-using-food-emoji/)
  - Really cute example of these functions! Highly recommended if you're more of a visual learner. 
 
#### More advanced reads:
1. [flatMap - Natasha the Robot](https://www.natashatherobot.com/swift-2-flatmap/)
  - This is one of my favorite blogs; posts are usually very concise and have clear examples
2. [What do map and flatMap really do? - sketchytech](http://sketchytech.blogspot.com/2015/06/swift-what-do-map-and-flatmap-really-do.html)
  - Also one of my favorite blogs, but for entirely different reasons: he goes into incredible detail on each topic he covers. Be prepared to read one of his posts for at least a couple of hours.. not because of the length, but because of the amount of note-taking/research/practice you're going to have to do as you read along. This is a (normally) very advanced resource, but absolutely worth the time if you're interested in a topic he covers. 
  
---
### Why do we even need `map, filter, reduce, flatMap`?

It is soooo incredibly common to need to iterrate over collections when you're programming. I practically can't imagine an app where you're not going to have at least 1 collection you need to iterrate over in some way. It's equally as hard to imagine an app that only has a few of instances of having to iterrate over a collection.

That's the beauty of these 4 functions: they're intended to cut down on the amount of the most common code you'll need to write. Not only that, they're intended to be far more expressive that just using a `for-in` loop. On top of all of this, Swift developers regularly make use of them when putting together open source libraries or doing coding demos. 

It's going to take a little repeated exposure to these functions before you become comfortable with them. But once you acheive that familiarity, you're going to be able to really impress you peers with concise and clear code. 

---
### `map()`

__Usage: Use `map()` to loop over a collection and apply the same operation to each element in the collection.__

#### Declaration
```swift
  // for Array
  func map<T>((Element) -> T) -> [T]
  
  // for Dictionary
  func map<T>((Key, Value) -> T) -> [T]
```

<details><summary>Q1: Any thoughts on how we are suppose to read this?</summary>
<ol>
<li> map is used on a collection of type T
<li> map takes a closure of type (Element) -> T
<li> map returns an array of type T
<li> "Element" varies depending on the type of collection you're using map on (eg. Array v. Dictionary)
</ol>

Note: "Element" here is an associated type depending on the collection (for example, "Element" in a Dictionary is really a typealias: <pre>typealias Element = (key: Key, value: Value)</pre>)

</details>

Let's take a look at a particular example:

```swift
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
```

Iterrating over a collection to perform some function on its elements is so very common, which is what makes `map` so useful. Let's take a look at how to do the same thing with map()

```swift 
// map<Int>((Int) -> Int) -> [Int]
let squaredSequence = awaitingSquare.map { (x: Int) -> Int in
  return square(x: x)
}

// A bit neater, but due to Swift's type inference and implicit parameter and 
// return values, we can condense this code even further
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
```

Let's look at another example. In this theoretical example, say we had a list of users in a `Dictionary` where the user's firstname was the `Dictionary`'s `key` and their last name was the `value`. In this situation, we also need to display the user's names differently depending on which view we're on (for example in a social media app, its likely that a user's full name would appear on their profile page, whereas a shorthand form may exist on a post that they 'liked'):

```swift

// say we wanted to merge the key/value pairs in a Dictionary
let names = ["Alan" : "Turning", "Ada" : "Lovelace", "Grace" : "Hopper"]
let fullNames = names.map { (key: String, value: String) -> String in
  return key + " " + value
}

// ok great, but how about something with a little more substance?
// by defining closures for use in the map() functions, we can write substantially more readable and expressive code
struct NameFormatter {
  // makes a best guess that this is string interpolation judging by the '+' operator w/ a String
  static let lastNameFirstname = { $1 + ", " + $0 }
  static let firstLast = { $0 + " " + $1 }
  
  // we specify the type if there's a bit too much ambiguity 
  static let initialsOnly: (String, String) -> String = { "\($0.characters.first!). \($1.characters.first!)." }
  static let firstInitialLastName: (String, String) -> String = { "\($0.characters.first!). \($1)." }
}

names.map(NameFormatter.lastNameFirstname) // ["Lovelace, Ada", "Hopper, Grace", "Turning, Alan"]
names.map(NameFormatter.firstLast)         // ["Ada Lovelace", "Grace Hopper", "Alan Turning"]
names.map(NameFormatter.initialsOnly)      // ["A. L.", "G. H.", "A. T."]
names.map(NameFormatter.firstInitialLastName) // ["A. Lovelace.", "G. Hopper.", "A. Turning."]

// and the original object isn't changed
print(names)  // ["Ada": "Lovelace", "Grace": "Hopper", "Alan": "Turning"]
```

---
### `flatMap()`

Usage: It's intended to flatten a collection of collections. And that's great an all, but beyond the scope of what we need right now. Let's just think of `flatMap` as being `map` w/ free Optional handling. So all the things you can do with `map`, you can do with `flatMap` but now you don't have to worry about handling/dealing with Options.

```swift
let optionalInts: [Int?]  = [1, 2, nil, 4, nil, 5]
let validInts: [Int] = optionalInts.flatMap { $0 }
print(validInts) // [1, 2, 4, 5]
```

---
### `reduce()`

__Usage: Use `reduce` to combine all items in a collection to create a single new value.__

Most commonly, mathematical functions are used as examples for when you'd likely use reduce. For example, to get the sum of all of the `Int` in an array: 

```
// The most oft used example of reduce is with math functions:
let integerArray = [1, 1, 2, 3, 5, 8, 13, 21]
let sum = integerArray.reduce(0, +)
print(sum) // 54

// It might be easier to understand expanded out
let showYourWorkSum = integerArray.reduce(0) { (runningTotal: Int, current: Int) -> Int in
  print("\(runningTotal) + \(current) = \(runningTotal + current)")
  return runningTotal + current
}

// prints:
// 0 + 1 = 1
// 1 + 1 = 2
// 2 + 2 = 4
// 4 + 3 = 7
// 7 + 5 = 12
// 12 + 8 = 20
// 20 + 13 = 33
// 33 + 21 = 54
```

But, there are cases where you may want to combine other types, like `String` for example

```swift
let stringsArray = ["This", "might", "sound", "crazy", "but", "here's", "my", "collection", "so", "map", "me", "maybe"]
let reducedString = stringsArray.reduce("", { $0 + " " + $1 })
print(reducedString) // " This might sound crazy but here's my collection so map me maybe"
```

---
### `filter()`

While not directly pertinent to this (API's) lesson, `filter` is in this category of higher-order, collection function. You may have come across it before though so it's good to go through. 

__Usage: Loop over a collection and return an `Array` containing only those elements that match an include condition.__

As the name may imply, `filter` _filters_ out elements in a collection that match your specified criteria. 

```swift
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
```
