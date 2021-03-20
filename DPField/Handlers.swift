import Foundation

public typealias HandlerKey = NSObject
public typealias HandlerType<Input, Output> = (Input) -> Output

public class Handlers<HandlerType> {
    
    private var handlers: [HandlerKey: HandlerType] = [:]
    
    public init() {}
    
    public func append(_ handler: HandlerType) -> HandlerKey {
        let key = HandlerKey()
        self.handlers[key] = handler
        return key
    }
    
    public func remove(_ key: HandlerKey) {
        self.handlers.removeValue(forKey: key)
    }
    
    public func removeAll() {
        self.handlers.removeAll()
    }
    
    public func execute(_ execution: ((HandlerKey, HandlerType) -> Void)?) {
        self.handlers.forEach({ key, handler in
            execution?(key, handler)
        })
    }
}



