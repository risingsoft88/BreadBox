//
//  User.swift
//  Bevy
//
//  Created by macOS on 7/7/20.
//  Copyright © 2020 Nathan Ellis. All rights reserved.
//

import UIKit
import ObjectMapper

class Card: BaseObject {
    // Card property
    var userID: String?
    var cardHolder: String?
    var cardNumber: String?
    var expirationYear: UInt?
    var expirationMonth: UInt?
    var cvc: String?

    override func mapping(map: Map) {
        super.mapping(map: map)
        userID                      <- map["userID"]
        cardHolder                  <- map["cardHolder"]
        cardNumber                  <- map["cardNumber"]
        expirationYear              <- map["expirationYear"]
        expirationMonth             <- map["expirationMonth"]
        cvc                         <- map["cvc"]
    }

    override func attach(_ model: BaseObject) {
        super.attach(model)
        guard let card = model as? Card else { return }

        userID                      = card.userID ?? userID
        cardHolder                  = card.cardHolder ?? cardHolder
        cardNumber                  = card.cardNumber ?? cardNumber
        expirationYear              = card.expirationYear ?? expirationYear
        expirationMonth             = card.expirationMonth ?? expirationMonth
        cvc                         = card.cvc ?? cvc
    }
}
