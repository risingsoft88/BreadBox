//
//  ResetPwdViewController.swift
//  Breadbox
//
//  Created by macos on 8/20/22.
//

import UIKit
import FirebaseAuth

class ResetPwdViewController: UIViewController {

    @IBOutlet var viewWrapper: UIView!
    @IBOutlet var viewResetCode: UIStackView!
    @IBOutlet var viewNewPwd: UIStackView!
    @IBOutlet var viewConfirmPwd: UIStackView!
    @IBOutlet var editCode: UITextField!
    @IBOutlet var editNewPwd: UITextField!
    @IBOutlet var editConfirmPwd: UITextField!

    override func viewDidLoad() {
        super.viewDidLoad()

        let path = UIBezierPath(roundedRect:viewWrapper.bounds,
                                byRoundingCorners:[.topRight, .topLeft],
                                cornerRadii: CGSize(width: 20, height:  20))
        let maskLayer = CAShapeLayer()
        maskLayer.path = path.cgPath
        viewWrapper.layer.mask = maskLayer

        viewResetCode.addBottomBorderWithColor(color: UIColor(red: CGFloat(1.0), green: CGFloat(1.0), blue: CGFloat(1.0), alpha: CGFloat(31.0/100.0)), width: 1)
//        viewNewPwd.addBottomBorderWithColor(color: UIColor(red: CGFloat(1.0), green: CGFloat(1.0), blue: CGFloat(1.0), alpha: CGFloat(31.0/100.0)), width: 1)
//        editConfirmPwd.addBottomBorderWithColor(color: UIColor(red: CGFloat(1.0), green: CGFloat(1.0), blue: CGFloat(1.0), alpha: CGFloat(31.0/100.0)), width: 1)
    }

    @IBAction func tapBack(_ sender: Any) {
        self.dismiss(animated: true, completion: nil)
    }

    @IBAction func tapConfirm(_ sender: Any) {
        guard let email = editCode.text?.trimmingCharacters(in: .whitespacesAndNewlines) else { return }

        if (email.isValidEmail()) {
            Auth.auth().sendPasswordReset(withEmail: email) { error in
                if let error = error {
                    self.showError(text: error.localizedDescription)
                    return
                }

                let alertController = UIAlertController(title: "We've sent reset email to you, please check email box!", message: nil, preferredStyle: .alert)
                let okAction = UIAlertAction(title: "OK", style: .default) { (action) in
                    self.dismiss(animated: true, completion: nil)
                }
                alertController.addAction(okAction)
                self.present(alertController, animated: true)
            }
        } else {
            self.showAlert("Please enter a valid email!")
        }
    }

    @IBAction func tapSignin(_ sender: Any) {
        let vc = R.storyboard.main().instantiateViewController(withIdentifier: "LoginViewController") as! LoginViewController
        vc.modalPresentationStyle = .fullScreen
        self.present(vc, animated: true, completion: nil)
    }
}
