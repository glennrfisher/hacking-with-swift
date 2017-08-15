//: Playground - noun: a place where people can play

import Foundation

// non-mutating extension
extension Int {
    func plusOne() -> Int {
        return self + 1
    }
}

// mutating extension
extension Int {
    mutating func plusOneMutating() {
        self += 1
    }
}

var myInt = 0
myInt = myInt.plusOne()
myInt.plusOneMutating()

// extension on Integer protocol
extension Integer {
    func squared() -> Self {
        return self * self
    }
}

let myUInt = 4
myUInt.squared()

// extension for brevity
extension String {
    var trimmed: String {
        return self.trimmingCharacters(in: CharacterSet.whitespacesAndNewlines)
    }
}

"  trimmed text  \n  \n ".trimmed