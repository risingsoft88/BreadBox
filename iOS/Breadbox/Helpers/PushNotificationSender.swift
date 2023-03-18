//
//  PushNotificationSender.swift
//  Bevy
//
//  Created by macOS on 11/30/20.
//  Copyright © 2020 Nathan Ellis. All rights reserved.
//

import UIKit
class PushNotificationSender {
    func sendPushNotification(to token: String, title: String, body: String) {
        let urlString = "https://fcm.googleapis.com/fcm/send"
        let url = NSURL(string: urlString)!
        let paramString: [String : Any] = ["to" : token,
                                           "notification" : ["title" : title, "body" : body],
                                           "data" : ["user" : "test_id"]
        ]
        let request = NSMutableURLRequest(url: url as URL)
        request.httpMethod = "POST"
        request.httpBody = try? JSONSerialization.data(withJSONObject:paramString, options: [.prettyPrinted])
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")
        request.setValue("key=AAAAWtiGRh8:APA91bExpG8sk4TK1DbS9zyynmoUgHJ7nFLLGRHnpRx2D2JD4F3Ws9qpKaEnjBPz-TqBSkImPiE2rwER-ou4lrfT6HaFCZPBfKmSy3V-Y-_ZV9GLyv2jYiN7JQFRt_sx1gU-s0qdWLUa", forHTTPHeaderField: "Authorization")
        let task =  URLSession.shared.dataTask(with: request as URLRequest)  { (data, response, error) in
            do {
                if let jsonData = data {
                    if let jsonDataDict  = try JSONSerialization.jsonObject(with: jsonData, options: JSONSerialization.ReadingOptions.allowFragments) as? [String: AnyObject] {
                        NSLog("Received data:\n\(jsonDataDict))")
                    }
                }
            } catch let err as NSError {
                print(err.debugDescription)
            }
        }
        task.resume()
    }
}
