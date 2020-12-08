import Foundation
import JavaScriptCore

public class RegExp {
    static let context = JSContext()
    
    let regex: String
    
    public init(_ regex: String, flags: String = "") {
        self.regex = "/\(regex)/\(flags)"
    }
    
    public func exec(_ str: String?) -> [String]? {
        if str == nil {
            return nil
        }
        
        let script = #"\#(regex).exec("\#(str!)")"#
        return RegExp.context?.evaluateScript(script)?.toArray() as? [String]
    }
    
    public func test(_ str: String?) -> Bool {
        guard str != nil else {
            return false
        }
        
        let script = #"\#(regex).test("\#(str!)")"#
        return RegExp.context?.evaluateScript(script)?.toBool() ?? false
    }
}

