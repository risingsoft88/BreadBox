//
//  LoginViewController.swift
//  Breadbox
//
//  Created by macos on 8/17/22.
//

import UIKit
import Firebase
import FirebaseFirestore
import SVProgressHUD

class LoginViewController: UIViewController {

    @IBOutlet var viewWrapper: UIView!
    @IBOutlet var viewEmail: UIView!
    @IBOutlet var viewPwd: UIView!
    @IBOutlet var imgAvatar: UIImageView!
    @IBOutlet var lblHello: UILabel!
    @IBOutlet var editEmail: UITextField!
    @IBOutlet var editPwd: UITextField!

    var hidePassword = true
    var strRemember = ""
    var isLoading = false

    override func viewDidLoad() {
        super.viewDidLoad()

        let defaults = UserDefaults.standard
        let useremail = defaults.string(forKey: "useremail") ?? ""
        let password = defaults.string(forKey: "userpwd") ?? ""
        if useremail != "" {
            lblHello.isHidden = false
            editEmail.text = useremail
            editPwd.text = password
            AppManager.shared.loadUser()
            Utils.loadAvatar(imgAvatar)
        } else {
            lblHello.isHidden = true
            imgAvatar.image = R.image.img_avatar_empty()
        }

        editPwd.isSecureTextEntry = hidePassword

        let path = UIBezierPath(roundedRect:viewWrapper.bounds,
                                byRoundingCorners:[.topRight, .topLeft],
                                cornerRadii: CGSize(width: 20, height: 20))
        let maskLayer = CAShapeLayer()
        maskLayer.path = path.cgPath
        viewWrapper.layer.mask = maskLayer

        imgAvatar.layer.cornerRadius = imgAvatar.frame.width/2
        viewEmail.addBottomBorderWithColor(color: UIColor(red: CGFloat(1.0), green: CGFloat(1.0), blue: CGFloat(1.0), alpha: CGFloat(31.0/100.0)), width: 1)
        viewPwd.addBottomBorderWithColor(color: UIColor(red: CGFloat(1.0), green: CGFloat(1.0), blue: CGFloat(1.0), alpha: CGFloat(31.0/100.0)), width: 1)
    }

    @IBAction func tapLogin(_ sender: Any) {
        if (isLoading) {
            return
        }

        guard let email = editEmail.text?.trimmingCharacters(in: .whitespacesAndNewlines) else { return }
        guard let password = editPwd.text?.trimmingCharacters(in: .whitespacesAndNewlines) else { return }

        if email.isEmpty {
            showAlert("Please enter an email address!")
            return
        }

        if password.isEmpty {
            showAlert("Please enter a password!")
            return
        }

        self.signInWith(email: email, password: password)
    }

    @IBAction func tapForgotPwd(_ sender: Any) {
        if (isLoading) {
            return
        }
        let vc = R.storyboard.main().instantiateViewController(withIdentifier: "ResetPwdViewController") as! ResetPwdViewController
        vc.modalPresentationStyle = .fullScreen
        self.present(vc, animated: true, completion: nil)
    }

    @IBAction func tapSignup(_ sender: Any) {
        let vc = R.storyboard.main().instantiateViewController(withIdentifier: "RegisterViewController") as! RegisterViewController
        vc.modalPresentationStyle = .fullScreen
        self.present(vc, animated: true, completion: nil)
    }

    @IBAction func tapShowPwd(_ sender: Any) {
        if (isLoading) {
            return
        }
        hidePassword = !hidePassword
        editPwd.isSecureTextEntry = hidePassword
    }

    @IBAction func tapBack(_ sender: Any) {
        if (isLoading) {
            return
        }
        self.dismiss(animated: true, completion: nil)
    }

    private func showErrorAndHideProgress(text: String) {
        isLoading = false
        SVProgressHUD.dismiss()
        self.showError(text: text)
    }

    private func signInWith(email: String, password: String) {
        isLoading = true
        SVProgressHUD.show()

        Auth.auth().signIn(withEmail: email, password: password) { (authResult, error) in
            if let error = error {
                self.showErrorAndHideProgress(text: error.localizedDescription)
                return
            }

            guard let _ = authResult else {
                self.showErrorAndHideProgress(text: "Could not log in. Please try again")
                return
            }

            let db = Firestore.firestore()
            db.collection("users").whereField("email", isEqualTo: email).getDocuments { (querySnapshot, error) in
                if let error = error {
                    self.showErrorAndHideProgress(text: error.localizedDescription)
                    return
                }

                guard let snapshot = querySnapshot else {
                    self.showErrorAndHideProgress(text: "There was an error signing in.")
                    return
                }

                // User exists with the specified email, show error
                if let existingUserDocument = snapshot.documents.first {
                    let existingUser = User(JSON: existingUserDocument.data())
                    existingUser?.password = password
                    existingUserDocument.reference.updateData(["password": password])
                    AppManager.shared.saveCurrentUserRef(userRef: existingUserDocument.reference)

                    guard let currentUser = Auth.auth().currentUser else {
                        self.showErrorAndHideProgress(text: "User login failed!")
                        return
                    }

                    currentUser.reload { (error) in
                        if let error = error {
                            self.showErrorAndHideProgress(text: error.localizedDescription)
                            return
                        }

                        SVProgressHUD.dismiss()
                        self.isLoading = false
                        if (currentUser.isEmailVerified) {

                            if let token = Messaging.messaging().fcmToken {
                                existingUserDocument.reference.setData(["fcmToken": token], merge: true)
                            }

                            AppManager.shared.saveCurrentUser(user: existingUser!)

                            let defaults = UserDefaults.standard
                            defaults.set(email, forKey: "useremail")
                            defaults.set(password, forKey: "userpwd")

                            let vc = R.storyboard.main().instantiateViewController(withIdentifier: "OnboardingViewController") as! OnboardingViewController
                            vc.modalPresentationStyle = .fullScreen
                            self.present(vc, animated: true, completion: nil)
                        } else {
                            let alertController = UIAlertController(title: "Please verify your email address!", message: nil, preferredStyle: .alert)
                            let cancelAction = UIAlertAction(title: "Cancel", style: .cancel) { (action) in
                                // cancel action
                            }
                            alertController.addAction(cancelAction)
                            let ResendAction = UIAlertAction(title: "Resend", style: .default) { (action) in
                                SVProgressHUD.show()
                                Auth.auth().currentUser?.sendEmailVerification { (error) in
                                    if let error = error {
                                        self.showErrorAndHideProgress(text: error.localizedDescription)
                                        return
                                    }

                                    SVProgressHUD.dismiss()
                                    self.showAlert("Please verify your email address!")
                                }
                            }
                            alertController.addAction(ResendAction)
                            self.present(alertController, animated: true)
                        }
                    }
                }
            }
        }
    }
}
