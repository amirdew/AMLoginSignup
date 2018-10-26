//
//  IsValid.swift
//  AMLoginSingup
//
//  Created by Nikolay Raychev on 26.10.18.
//

import Foundation

class IsValid {
    
    class func email(_ email: String) -> Bool{
        
        let emailRegEx = "[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,64}"
        let emailTest = NSPredicate(format:"SELF MATCHES %@", emailRegEx)
        return emailTest.evaluate(with: email)
    }
    
    class func password(_ password: String) -> Bool {
        
        guard password.count > 5 else {
            return false
        }
        return true
    }
}
