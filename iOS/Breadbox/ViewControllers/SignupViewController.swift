//
//  SignupViewController.swift
//  Bread Box
//
//  Created by macOS on 11/23/20.
//  Copyright © 2020 Nathan Ellis. All rights reserved.
//

import UIKit

class SignupViewController: UIViewController {

    @IBOutlet weak var imgBackground: UIImageView!
    @IBOutlet var imgLogo: UIImageView!
    @IBOutlet var lblTitle: UILabel!

    var imgs = [R.image.signUp01(), R.image.signUp02(), R.image.signUp03(), R.image.signUp04()]

    override func viewDidLoad() {
        super.viewDidLoad()

        let randomIndex = Int.random(in: 0..<imgs.count)
        self.imgBackground.image = imgs[randomIndex]
        if (randomIndex == 1) {
            self.lblTitle.text = "SIGN UP AND SHARE YOUR FOOD WITH THE WORLD."
        } else if (randomIndex == 2) {
            self.imgLogo.image = R.image.imgLogoBlack()
        }
    }

    @IBAction func tapLogin(_ sender: Any) {
        let vc = R.storyboard.main().instantiateViewController(withIdentifier: "LoginViewController") as! LoginViewController
        vc.modalPresentationStyle = .fullScreen
        self.present(vc, animated: true, completion: nil)
    }

    @IBAction func tapSignup(_ sender: Any) {
        let vc = R.storyboard.main().instantiateViewController(withIdentifier: "RegisterViewController") as! RegisterViewController
        vc.modalPresentationStyle = .fullScreen
        self.present(vc, animated: true, completion: nil)
    }

    @IBAction func tapFacebook(_ sender: Any) {
    }

    @IBAction func tapTwitter(_ sender: Any) {
    }

    @IBAction func tapGoogle(_ sender: Any) {
    }
}
