//
//  Utils.swift
//  Bevy
//
//  Created by macOS on 7/2/20.
//  Copyright © 2020 Nathan Ellis. All rights reserved.
//

import UIKit
import SDWebImage

class Utils {

    static func isPasswordValid(_ password: String) -> Bool {
        let passwordTest = NSPredicate(format: "SELF MATCHES %@", "^(?=.*[a-z])(?=.*[$@$#!%*?&])[A-Za-z\\d$@$#!%*?&]{8,}")
        return passwordTest.evaluate(with: password)
    }

    static func loadAvatar(_ imageView: UIImageView) {
        guard let user = AppManager.shared.currentUser else {
            imageView.image = R.image.img_avatar_empty()
            return
        }

        imageView.layoutIfNeeded()
        imageView.layer.cornerRadius = imageView.frame.size.width / 2

        if (user.photoUrl != nil && !user.photoUrl!.isEmpty) {
            imageView.sd_imageIndicator = SDWebImageActivityIndicator.gray
            imageView.sd_setImage(with: URL(string: user.photoUrl!), placeholderImage: R.image.img_avatar_empty())
        } else {
            imageView.image = R.image.img_avatar_empty()
        }
    }

    static func loadUserAvatar(_ imageView: UIImageView, url: String) {
        imageView.layoutIfNeeded()
        imageView.layer.cornerRadius = imageView.frame.size.width / 2

        if (!url.isEmpty) {
            imageView.sd_imageIndicator = SDWebImageActivityIndicator.gray
            imageView.sd_setImage(with: URL(string: url), placeholderImage: R.image.img_avatar_empty())
        } else {
            imageView.image = R.image.img_avatar_empty()
        }
    }
}
