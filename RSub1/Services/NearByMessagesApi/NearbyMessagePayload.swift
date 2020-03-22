//
//  MessagePayload.swift
//  RSub1
//
//  Created by b600609 on 22.03.20.
//  Copyright © 2020 RSub1. All rights reserved.
//

import Foundation

struct NearbyMessagePayload: Codable {
    
    var mMessageBody: String = ""
    var mUUID: String = ""
    
    static func decode(_ nearbyMessagePayloadJson: String) -> NearbyMessagePayload? {
        do {
            let decodedSentences = try JSONDecoder().decode(NearbyMessagePayload.self, from: nearbyMessagePayloadJson.data(using: .utf8)!)

            return decodedSentences
        } catch { print(error) }
        
        return nil
    }
    
    static func encode(_ nearbyMessagePayload: NearbyMessagePayload) -> String {
        do {
            let jsonData = try JSONEncoder().encode(nearbyMessagePayload)
            let jsonString = String(data: jsonData, encoding: .utf8)!

            return jsonString

        } catch { print(error) }
        
        return ""
    }
}
