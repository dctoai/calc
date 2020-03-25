//
//  Calculator.swift
//  calc
//
//  Created by Toai Duong on 20/3/20.
//  Copyright © 2020 UTS. All rights reserved.
//

import Foundation

class Calculator {
    let consoleIO = ConsoleIO()
    var arrayOfArguments: [String] = []
    var priorityOperatorIndex: Int = 0
    
    // This function is used to check user input is correct or not.
    // In includes numbers input and operator input
    private func CheckParametersInput() throws {
        let argCount = CommandLine.argc
        for index in 1..<argCount {
            // if input is at odd position, it is a number. So we need to check if this position is a number or not.
            // if it is not a number, we should throw exception, otherwise we add that number to an array.
            // we will use this array for calculations
            if index % 2 != 0 {
                guard CommandLine.arguments[Int(index)].IsInt else {
                    throw CalculationError.notNumber(CommandLine.arguments[Int(index)])
                }
                
                arrayOfArguments.append(CommandLine.arguments[Int(index)])
            }
                // if input is at odd even, it is an operator. So we need to check if this position is an opererator or not.
                // if it is not an operator, we should throw exception, otherwise we add that operator to an array.
            else {
                guard String.IsOperator(operatorArgument: Operators(rawValue: CommandLine.arguments[Int(index)]) ?? Operators.unknown) else {
                    throw CalculationError.notOperator(CommandLine.arguments[Int(index)])
                }
                
                arrayOfArguments.append(CommandLine.arguments[Int(index)])
            }
        }
    }
    
    /*
     This function is used to perform all calculations of user inputs
     */
    func PerformCalculate() throws -> Int{
        try CheckParametersInput()
        try PerformHighPriorityCalculation()
        try PerformLowPriorityCalculatrion()
        // throw error if the user does not input any argument
        guard arrayOfArguments.count > 0 else {
            throw CalculationError.outOfBoundException
        }
        return (Int(arrayOfArguments[0])!)
    }
    
    private func PerformLowPriorityCalculatrion() throws {
        var firstVal: Int
        var secondVal: Int
        var resultInt: Int
        var operatorRawVal: String
        let operatorPosition: Int = 1
        while operatorPosition < arrayOfArguments.count {
            guard arrayOfArguments.count > 2 else {
                throw CalculationError.notEnoughParameters
            }
            firstVal = Int(arrayOfArguments[operatorPosition - 1])!
            secondVal = Int(arrayOfArguments[operatorPosition + 1])!
            operatorRawVal = arrayOfArguments[operatorPosition]
            
            switch operatorRawVal {
            case Operators.plus.rawValue:
                resultInt = firstVal + secondVal
            default:
                resultInt = firstVal - secondVal
            }
            
            ShrinkArray(resultVal: resultInt, indexToRemove: operatorPosition)
            try PerformLowPriorityCalculatrion()
            break
        }
    }
    
    // This function is used to calculate multiply, divide and modulus
    private func PerformHighPriorityCalculation() throws {
        var firstVal: Int
        var secondVal: Int
        var resultInt: Int
        var operatorRawVal: String
        var operatorPosition: Int = 1
        
        // loop through the array, then pick out the left  most priority operator(x / %) and then perform calculation of number before and after it.
        while operatorPosition < arrayOfArguments.count {
            // we need to check if the operator is a priority operator or not(x / %)
            if IsPriorityOperator(operators: Operators(rawValue: arrayOfArguments[operatorPosition]) ?? Operators.unknown) {
                guard arrayOfArguments.count > 2 else {
                    throw CalculationError.notEnoughParameters
                }
                firstVal = Int(arrayOfArguments[operatorPosition - 1])!
                secondVal = Int(arrayOfArguments[operatorPosition + 1])!
                operatorRawVal = arrayOfArguments[operatorPosition]
                
                switch operatorRawVal {
                case Operators.multiply.rawValue:
                    resultInt = firstVal * secondVal
                case Operators.divide.rawValue:
                    // if the second number is zero, then throw an excpetion because we cannot perform devision by zero
                    guard secondVal != 0 else {
                        throw CalculationError.divideByZero(String(firstVal), String(secondVal))
                    }
                    resultInt = firstVal / secondVal
                default:
                    // if the second number is zero, then throw an excpetion because we cannot perform devision by zero
                    guard secondVal != 0 else {
                        throw CalculationError.divideByZero(String(firstVal), String(secondVal))
                    }
                    resultInt = firstVal % secondVal
                }
                
                ShrinkArray(resultVal: resultInt, indexToRemove: operatorPosition)
                _ = try PerformHighPriorityCalculation()
                break
            }
            
            // if the first oprator is not the high priority operator (x / %) then move to the next operator to check if it is a high priority operator or not.
            operatorPosition = operatorPosition + 2
        }
    }
    
    // after perform a calculation, we need to shrink the array down, then we perform next calculation
    private func ShrinkArray(resultVal: Int, indexToRemove: Int) -> Void {
        arrayOfArguments.removeSubrange((indexToRemove - 1)...(indexToRemove + 1))
        arrayOfArguments.insert(String(resultVal), at: (indexToRemove - 1))
    }
    
    // this function is used to check whether the opearator is a priority one.
    private func IsPriorityOperator(operators: Operators) -> Bool {
        switch operators {
        case Operators.multiply, Operators.modulus, Operators.divide:
            return true
        default:
            return false
        }
    }
}

// this enum throws errors
enum CalculationError : Error {
    case outOfBoundValue(String)
    case notEnoughParameters
    case divideByZero(String, String)
    case notNumber(String)
    case notOperator(String)
    case outOfBoundException
}

// this enum represent all operators
enum Operators: String {
    case multiply = "x"
    case divide = "/"
    case plus = "+"
    case minus = "-"
    case modulus = "%"
    case unknown
}

