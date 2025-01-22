//
//  OTPViewModel.swift
//  socialcalendar
//
//  Created by AK on 22/01/25.
//

import FirebaseAuth

class OTPViewModel {
    func verifyOTP(_ otp: String, completion: @escaping (User?) -> ()) {
        print("CM: Starting OTP verification for provided code: \(otp)")
        
        guard let verificationID = UserDefaults.standard.string(forKey: Keys.firebaseVerificationID) else {
            print("CM: Verification ID not found in User Defaults.")
            completion(nil)
            return
        }
        let credential = PhoneAuthProvider.provider().credential(
            withVerificationID: verificationID,
            verificationCode: otp
        )
        Auth.auth().signIn(with: credential) { authResult, error in
            if let error = error {
                print("CM: Failed to sign in user with provided OTP. Error: \(error)")
                completion(nil)
                return
            }
            
            guard let result = authResult else {
                print("CM: Sign-in result is nil despite no error. Unexpected behavior.")
                completion(nil)
                return
            }
            print("CM: User successfully signed in. UID: \(result.user.uid)")
            completion(result.user)
        }
    }
}
