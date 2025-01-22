//
//  LoadingButton.swift
//  socialcalendar
//
//  Created by AK on 22/01/25.
//

import UIKit

class LoadingButton: UIButton {
    private var originalButtonText: String?
    private var originalButtonWidth: CGFloat?
    private var originalButtonHeight: CGFloat?
    
    private lazy var activityIndicator: UIActivityIndicatorView = {
        let activityIndicator = UIActivityIndicatorView()
        activityIndicator.hidesWhenStopped = true
        self.addSubview(activityIndicator)
        activityIndicator.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activate([
            activityIndicator.centerXAnchor.constraint(equalTo: self.centerXAnchor),
            activityIndicator.centerYAnchor.constraint(equalTo: self.centerYAnchor)
        ])
        return activityIndicator
    }()

    func showLoading() {
        originalButtonText = self.titleLabel?.text
        originalButtonWidth = self.intrinsicContentSize.width
        originalButtonHeight = self.intrinsicContentSize.height
        
        self.setTitle("", for: .normal)
        if let originalButtonWidth = originalButtonWidth, let originalButtonHeight = originalButtonHeight {
            self.widthAnchor.constraint(equalToConstant: originalButtonWidth).isActive = true
            self.heightAnchor.constraint(equalToConstant: originalButtonHeight).isActive = true
        }
        activityIndicator.startAnimating()
    }

    func hideLoading() {
        activityIndicator.stopAnimating()
        self.setTitle(originalButtonText, for: .normal)
        self.invalidateIntrinsicContentSize()
    }
}
