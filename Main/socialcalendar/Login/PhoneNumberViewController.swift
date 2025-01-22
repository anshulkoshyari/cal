//
//  PhoneNumberViewController.swift
//  socialcalendar
//
//  Created by AK on 21/01/25.
//

import UIKit
import FirebaseAuth

private let loginText = NSLocalizedString("Login with phone", comment: "Login with phone")
private let phoneNumberPlaceholderText = NSLocalizedString("Enter your phone number", comment: "Enter your phone number")
private let sendOTPBtnTitle = NSLocalizedString("Send OTP", comment: "Send OTP")
private let emptyPhoneNumberErrorText = NSLocalizedString("Enter a valid phone number", comment: "Enter a valid phone number")
private let otpSendErrorText = NSLocalizedString("Failed to send OTP", comment: "Failed to send OTP")

class PhoneNumberViewController: UIViewController {
    var viewModel: PhoneNumberViewModel!
    
    @IBOutlet private weak var titleLabel: UILabel!
    @IBOutlet private weak var phoneTextField: UITextField!
    @IBOutlet private weak var sendOTPBtn: LoadingButton!
    @IBOutlet private weak var errorLabel: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupBindings()
        setupUI()
    }
    
    private func setupBindings() {
        phoneTextField.delegate = self
    }
    
    private func setupUI() {
        titleLabel.text = loginText
        phoneTextField.placeholder = phoneNumberPlaceholderText
        sendOTPBtn.setTitle(sendOTPBtnTitle, for: .normal)
    }
    
    @IBAction private func otpBtnTapped(_ sender: UIButton) {
        guard let phoneNumber = phoneTextField.text, !phoneNumber.isEmpty else {
            errorLabel.text = emptyPhoneNumberErrorText
            return
        }
        sendOTPBtn.showLoading()
        viewModel.sendOTP(to: "+91\(phoneNumber)") { [weak self] result in
            guard let strong = self, result else {
                self?.errorLabel.text = otpSendErrorText
                return
            }
            strong.sendOTPBtn.hideLoading()
            strong.didSendOTP()
        }
    }
    
    // Move to Router
    private func didSendOTP() {
        guard
            let appDelegate = UIApplication.shared.delegate as? AppDelegate,
            let coordinator = appDelegate.coordinator
        else { return }
        coordinator.rootScene = .otp
    }
}

extension PhoneNumberViewController: UITextFieldDelegate {
    func textFieldDidBeginEditing(_ textField: UITextField) {
        phoneTextField.layer.borderColor = UIColor.systemBlue.cgColor
        phoneTextField.layer.cornerRadius = 4
        phoneTextField.layer.borderWidth = 1
    }
}
