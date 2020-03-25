//
//  StringExtension.swift
//  calc
//
//  Created by Toai Duong on 19/3/20.
//  Copyright © 2020 UTS. All rights reserved.
//

import Foundation

extension String {
    
    // this is used to check if a string can be converted to an integer or not.
    var IsInt: Bool {
        Int(self) != nil
    }
    
    // this function is used to check if an string is an operator or not.
    static func IsOperator(operatorArgument: Operators) -> Bool {
        switch operatorArgument {
        case Operators.multiply, Operators.minus, Operators.plus, Operators.modulus, Operators.divide:
            return true
        default:
            return false
        }
    }
}


