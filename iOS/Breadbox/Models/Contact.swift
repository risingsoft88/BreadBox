//
//  Contact.swift
//  Bevy
//
//  Created by macOS on 2/2/21.
//  Copyright © 2021 Nathan Ellis. All rights reserved.
//

import UIKit
import ObjectMapper

class Contact: BaseObject {
    var ownerID: String?
    var contactID: String?

    override func mapping(map: Map) {
        super.mapping(map: map)
        ownerID                     <- map["ownerID"]
        contactID                   <- map["contactID"]
    }

    override func attach(_ model: BaseObject) {
        super.attach(model)
        guard let contact = model as? Contact else { return }

        ownerID                     = contact.ownerID ?? ownerID
        contactID                   = contact.contactID ?? contactID
    }
}

