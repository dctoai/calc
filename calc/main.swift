import Foundation

//let consoleIO = ConsoleIO()
var args = ProcessInfo.processInfo.arguments
args.removeFirst() // remove the name of the program
let calculator = Calculator()
do{
//    try calculator.CheckParametersInput()
    let result: Int = try calculator.PerformCalculate()
    print(result)
}
//catch CalculationError.divideByZero(let firstVal, let secondVal){
////    print("exit with nonzero status when dividing by zero: \(firstVal) / \(secondVal)")
//}
//catch CalculationError.notEnoughParameters {
////    print("exit with nonzero status on invalid input:")
//}
//catch CalculationError.notNumber(let str) {
////    print("\(str) is not a number")
//}
//catch CalculationError.notOperator(let str) {
////    print("\(str) is not an operator")
//}
//catch CalculationError.outOfBoundValue(let str) {
////    print("\(str) is out of bound of an Integer")
//}
//catch {
//    print(error)
//}
