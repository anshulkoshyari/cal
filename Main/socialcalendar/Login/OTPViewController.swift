//
//  OTPViewController.swift
//  socialcalendar
//
//  Created by AK on 22/01/25.
//

import FirebaseAuth
import UIKit

private let enterOTPText = NSLocalizedString("Enter OTP", comment: "Enter OTP")
private let otpPlaceholderText = NSLocalizedString("000000", comment: "000000")
private let verifyOTPBtnTitle = NSLocalizedString("Verify OTP", comment: "Verify OTP")
private let emptyOTPErrorText = NSLocalizedString("Enter a valid OTP", comment: "Enter a valid OTP")
private let otpVerifyErrorText = NSLocalizedString("Failed to verify OTP", comment: "Failed to verify OTP")
private let defaultOTPLength = 6

class OTPViewController: UIViewController {
    var viewModel: OTPViewModel!
    
    @IBOutlet private weak var titleLabel: UILabel!
    @IBOutlet private weak var otpTextField: UITextField!
    @IBOutlet private weak var verifyOTPBtn: UIButton!
    @IBOutlet private weak var errorLabel: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupBindings()
        setupUI()
    }
    
    private func setupBindings() {
        otpTextField.delegate = self
    }
    
    private func setupUI() {
        titleLabel.text = enterOTPText
        otpTextField.placeholder = otpPlaceholderText
        verifyOTPBtn.setTitle(verifyOTPBtnTitle, for: .normal)
    }
    
    @IBAction private func verifyOTPTapped(_ sender: UIButton) {
        guard let otp = otpTextField.text, otp.count == defaultOTPLength else {
            errorLabel.text = emptyOTPErrorText
            return
        }
        viewModel.verifyOTP(otp) { [weak self] user in
            DispatchQueue.main.async {
                guard let strong = self, let user = user else {
                    self?.errorLabel.text = otpVerifyErrorText
                    return
                }
                strong.didLogin(for: user)
            }
        }
    }
    
    // Move to Router
    private func didLogin(for user: User) {
        guard
            let appDelegate = UIApplication.shared.delegate as? AppDelegate,
            let coordinator = appDelegate.coordinator
        else { return }
        coordinator.rootScene = .feed(user)
    }
}

extension OTPViewController: UITextFieldDelegate {
    func textFieldDidBeginEditing(_ textField: UITextField) {
        otpTextField.layer.borderColor = UIColor.systemBlue.cgColor
        otpTextField.layer.cornerRadius = 4
        otpTextField.layer.borderWidth = 1
    }
}
