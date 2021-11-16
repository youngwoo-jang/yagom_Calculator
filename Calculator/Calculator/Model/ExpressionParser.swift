enum ExpressionParser {
    enum ParserError: Error {
        case includingIncorrectCharacter
        case firstOrLastCharacterIsNotNumber
        case incorrectCountOfNumbersAndOperators
        case failedToInitializeFormulaInstance
    }
    
    static func parse(from input: String) -> Result<Formula, ExpressionParser.ParserError> {
        guard input.hasOnlyNumberOrOperator() else {
            return .failure(.includingIncorrectCharacter)
        }
        
        guard input.firstAndLastCharacterAreNumbers() else {
            return .failure(.firstOrLastCharacterIsNotNumber)
        }
        
        let inputComponents = ExpressionParser.componentsByOperators(from: input)
                   
        let (operands, operators) = separateOperandsAndOperators(from: inputComponents)
        
        
        guard operands.count == operators.count + 1 else {
            return .failure(.incorrectCountOfNumbersAndOperators)
        }
        
        guard let formula = makeFormula(operands: operands, operators: operators) else {
            return .failure(.failedToInitializeFormulaInstance)
        }
        
        return .success(formula)
    }
    
    static private func componentsByOperators(from input: String) -> [String] {
        let modifiedInput = ExpressionParser.insertEmptySpaceByOperators(from: input)
        
        return modifiedInput.split(with: " ")
    }
    
    static private func insertEmptySpaceByOperators(from input: String) -> String {
        var modifiedInput = input
        let allTargets = Operator.allStringCases
        
        allTargets.forEach {
            modifiedInput = modifiedInput.replacingOccurrences(of: $0, with: " \($0) ")
        }
        
        return modifiedInput
    }
    
    static private func separateOperandsAndOperators(from components: [String]) -> ([String], [String]) {
        var operands: [String] = []
        var operators: [String] = []
        
        for component in components {
            if Operator.allStringCases.contains(component) {
                operators.append(component)
            } else {
                operands.append(component)
            }
        }
        
        return (operands, operators)
    }
    
    static private func makeFormula(operands: [String], operators: [String]) -> Formula? {
        
        var formula = Formula()
        
        let filteredOperands = operands.compactMap{ Double($0) }
        
        let filteredOperators = operators.filter{
            $0.count == 1
        }.compactMap {
            Operator(rawValue: Character($0))
        }
        
        guard filteredOperands.count == operands.count,
              filteredOperators.count == operators.count else {
            return nil
        }
        
        filteredOperands.forEach {
            formula.operandsQueue.enqueue($0)
        }
        filteredOperators.forEach {
            formula.operatorsQueue.enqueue($0)
        }
        
        return formula
    }
}
