//
//  User.swift
//  Bevy
//
//  Created by macOS on 7/7/20.
//  Copyright © 2020 Nathan Ellis. All rights reserved.
//

import UIKit
import ObjectMapper

class User: BaseObject {
    // User property
    var userID: String?
    var username: String?
    var name: String?
    var email: String?
    var password: String?
    var photoUrl: String?
    var userType: String?
    var phone: String?
    var gender: String?
    var birthday: String?
    var fcmToken: String?

    override func mapping(map: Map) {
        super.mapping(map: map)
        userID                      <- map["userID"]
        username                    <- map["username"]
        name                        <- map["name"]
        email                       <- map["email"]
        password                    <- map["password"]
        photoUrl                    <- map["photoUrl"]
        userType                    <- map["userType"]
        phone                       <- map["phone"]
        gender                      <- map["gender"]
        birthday                    <- map["birthday"]
        fcmToken                    <- map["fcmToken"]
    }

    override func attach(_ model: BaseObject) {
        super.attach(model)
        guard let user = model as? User else { return }

        userID              = user.userID ?? userID
        username            = user.username ?? username
        name                = user.name ?? name
        email               = user.email ?? email
        password            = user.password ?? password
        photoUrl            = user.photoUrl ?? photoUrl
        userType            = user.userType ?? userType
        phone               = user.phone ?? phone
        gender              = user.gender ?? gender
        birthday            = user.birthday ?? birthday
        fcmToken            = user.fcmToken ?? fcmToken
    }
}
