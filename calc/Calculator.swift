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
    
    private func CheckParametersInput() throws {
        let argCount = CommandLine.argc
        for index in 1..<argCount {
            if index % 2 != 0 {
                guard CommandLine.arguments[Int(index)].IsInt else {
                    throw CalculationError.notNumber(CommandLine.arguments[Int(index)])
                }
                
                arrayOfArguments.append(CommandLine.arguments[Int(index)])
            }
            else {
                guard String.IsOperator(operatorArgument: Operators(rawValue: CommandLine.arguments[Int(index)]) ?? Operators.unknown) else {
                    throw CalculationError.notOperator(CommandLine.arguments[Int(index)])
                }
                
                arrayOfArguments.append(CommandLine.arguments[Int(index)])
            }
        }
    }
    
    func PerformCalculate() throws -> Int{
        try CheckParametersInput()
        try PerformHighPriorityCalculation()
        try PerformLowPriorityCalculatrion()
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
            
            ShrikArray(resultVal: resultInt, indexToRemove: operatorPosition)
            try PerformLowPriorityCalculatrion()
            break
        }
    }
    
    private func PerformHighPriorityCalculation() throws {
        var firstVal: Int
        var secondVal: Int
        var resultInt: Int
        var operatorRawVal: String
        var operatorPosition: Int = 1
        
        while operatorPosition < arrayOfArguments.count {
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
                case Operators.devide.rawValue:
                    guard secondVal != 0 else {
                        throw CalculationError.divideByZero(String(firstVal), String(secondVal))
                    }
                    resultInt = firstVal / secondVal
                default:
                    guard secondVal != 0 else {
                        throw CalculationError.divideByZero(String(firstVal), String(secondVal))
                    }
                    resultInt = firstVal % secondVal
                }
                
                ShrikArray(resultVal: resultInt, indexToRemove: operatorPosition)
                _ = try PerformHighPriorityCalculation()
                break
            }
            
            operatorPosition = operatorPosition + 2
        }
    }
    
    private func ShrikArray(resultVal: Int, indexToRemove: Int) -> Void {
        arrayOfArguments.removeSubrange((indexToRemove - 1)...(indexToRemove + 1))
        arrayOfArguments.insert(String(resultVal), at: (indexToRemove - 1))
    }
    
    private func IsPriorityOperator(operators: Operators) -> Bool {
        switch operators {
        case Operators.multiply, Operators.modulus, Operators.devide:
            return true
        default:
            return false
        }
    }
}

enum CalculationError : Error {
    case outOfBoundValue(String)
    case notEnoughParameters
    case divideByZero(String, String)
    case notNumber(String)
    case notOperator(String)
    case outOfBoundException
}

enum Operators: String {
    case multiply = "x"
    case devide = "/"
    case plus = "+"
    case minus = "-"
    case modulus = "%"
    case unknown
}

