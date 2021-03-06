import Foundation
import DPLibrary

open class FieldValidation: LocalizedError {
    
    // MARK: - Static
    public struct Mode: OptionSet {
        public let rawValue: Int
        
        public init(rawValue: Int) {
            self.rawValue = rawValue
        }
        
        public static let realTime = Mode(rawValue: 1 << 0)
        public static let afterFinish = Mode(rawValue: 1 << 1)
        
        public static let any: Mode = [.realTime, .afterFinish]
    }
    
    // MARk: - Props
    public let message: String
    public let mode: Mode
    public let required: Bool
    
    public var errorDescription: String? {
        self.message
    }
    
    public var failureReason: String? {
        self.message
    }
    
    // MARK: - Init
    public init(message: String, mode: Mode, required: Bool) {
        self.message = message
        self.mode = mode
        self.required = required
    }
    
    // MARK: - Public methods
    open func modeIsMatch(to mode: Mode) -> Bool {
        self.mode.contains(mode) || self.mode == mode || mode.contains(self.mode)
    }
    
    open func validate(for value: Any?) -> Self? { nil }
    
    open func validate(for value: Any?, with mode: FieldValidation.Mode) -> Self? {
        guard self.modeIsMatch(to: mode) else { return nil }
        return self.validate(for: value)
    }
}

// MARK: - FieldValidation + Store
public extension FieldValidation {
    
    static func isEmailDefault(message: String) -> EmailFieldValidation {
        .init(message: message, mode: .afterFinish, required: true)
    }
    
    static func isDateDefault(message: String) -> DateFieldValidation {
        .init(message: message, mode: .afterFinish, required: true)
    }
    
    static func isNumberDefault(message: String) -> NumberFieldValidation {
        .init(message: message, mode: .afterFinish, required: true)
    }
    
    static func maxLengthDefault(message: String, length: Int) -> MaxLengthFieldValidation {
        .init(length: length, message: message, mode: .any, required: true)
    }
    
    static func minLengthDefault(message: String, length: Int) -> MinLengthFieldValidation {
        .init(length: length, message: message, mode: .afterFinish, required: true)
    }
    
    static func matchPredicateDefault(message: String, format: String, mode: FieldValidation.Mode, required: Bool) -> MatchPredicateFieldValidation {
        .init(format: format, message: message, mode: mode, required: required)
    }
    
}

// MARK: - Email validation
open class EmailFieldValidation: FieldValidation {
    
    open override func validate(for value: Any?) -> Self? {
        guard let value = value as? String, !value.isEmpty else { return self.required ? self : nil }
        let predicate = NSPredicate(format: "SELF MATCHES %@", "[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,64}")
        let isValid = predicate.evaluate(with: value)
        return isValid ? nil : self
    }
    
}

// MARK: - Date validation
open class DateFieldValidation: FieldValidation {
    
    open override func validate(for value: Any?) -> Self? {
        guard let value = value else { return self.required ? self : nil }
        return value is Date ? nil : self
    }
    
}

// MARK: - Number validation
open class NumberFieldValidation: FieldValidation {
    
    open override func validate(for value: Any?) -> Self? {
        guard let value = value else { return self.required ? self : nil }
        var isValid: Bool
        
        switch value {
        case is Int:
            isValid = true
        case is UInt:
            isValid = true
        case is Double:
            isValid = true
        case is Int8:
            isValid = true
        case is Int16:
            isValid = true
        case is Int32:
            isValid = true
        case is Int64:
            isValid = true
        case is UInt8:
            isValid = true
        case is UInt16:
            isValid = true
        case is UInt32:
            isValid = true
        case is UInt64:
            isValid = true
        case is Float:
            isValid = true
        case is NSNumber:
            isValid = true
        case is NSDecimalNumber:
            isValid = true
        default:
            isValid = false
        }
        
        if let string = value as? String, Int(string) != nil {
            isValid = true
        }
        
        return isValid ? nil : self
    }
    
}

// MARK: - Max length validation
open class MaxLengthFieldValidation: FieldValidation {
    public let length: Int
    
    public init(length: Int, message: String, mode: FieldValidation.Mode, required: Bool) {
        self.length = length
        super.init(message: message, mode: mode, required: required)
    }
    
    open override func validate(for value: Any?) -> Self? {
        guard let value = value as? String else { return self.required ? self : nil }
        let isValid = value.count <= self.length
        return isValid ? nil : self
    }
    
}

// MARK: - Min length validation
open class MinLengthFieldValidation: FieldValidation {
    public let length: Int
    
    public init(length: Int, message: String, mode: FieldValidation.Mode, required: Bool) {
        self.length = length
        super.init(message: message, mode: mode, required: required)
    }
    
    open override func validate(for value: Any?) -> Self? {
        guard let value = value as? String else { return self.required ? self : nil }
        let isValid = value.count >= self.length
        return isValid ? nil : self
    }
}

// MARK: - Match predicate validation
open class MatchPredicateFieldValidation: FieldValidation {
    public let format: String
    
    public init(format: String, message: String, mode: FieldValidation.Mode, required: Bool) {
        self.format = format
        super.init(message: message, mode: mode, required: required)
    }
    
    open override func validate(for value: Any?) -> Self? {
        guard let value = value as? String, !value.isEmpty else { return self.required ? self : nil }
        let predicate = NSPredicate(format: "SELF MATCHES %@", self.format)
        let isValid = predicate.evaluate(with: value)
        return isValid ? nil : self
    }
}
