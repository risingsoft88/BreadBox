//
//  RegisterViewController.swift
//  Breadbox
//
//  Created by macos on 8/17/22.
//

import UIKit
import Firebase
import FirebaseAuth
import FirebaseFirestore
import SVProgressHUD
import Alamofire
import SwiftyJSON

class RegisterViewController: UIViewController, UIImagePickerControllerDelegate, UINavigationControllerDelegate {

    @IBOutlet var imgAvatar: UIImageView!
    @IBOutlet var editUsername: UITextField!
    @IBOutlet var editName: UITextField!
    @IBOutlet var editEmail: UITextField!
    @IBOutlet var editPwd: UITextField!
    @IBOutlet var editRepwd: UITextField!
    @IBOutlet var lblTermPolicy: UILabel!
    @IBOutlet var viewWrapper: UIView!
    @IBOutlet var viewUsername: UIStackView!
    @IBOutlet var viewName: UIStackView!
    @IBOutlet var viewEmail: UIStackView!
    @IBOutlet var viewPwd: UIStackView!
    @IBOutlet var viewRepwd: UIStackView!

    let imagePicker = UIImagePickerController()
    var selectedImage: UIImage? = nil
    var hidePassword = true
    var hideRepassword = true
    var isLoading = false
    var isAvatar = true

    var newUserType = "email"
    var newUsername = ""
    var newName = ""
    var newEmail = ""
    var newPwd = ""
    var newUserPhotoUrl = ""

    override func viewDidLoad() {
        super.viewDidLoad()

        var tapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(tapAvatar(tapGestureRecognizer:)))
        imgAvatar.isUserInteractionEnabled = true
        imgAvatar.addGestureRecognizer(tapGestureRecognizer)
        tapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(tapTermsPolicy(tapGestureRecognizer:)))
        lblTermPolicy.isUserInteractionEnabled = true
        lblTermPolicy.addGestureRecognizer(tapGestureRecognizer)

        imagePicker.delegate = self
        imagePicker.allowsEditing = true
        editPwd.isSecureTextEntry = hidePassword
        editRepwd.isSecureTextEntry = hideRepassword
        imgAvatar.layer.cornerRadius = imgAvatar.frame.width/2
    }

    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()

        let path = UIBezierPath(roundedRect:viewWrapper.bounds,
                                byRoundingCorners:[.topRight, .topLeft],
                                cornerRadii: CGSize(width: 20, height: 20))
        let maskLayer = CAShapeLayer()
        maskLayer.path = path.cgPath
        viewWrapper.layer.mask = maskLayer

        viewUsername.addBottomBorderWithColor(color: UIColor(red: CGFloat(1.0), green: CGFloat(1.0), blue: CGFloat(1.0), alpha: CGFloat(31.0/100.0)), width: 1)
        viewName.addBottomBorderWithColor(color: UIColor(red: CGFloat(168.0/255.0), green: CGFloat(67.0/255.0), blue: CGFloat(4.0/255.0), alpha: CGFloat(1.0)), width: 1)
        viewEmail.addBottomBorderWithColor(color: UIColor(red: CGFloat(1.0), green: CGFloat(1.0), blue: CGFloat(1.0), alpha: CGFloat(31.0/100.0)), width: 1)
        viewPwd.addBottomBorderWithColor(color: UIColor(red: CGFloat(1.0), green: CGFloat(1.0), blue: CGFloat(1.0), alpha: CGFloat(31.0/100.0)), width: 1)
        viewRepwd.addBottomBorderWithColor(color: UIColor(red: CGFloat(1.0), green: CGFloat(1.0), blue: CGFloat(1.0), alpha: CGFloat(31.0/100.0)), width: 1)
    }

    @IBAction func tapBack(_ sender: Any) {
        if (isLoading) {
            return
        }
        self.dismiss(animated: true, completion: nil)
    }

    @IBAction func showPwd(_ sender: Any) {
        if (isLoading) {
            return
        }
        hidePassword = !hidePassword
        editPwd.isSecureTextEntry = hidePassword
    }

    @IBAction func showRepwd(_ sender: Any) {
        if (isLoading) {
            return
        }
        hideRepassword = !hideRepassword
        editRepwd.isSecureTextEntry = hideRepassword
    }

    @IBAction func tapSignup(_ sender: Any) {
        if (isLoading) {
            return
        }

        guard let username = editUsername.text?.trimmingCharacters(in: .whitespacesAndNewlines) else { return }
        guard let name = editName.text?.trimmingCharacters(in: .whitespacesAndNewlines) else { return }
        guard let email = editEmail.text?.trimmingCharacters(in: .whitespacesAndNewlines) else { return }
        guard let password = editPwd.text?.trimmingCharacters(in: .whitespacesAndNewlines) else { return }
        guard let repassword = editRepwd.text?.trimmingCharacters(in: .whitespacesAndNewlines) else { return }

        if username.isEmpty {
            showAlert("Please enter a username!")
            return
        }

        if name.isEmpty {
            showAlert("Please enter a first and last name!")
            return
        }

        if !email.isValidEmail() {
            showAlert("Please enter a valid email address!")
            return
        }

        if !password.isValidPassword() {
            showAlert("Please enter a password with 6 or more characters!")
            return
        }

        if password != repassword {
            showAlert("Passwords do not match, please enter a valid password!")
            return
        }

        let alertController = UIAlertController(title: "Are you sure want to create?", message: nil, preferredStyle: .alert)
        let cancelAction = UIAlertAction(title: "Cancel", style: .cancel) { (action) in
            // cancel action
        }
        alertController.addAction(cancelAction)
        let okAction = UIAlertAction(title: "Create", style: .default) { (action) in
            self.isLoading = true
            SVProgressHUD.show()

            let db = Firestore.firestore()

//            if self.newUserType != "" {
//                guard let currentUser = Auth.auth().currentUser else {
//                    self.showErrorAndHideProgress(text: "Unknown Error!")
//                    return
//                }
//
//                var newUserDocRef: DocumentReference
//                newUserDocRef = db.collection("users").document(currentUser.uid)
//
//                let newUser = User()
//                newUser.userID = newUserDocRef.documentID
//                newUser.username = username
//                newUser.name = name
//                newUser.email = email
//                if (self.newUserType == "facebook" || self.newUserType == "twitter" || self.newUserType == "google" || self.newUserType == "apple") {
//                    newUser.password = ""
//                } else {
//                    newUser.password = password
//                }
//                newUser.userType = self.newUserType
//                newUser.phone = phone
//                newUser.gender = ""
//                newUser.photoUrl = self.newUserPhotoUrl
//                newUser.createdAt = Date()
//
//                AppManager.shared.saveCurrentUserRef(userRef: newUserDocRef)
//
//                newUserDocRef.setData(newUser.toJSON()) { error in
//                    if let error = error {
//                        self.showErrorAndHideProgress(text: error.localizedDescription)
//                        return
//                    }
//
//                    if (self.selectedImage != nil) {
//                        let storage = Storage.storage()
//                        let storageRef = storage.reference()
//                        let data = self.selectedImage?.jpegData(compressionQuality: 0.8)
//                        guard let userID = AppManager.shared.currentUser?.userID else {
//                            self.showErrorAndHideProgress(text: "There was an error uploading profile photo. Please try again.")
//                            return
//                        }
//                        let avatarRef = storageRef.child("avatars/\(userID).png")
//                        _ = avatarRef.putData(data!, metadata: nil) { (metadata, error) in
//                            guard metadata != nil else {
//                                self.showErrorAndHideProgress(text: "There was an error uploading profile photo. Please try again.")
//                                return
//                            }
//                            avatarRef.downloadURL { (url, error) in
//                                guard let downloadURL = url else {
//                                    self.showErrorAndHideProgress(text: "There was an error uploading profile photo. Please try again.")
//                                    return
//                                }
//
//                                newUser.photoUrl = downloadURL.absoluteString
//                                newUserDocRef.updateData(["photoUrl": downloadURL.absoluteString])
//
//                                self.createUser(user: newUser)
//                            }
//                        }
//                    } else {
//                        self.createUser(user: newUser)
//                    }
//                }
//                return
//            }

            Auth.auth().createUser(withEmail: email, password: password) { (authResult, error) in
                if let error = error {
                    if (error.localizedDescription == "The email address is already in use by another account.") {
                        SVProgressHUD.dismiss()
                        self.isLoading = false
                        let alertController = UIAlertController(title: "The email address is already in use by exist account.", message: nil, preferredStyle: .alert)
                        let okAction = UIAlertAction(title: "OK", style: .default) { (action) in
                            let vc = R.storyboard.main().instantiateViewController(withIdentifier: "LoginViewController") as! LoginViewController
                            vc.modalPresentationStyle = .fullScreen
                            self.present(vc, animated: true, completion: nil)
                        }
                        alertController.addAction(okAction)
                        self.present(alertController, animated: true)
                        return
                    }
                    self.showErrorAndHideProgress(text: error.localizedDescription)
                    return
                }

                guard let authResult = authResult else {
                    self.showErrorAndHideProgress(text: "There was an error signing up. Please try again.")
                    return
                }

                let authUser: Firebase.User = authResult.user
                let userID = authUser.uid

                db.collection("users").whereField("email", isEqualTo: email).getDocuments { (querySnapshot, error) in
                    if let error = error {
                        self.showErrorAndHideProgress(text: error.localizedDescription)
                        return
                    }

                    guard let snapshot = querySnapshot else {
                        self.showErrorAndHideProgress(text: "There was an error signing up. Please try again.")
                        return
                    }

                    // User exists with the specified email, show error
                    if snapshot.documents.first != nil {
                        self.showErrorAndHideProgress(text: "Email already taken")
                        return
                    }

                    var newUserDocRef: DocumentReference
                    newUserDocRef = db.collection("users").document(userID)

                    let newUser = User()
                    newUser.userID = newUserDocRef.documentID
                    newUser.username = username
                    newUser.name = name
                    newUser.email = email
                    newUser.password = password
                    newUser.userType = "email"
                    newUser.photoUrl = ""
//                    newUser.phone = phone
//                    newUser.gender = ""
                    newUser.createdAt = Date()

                    AppManager.shared.saveCurrentUserRef(userRef: newUserDocRef)

                    newUserDocRef.setData(newUser.toJSON()) { error in
                        if let error = error {
                            self.showErrorAndHideProgress(text: error.localizedDescription)
                            return
                        }

                        if (self.selectedImage != nil) {
                            let storage = Storage.storage()
                            let storageRef = storage.reference()
                            let data = self.selectedImage?.jpegData(compressionQuality: 0.8)
                            let avatarRef = storageRef.child("avatars/\(newUser.userID ?? "").png")
                            _ = avatarRef.putData(data!, metadata: nil) { (metadata, error) in
                                guard metadata != nil else {
                                    self.showErrorAndHideProgress(text: "There was an error uploading profile photo. Please try again.")
                                    return
                                }
                                avatarRef.downloadURL { (url, error) in
                                    guard let downloadURL = url else {
                                        self.showErrorAndHideProgress(text: "There was an error uploading profile photo. Please try again.")
                                        return
                                    }

                                    newUser.photoUrl = downloadURL.absoluteString
                                    newUserDocRef.updateData(["photoUrl": downloadURL.absoluteString])

                                    self.createUser(user: newUser)
                                }
                            }
                        } else {
                            self.createUser(user: newUser)
                        }
                    }
                }
            }
        }
        alertController.addAction(okAction)
        self.present(alertController, animated: true)
    }

    private func createUser(user: User) {
        if (Auth.auth().currentUser!.isEmailVerified || self.newUserType == "facebook" || self.newUserType == "twitter" || self.newUserType == "google") {
            SVProgressHUD.dismiss()
            self.isLoading = false

            if let token = Messaging.messaging().fcmToken {
                AppManager.shared.currentUserRef!.setData(["fcmToken": token], merge: true)
                user.fcmToken = token
            }

            AppManager.shared.saveCurrentUser(user: user)

            let defaults = UserDefaults.standard
            if (self.newUserType == "") {
                defaults.set(user.email, forKey: "useremail")
                defaults.set(user.password, forKey: "userpwd")
            }

            let vc = R.storyboard.main().instantiateViewController(withIdentifier: "OnboardingViewController") as! OnboardingViewController
            vc.modalPresentationStyle = .fullScreen
            self.present(vc, animated: true, completion: nil)
        } else {
            Auth.auth().currentUser?.sendEmailVerification { (error) in
                if let error = error {
                    self.showErrorAndHideProgress(text: error.localizedDescription)
                    return
                }

                SVProgressHUD.dismiss()
                self.isLoading = false

                let alertController = UIAlertController(title: "Sent verification email, please verify your email address!", message: nil, preferredStyle: .alert)
                let okAction = UIAlertAction(title: "OK", style: .default) { (action) in
                    let defaults = UserDefaults.standard
                    defaults.set("", forKey: "useremail")
                    defaults.set("", forKey: "userpwd")
                    let vc = R.storyboard.main().instantiateViewController(withIdentifier: "LoginViewController") as! LoginViewController
                    vc.modalPresentationStyle = .fullScreen
                    self.present(vc, animated: true, completion: nil)
                }
                alertController.addAction(okAction)
                self.present(alertController, animated: true)
            }
        }
    }

    @IBAction func tapSignin(_ sender: Any) {
        if (isLoading) {
            return
        }
        let vc = R.storyboard.main().instantiateViewController(withIdentifier: "LoginViewController") as! LoginViewController
        vc.modalPresentationStyle = .fullScreen
        self.present(vc, animated: true, completion: nil)
    }

    @objc func tapAvatar(tapGestureRecognizer: UITapGestureRecognizer) {
        if (isLoading) {
            return
        }
        isAvatar = true
        let alert: UIAlertController = UIAlertController(title: "Choose Image", message: nil, preferredStyle: .actionSheet)
        let cameraAction = UIAlertAction(title: "Camera", style: .default) {
            UIAlertAction in
            self.openCamera()
        }
        let gallaryAction = UIAlertAction(title: "Gallary", style: .default) {
            UIAlertAction in
            self.openGallary()
        }
        let cancelAction = UIAlertAction(title: "Cancel", style: .cancel) {
            UIAlertAction in
        }

        // Add the actions
        alert.addAction(cameraAction)
        alert.addAction(gallaryAction)
        alert.addAction(cancelAction)
        self.present(alert, animated: true, completion: nil)
    }

    @objc func tapTermsPolicy(tapGestureRecognizer: UITapGestureRecognizer) {
        if (isLoading) {
            return
        }
        let alert: UIAlertController = UIAlertController(title: nil, message: nil, preferredStyle: .actionSheet)
        let termsAction = UIAlertAction(title: "Terms and Conditions", style: .default) {
            UIAlertAction in
            self.selectTerms(index: 0)
        }
        let privacyAction = UIAlertAction(title: "Privacy Policy", style: .default) {
            UIAlertAction in
            self.selectTerms(index: 1)
        }
        let cancelAction = UIAlertAction(title: "Cancel", style: .cancel) {
            UIAlertAction in
        }

        // Add the actions
        alert.addAction(termsAction)
        alert.addAction(privacyAction)
        alert.addAction(cancelAction)
        self.present(alert, animated: true, completion: nil)
    }

    func selectTerms(index: Int) {
        let vc = R.storyboard.main().instantiateViewController(withIdentifier: "TermsViewController") as! TermsViewController
        vc.modalPresentationStyle = .fullScreen
//        vc.type = index // 0: "Terms &\nConditions", 1: "Copyright\nPolicy", 2: "Privacy\nPolicy"
        self.present(vc, animated: true, completion: nil)
    }

    func openCamera() {
        if (UIImagePickerController.isSourceTypeAvailable(.camera)) {
            imagePicker.sourceType = .camera
            self.present(imagePicker, animated: true, completion: nil)
        } else {
            self.showAlert("You don't have camera.")
        }
    }

    func openGallary() {
        imagePicker.sourceType = .photoLibrary
        self.present(imagePicker, animated: true, completion: nil)
    }

    private func showErrorAndHideProgress(text: String) {
        SVProgressHUD.dismiss()
        isLoading = false
        self.showError(text: text)
    }

    //MARK:- UIImagePickerViewDelegate.
    public func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        self.dismiss(animated: true) { [weak self] in
            guard let image = info[.editedImage] as? UIImage else { return }
            if (self!.isAvatar) {
                self?.selectedImage = image
                self?.imgAvatar.image = image
            }
        }
    }

    public func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        self.imagePicker.dismiss(animated: true, completion: nil)
    }
}
