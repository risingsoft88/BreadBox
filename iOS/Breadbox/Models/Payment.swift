//
//  Payment.swift
//  Bevy
//
//  Created by macOS on 11/25/20.
//  Copyright © 2020 Nathan Ellis. All rights reserved.
//

import UIKit
import ObjectMapper
import FirebaseFirestore

class Payment: BaseObject {
    var paymentID: String?
    var type: String?
    var amount: Int?
    var userID: String?

    //for charge
    var net: Int?
    var fee: Int?
    var brand: String?
    var last4: String?
    var status: String?

    //for sent
    var senderID: String?
    var senderUsername: String?
    var senderEmail: String?
    var senderPhotoUrl: String?
    var receiverID: String?
    var receiverUsername: String?
    var receiverEmail: String?
    var receiverPhotoUrl: String?

    //for saving
    var rounded: Int?

    //for live event spend
    var merchantName: String?
    var cardID: String?
    var approved: Bool?

    override func mapping(map: Map) {
        super.mapping(map: map)
        paymentID               <- map["paymentID"]
        type                    <- map["type"]
        amount                  <- map["amount"]
        userID                  <- map["userID"]

        net                     <- map["net"]
        fee                     <- map["fee"]
        brand                   <- map["brand"]
        last4                   <- map["last4"]
        status                  <- map["status"]

        senderID                <- map["senderID"]
        senderUsername          <- map["senderUsername"]
        senderEmail             <- map["senderEmail"]
        senderPhotoUrl          <- map["senderPhotoUrl"]
        receiverID              <- map["receiverID"]
        receiverUsername        <- map["receiverUsername"]
        receiverEmail           <- map["receiverEmail"]
        receiverPhotoUrl        <- map["receiverPhotoUrl"]

        rounded                 <- map["rounded"]

        merchantName            <- map["merchantName"]
        cardID                  <- map["cardID"]
        approved                <- map["approved"]
    }

    override func attach(_ model: BaseObject) {
        super.attach(model)
        guard let payment = model as? Payment else { return }

        paymentID                   = payment.paymentID ?? paymentID
        type                        = payment.type ?? type
        amount                      = payment.amount ?? amount
        userID                      = payment.userID ?? userID

        net                         = payment.net ?? net
        fee                         = payment.fee ?? fee
        brand                       = payment.brand ?? brand
        last4                       = payment.last4 ?? last4
        status                      = payment.status ?? status

        senderID                    = payment.senderID ?? senderID
        senderUsername              = payment.senderUsername ?? senderUsername
        senderEmail                 = payment.senderEmail ?? senderEmail
        senderPhotoUrl              = payment.senderPhotoUrl ?? senderPhotoUrl
        receiverID                  = payment.receiverID ?? receiverID
        receiverUsername            = payment.receiverUsername ?? receiverUsername
        receiverEmail               = payment.receiverEmail ?? receiverEmail
        receiverPhotoUrl            = payment.receiverPhotoUrl ?? receiverPhotoUrl

        rounded                     = payment.rounded ?? rounded

        merchantName                = payment.merchantName ?? merchantName
        cardID                      = payment.cardID ?? cardID
        approved                    = payment.approved ?? approved
    }
}
