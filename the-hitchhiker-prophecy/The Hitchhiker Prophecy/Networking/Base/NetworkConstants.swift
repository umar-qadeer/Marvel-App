//
//  NetworkConstants.swift
//  The Hitchhiker Prophecy
//
//  Created by Mohamed Matloub on 6/10/20.
//  Copyright © 2020 SWVL. All rights reserved.
//

import Foundation
import CryptoKit

enum NetworkConstants {
    static let baseUrl = "https://gateway.marvel.com"
    static let publicKey = "5849f5849ee8952b6255bed94aa4639a" // TODO: Add your marvel keys
    static let privateKey = "5aaa50cb88f8bd10c5ba31e79a5ec53d112c2fa0" // TODO: Add your marvel keys
}

extension NetworkConstants {
    static func hash(timeStamp: String) -> String {
        if let utf8Data = (timeStamp + privateKey + publicKey).data(using: .utf8) {
            let digest = Insecure.MD5.hash(data: utf8Data)
            return digest.map {
                String(format: "%02hhx", $0)
            }.joined()
        }
        
        return ""
    }
}
