//
//  PhoneNumberViewModel.swift
//  socialcalendar
//
//  Created by AK on 21/01/25.
//

import FirebaseAuth

class PhoneNumberViewModel {
    func sendOTP(to phoneNumber: String, completion: @escaping (Bool) -> ()) {
        print("CM: Initiating OTP request for phone number: \(phoneNumber)")
        
        PhoneAuthProvider.provider().verifyPhoneNumber(phoneNumber, uiDelegate: nil) { verificationID, error in
            if let error = error {
                print("CM: Failed to send OTP to \(phoneNumber). Error: \(error)")
                completion(false)
                return
            }
            guard let verificationID = verificationID, error == nil else {
                print("CM: Failed to retrieve verification ID for phone number: \(phoneNumber).")
                completion(false)
                return
            }
            UserDefaults.standard.set(verificationID, forKey: Keys.firebaseVerificationID)
            print("CM: OTP successfully sent to \(phoneNumber). Verification ID saved.")
            completion(true)
        }
    }
}
