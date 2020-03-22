//
//  NearByMessagesApi.swift
//  RSub1
//
//  Created by Alexandru Petrescu on 21.03.20.
//  Copyright © 2020 RSub1. All rights reserved.
//

import Foundation
import UIKit

struct NearByMessageApi {
    
    private static let myAPIKey = NearByMessageApiKey.myAPIKey
    
    private static var nearbyPermission: GNSPermission!

    private static var messageMgr: GNSMessageManager?
    private static var publication: GNSPublication?
    private static var subscription: GNSSubscription?
    
    private static var devices: [NearByModel] = []
    private static var currentExposure: [NearByModel] = []
    
    static func initialize() {
        GNSPermission.setGranted(!GNSPermission.isGranted())
        
//        GNSMessageManager.setDebugLoggingEnabled(true)

        // Create the message manager, which lets you publish messages and subscribe to messages
        // published by nearby devices.
        messageMgr = GNSMessageManager(apiKey: myAPIKey,
          paramsBlock: {(params: GNSMessageManagerParams?) -> Void in
            guard let params = params else { return }

            // This is called when microphone permission is enabled or disabled by the user.
            params.microphonePermissionErrorHandler = { hasError in
              if (hasError) {
                print("Nearby works better if microphone use is allowed")
              }
            }
            // This is called when Bluetooth permission is enabled or disabled by the user.
            params.bluetoothPermissionErrorHandler = { hasError in
              if (hasError) {
                print("Nearby works better if Bluetooth use is allowed")
              }
            }
            // This is called when Bluetooth is powered on or off by the user.
            params.bluetoothPowerErrorHandler = { hasError in
              if (hasError) {
                print("Nearby works better if Bluetooth is turned on")
              }
            }
        })

    }

     /// Starts publishing the specified name and scanning for nearby devices that are publishing
     /// their names.
     static func startSharing(withName name: String) {
       if let messageMgr = self.messageMgr {
         // Publish the name to nearby devices.
         let pubMessage: GNSMessage = GNSMessage(content: name.data(using: .utf8,
           allowLossyConversion: true))
         publication = messageMgr.publication(with: pubMessage)

         // Subscribe to messages from nearby devices and display them in the message view.
         subscription = messageMgr.subscription(messageFoundHandler: {(message: GNSMessage?) -> Void in
            guard let message = message else { return }
            guard let encodedMessage = String(data: message.content, encoding: .utf8) else { return }
            newMessage(encodedMessage);
         }, messageLostHandler: {(message: GNSMessage?) -> Void in
             guard let message = message else { return }
             guard let encodedMessage = String(data: message.content, encoding: .utf8) else { return }
             lostMessage(encodedMessage);
         })
       }
     }
     
     /// Stops publishing/subscribing.
     static func stopSharing() {
         NearByMessageApi.publication = nil
         NearByMessageApi.subscription = nil
     }
    
    static func getExposures() -> [NearByModel] {
        var exposures: [NearByModel] = []
        exposures.append(contentsOf: devices)
        exposures.append(contentsOf: currentExposure)
        
        exposures.sort {
            $0.startExposure < $1.startExposure
        }
        
        return exposures;
    }
     
     private static func newMessage(_ message: String) {
        guard let payload = NearbyMessagePayload.decode(message) else { return }
        print("newMessage: \(payload.mUUID) - \(payload.mMessageBody)")
        
        let interaction = NearByModel(uuid: payload.mMessageBody, distance: nil, startExposure: Int(NSDate().timeIntervalSince1970), endExposure: nil)
        
        currentExposure.append(interaction)
        
     }
     
     private static func lostMessage(_ message: String) {
        guard let payload = NearbyMessagePayload.decode(message) else { return }
        print("lostMessage: \(payload.mUUID) - \(payload.mMessageBody)")
        
        if let interactionIndex = currentExposure.firstIndex(where: { $0.uuid == payload.mMessageBody }) {
            var interaction = currentExposure[interactionIndex];
            interaction.endExposure = Int(NSDate().timeIntervalSince1970)
            currentExposure.remove(at: interactionIndex)
            devices.append(interaction)
        }
        
     }
    
}
