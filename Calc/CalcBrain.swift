//
//  CalcBrain.swift
//  Calc
//
//  Created by eduardo on 3/5/15.
//  Copyright (c) 2015 eduardo. All rights reserved.
//


import Foundation

class CalcBrain : Printable
{
    
    var description: String {
        get {
            return "\(opStack)"
        }
    
    }
    
    private enum Op : Printable
    {
        case Operand(Double)
        case Variable(String)
        case UnaryOperation(String, Double -> Double)
        case BinaryOperation(String, (Double, Double) -> Double)
        case ConstantOperation(String, () -> Double)
        
        var description: String {
            get {
                switch  self {
                case .Operand(let operand):
                    return "\(operand)"
                case .UnaryOperation(let symbol, _):
                    return symbol
                case .BinaryOperation(let symbol, _):
                    return symbol
                case .ConstantOperation(let symbol, _):
                    return symbol
                case .Variable(let variable):
                    return variable
                }
            }
        }
    }
    
    
    private var opStack = [Op]()                        // array
    
    private var knownOps = [String: Op]()               // dictionary
    
    init()
    {
                func learnOp (op: Op){
                    knownOps[op.description] = op
                }
//        
//        knownOps["×"] = Op.BinaryOperation("×", *)
//        knownOps["÷"] = Op.BinaryOperation("÷") {$1/$0}
//        knownOps["+"] = Op.BinaryOperation("+", +)
//        knownOps["−"] = Op.BinaryOperation("-") {$1 - $0}
        
                learnOp(Op.BinaryOperation("×", *))
                learnOp(Op.BinaryOperation("÷") {$1/$0})
                learnOp(Op.BinaryOperation("+", +))
                learnOp(Op.BinaryOperation("-") {$1 - $0})
        
                learnOp(Op.UnaryOperation("√", sqrt))
                learnOp(Op.UnaryOperation("sin", sin))
                learnOp(Op.UnaryOperation("cos", cos))
        
                learnOp(Op.ConstantOperation("π", {M_PI} ))
                learnOp(Op.BinaryOperation("^",  {pow($0, $1)}  ))
    }
    
    var variableValues = [String : Double]()
    
    private func evaluate(ops: [Op]) -> (result: Double?, remainingOps: [Op])
    {
        if !ops.isEmpty
        {
            var remainingOps = ops
            let op = remainingOps.removeLast()
            
            switch op {
            case .ConstantOperation(_, let constant):
                return (constant(), remainingOps)
            case .Variable(let variable):
                return (variableValues[variable], remainingOps)
                
            case .Operand(let operand):
                return (operand, remainingOps)
                
            case .UnaryOperation(_, let operation):
                let operandEvaluation = evaluate(remainingOps)
                if let operand = operandEvaluation.result {
                    return (operation(operand), operandEvaluation.remainingOps)
                }
            case .BinaryOperation(_, let operation):
                let op1Evaluation = evaluate(remainingOps)
                if let operand1 = op1Evaluation.result {
                    let op2Evaluation = evaluate( op1Evaluation.remainingOps)
                    if let operand2 = op2Evaluation.result {
                        return (operation(operand1, operand2), op2Evaluation.remainingOps)
                    }
                }
            }
        }
        
        return (nil, ops)
    }
    
    func evaluate() -> Double?
    {
        let (result, remainder) = evaluate(opStack)
        println("\(opStack) = \(result) with \(remainder) left over")
        return result
    }
    
    func pushOperand(operand: Double) -> Double?
    {
        opStack.append(Op.Operand(operand))
        return evaluate()
    }
    
    func pushOperand(symbol: String) -> Double?
    {
        opStack.append(Op.Variable(symbol))
        return evaluate()
    }
    
    func performOperation(symbol: String) -> Double?
    {
        if let operation = knownOps[symbol] {
            opStack.append(operation)
        }
        return evaluate()
    }
    
    func clear() {
        opStack = []
    }
    
}










