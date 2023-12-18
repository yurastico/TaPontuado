//
//  LocalAuthentication.swift
//  Alura Ponto
//
//  Created by Yuri Cunha on 18/12/23.
//

import Foundation
import LocalAuthentication

final class LocalAuthentication {
    let authenticatorContext = LAContext()
    var error: NSError?
    
    func authorizeUser(completion: @escaping (_ authentication: Bool) -> Void) {
        if authenticatorContext.canEvaluatePolicy(.deviceOwnerAuthenticationWithBiometrics, error: &error) {
            authenticatorContext.evaluatePolicy(.deviceOwnerAuthenticationWithBiometrics, localizedReason: "need acess to delete Receipt") { success, error in
                completion(success)
            }
        }
    }
    
}
