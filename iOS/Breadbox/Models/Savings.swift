//
//  Savings.swift
//  Bevy
//
//  Created by macOS on 9/3/20.
//  Copyright © 2020 Nathan Ellis. All rights reserved.
//

import UIKit
import ObjectMapper

class Savings: BaseObject {
    var title: String?
    var amount: String?

    override func mapping(map: Map) {
        super.mapping(map: map)
        title                       <- map["title"]
        amount                      <- map["amount"]
    }

    override func attach(_ model: BaseObject) {
        super.attach(model)
        guard let savings = model as? Savings else { return }

        title                       = savings.title ?? title
        amount                      = savings.amount ?? amount
    }
}
