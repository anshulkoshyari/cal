import UIKit
import FirebaseAuth

private let loginText = NSLocalizedString("Login with phone", comment: "Login with phone")
private let enterOTPText = NSLocalizedString("Enter OTP", comment: "Enter OTP")

private let phoneNumberPlaceholderText = NSLocalizedString("Enter your phone number", comment: "Enter your phone number")
private let otpPlaceholderText = NSLocalizedString("000000", comment: "000000")

private let sendOTPBtnTitle = NSLocalizedString("Send OTP", comment: "Send OTP")
private let verifyOTPBtnTitle = NSLocalizedString("Verify OTP", comment: "Verify OTP")

private let emptyPhoneNumberErrorText = NSLocalizedString("Enter a valid phone number", comment: "Enter a valid phone number")
private let otpSendErrorText = NSLocalizedString("Failed to send OTP", comment: "Failed to send OTP")
private let otpVerifyErrorText = NSLocalizedString("Failed to verify OTP", comment: "Failed to verify OTP")

private enum LoginScene {
    case phoneNumber
    case otp
}

class LoginViewController: UIViewController {
    @IBOutlet private weak var loginLabel: UILabel!
    @IBOutlet private weak var phoneNumberTextField: UITextField!
    @IBOutlet private weak var otpBtn: UIButton!
    @IBOutlet private weak var errorLabel: UILabel!
    
    private var scene: LoginScene = .phoneNumber {
        didSet {
            toggleScene(to: scene)
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        phoneNumberTextField.delegate = self
        toggleScene(to: .phoneNumber)
    }
    
    private func toggleScene(to scene: LoginScene) {
        emptyErrorLabel()
        switch scene {
        case .phoneNumber:
            loginLabel.text = loginText
            phoneNumberTextField.placeholder = phoneNumberPlaceholderText
            otpBtn.setTitle(sendOTPBtnTitle, for: .normal)
        case .otp:
            loginLabel.text = enterOTPText
            phoneNumberTextField.placeholder = otpPlaceholderText
            otpBtn.setTitle(verifyOTPBtnTitle, for: .normal)
        }
    }
    
    @IBAction private func otpBtnTapped(_ sender: UIButton) {
        switch scene {
        case .phoneNumber:
            guard let phoneNumber = phoneNumberTextField.text, !phoneNumber.isEmpty else {
                errorLabel.text = emptyPhoneNumberErrorText
                return
            }
            sendOTP(to: phoneNumber)
        case .otp:
            guard let otp = phoneNumberTextField.text, !otp.isEmpty else {
                errorLabel.text = enterOTPText
                return
            }
            verifyOTP(otp)
        }
    }
    
    private func emptyErrorLabel() {
        errorLabel.text = nil
    }
}

// MARK: Move to ViewModel
extension LoginViewController {
    func sendOTP(to phoneNumber: String) {
        PhoneAuthProvider.provider().verifyPhoneNumber(phoneNumber, uiDelegate: nil) { verificationID, error in
            guard let verificationID = verificationID, error != nil else {
                print("CM: Failed to send OTP to \(phoneNumber).")
                self.errorLabel.text = otpSendErrorText
                return
            }
            UserDefaults.standard.set(verificationID, forKey: "authVerificationID")
            self.toggleScene(to: .otp)
        }
    }
    
    func verifyOTP(_ otp: String) {
        guard let verificationID = UserDefaults.standard.string(forKey: "authVerificationID") else {
            print("CM: Verification ID not found in User Defaults.")
            return
        }

        let credential = PhoneAuthProvider.provider().credential(withVerificationID: verificationID, verificationCode: otp)
        Auth.auth().signIn(with: credential) { authResult, error in
            if let error = error {
                self.errorLabel.text = otpVerifyErrorText
                return
            }
            // Take the user to next flow
            print("CM: Login successfull")
        }
    }
}

extension LoginViewController: UITextFieldDelegate {
    func textFieldDidBeginEditing(_ textField: UITextField) {
        phoneNumberTextField.layer.borderColor = UIColor.systemBlue.cgColor
        phoneNumberTextField.layer.cornerRadius = 4
        phoneNumberTextField.layer.borderWidth = 1
    }
}


// if Auth.auth.currentUser == nil -> logic for app coordinator
