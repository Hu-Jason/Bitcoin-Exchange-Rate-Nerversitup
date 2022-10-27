//
//  Additional Algorithm Tests.swift
//  
//
//  Created by SukPoet on 2022/10/24.
//

import Foundation

//1 return the an element in Fibonacci’s numbers (0, 1, 1, 2, 3, 5, 8, 13, …) at n position
// Use recursion
func fib(first: Int, second: Int, at n: Int) -> Int {
    if n <= 0 {
        return 0
    } else if n < 3 {
        return 1
    } else if n == 3 {
        return first + second
    } else {
        return fib(first: second, second: first + second, at: n - 1)
    }
}

fib(first: 1, second: 1, at: 6) //will returns 8
fib(first: 1, second: 1, at: 7) //will returns 13
fib(first: 1, second: 1, at: 8) //will returns 21
//Time complexity O(n)
//Space complexity O(n)


//2 filter prime numbers (2, 3, 5, 7, 11, 13, 17, 19, …) from range 0..<n
func primes(n: Int) -> [Int] {
    var numbers = [Int](2 ..< n)
    for i in 0..<n - 2 {
        let prime = numbers[i]
        guard prime > 0 else { continue }
        for multiple in stride(from: 2 * prime - 2, to: n - 2, by: prime){
            numbers[multiple] = 0
        }
    }
    return numbers.filter{ $0 > 0 }
}

primes(n: 20) //will return [2, 3, 5, 7, 11, 13, 17, 19]
//Time complexity O(n^2)
//Space complexity O(n)


//3  filter an array from an array of two numbers, leaving only the members of the first array left in the second array, without using existing functions such as map, filter, contain, etc
//For example: a = [1,2,3,4,5,6] , b = [2,4,6] Write code to remove numbers in a that do not exist in b, without using .map .filter .contain, etc.
//This is a generic function. It can filter array of any types as long as the element conforms Equatable protocal
func filter<T: Equatable>(a: inout [T], against b: inout [T]) {
    for x in a {
        var notFoundXInB = true
        for y in b {
            if x == y {
                notFoundXInB = false
                break
            }
        }
        if notFoundXInB {
            a.removeAll { $0 == x }
        }
    }
}

var a = [1,2,3,4,5,6]
var b = [2,4,6]
filter(a: &a, against: &b)
print(a) //a will become [2, 4, 6]
var c = [2,6,1,5,2,3,4,5,6,7,9,11]
var d = [2,4,6]
filter(a: &c, against: &d)
print(c) //c will become [2, 6, 2, 4, 6]
//Time complexity O(n^2)
//Space complexity O(n)
