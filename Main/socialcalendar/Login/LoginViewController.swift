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
    var viewModel: LoginViewModel!
    
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
            viewModel.sendOTP(to: "+91\(phoneNumber)") { [weak self] result in
                guard let strong = self, result else {
                    self?.errorLabel.text = otpSendErrorText
                    return
                }
                strong.scene = .otp
            }
        case .otp:
            guard let otp = phoneNumberTextField.text, !otp.isEmpty else {
                errorLabel.text = enterOTPText
                return
            }
            viewModel.verifyOTP(otp) { [weak self] user in
                DispatchQueue.main.async {
                    guard let strong = self, let user = user else {
                        self?.errorLabel.text = otpVerifyErrorText
                        return
                    }
                    strong.presentFeedViewController(for: user)
                }
            }
        }
    }
    
    private func presentFeedViewController(for user: User) {
        let controller: FeedViewController = .load(from: .feed)
        controller.viewModel = FeedViewModel(user: user)
        self.present(controller, animated: true)
    }
    
    private func emptyErrorLabel() {
        errorLabel.text = nil
    }
}

extension LoginViewController: UITextFieldDelegate {
    func textFieldDidBeginEditing(_ textField: UITextField) {
        phoneNumberTextField.layer.borderColor = UIColor.systemBlue.cgColor
        phoneNumberTextField.layer.cornerRadius = 4
        phoneNumberTextField.layer.borderWidth = 1
    }
}
