//
//  LoginViewModel.swift
//  socialcalendar
//
//  Created by AK on 21/01/25.
//

import FirebaseAuth

private let verificationIDKey: String = "FirebaseVerificationID"

class LoginViewModel {
    func sendOTP(to phoneNumber: String, completion: @escaping (Bool) -> ()) {
        PhoneAuthProvider.provider().verifyPhoneNumber(phoneNumber, uiDelegate: nil) { verificationID, error in
            guard let verificationID = verificationID, error == nil else {
                print("CM: Failed to send OTP to \(phoneNumber).")
                completion(false)
                return
            }
            UserDefaults.standard.set(verificationID, forKey: verificationIDKey)
            completion(true)
        }
    }
    
    func verifyOTP(_ otp: String, completion: @escaping (User?) -> ()) {
        guard let verificationID = UserDefaults.standard.string(forKey: verificationIDKey) else {
            print("CM: Verification ID not found in User Defaults.")
            completion(nil)
            return
        }
        let credential = PhoneAuthProvider.provider().credential(
            withVerificationID: verificationID,
            verificationCode: otp
        )
        Auth.auth().signIn(with: credential) { authResult, error in
            guard let result = authResult, error == nil else {
                print("CM: Failed to sign in user.")
                completion(nil)
                return
            }
            completion(result.user)
        }
    }
}
