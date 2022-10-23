//
//  Additional Algorithm Tests.swift
//  
//
//  Created by SukPoet on 2022/10/24.
//

import Foundation

//1 return the an element in Fibonacci’s numbers (0, 1, 1, 2, 3, 5, 8, 13, …) at n position
func fib(_ n: Int) -> Int {
    return n < 2 ? n : (fib(n-1) + fib(n-2))
}

//fib(6) returns 8

//2 
