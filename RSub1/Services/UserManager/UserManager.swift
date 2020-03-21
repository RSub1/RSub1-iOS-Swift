//
//  UserManager.swift
//  RSub1
//
//  Created by Alexandru Petrescu on 21.03.20.
//  Copyright © 2020 RSub1. All rights reserved.
//

import Foundation

struct UserManager {
    private static let userKey = "user"
    
    func getUser() -> UserModel? {
        let ud = UserDefaults.standard
        
        if let userModelJson = ud.string(forKey: UserManager.userKey) {
            return decode(userModelJson)
        } else {
            return set(createUser())
        }
    }
    
    func set(_ user: UserModel) -> UserModel? {
        let ud = UserDefaults.standard
        let userAsJson = encode(user)
        
        ud.set(userAsJson, forKey: UserManager.userKey)
        
        return user
    }
    
    func decode(_ userModelJson: String) -> UserModel? {
        do {
            let decodedSentences = try JSONDecoder().decode(UserModel.self, from: userModelJson.data(using: .utf8)!)

            return decodedSentences
        } catch { print(error) }
        
        return nil
    }
    
    func encode(_ userModel: UserModel) -> String {
        do {
            let jsonData = try JSONEncoder().encode(userModel)
            let jsonString = String(data: jsonData, encoding: .utf8)!

            return jsonString

        } catch { print(error) }
        
        return ""
    }
    
    func createUser() -> UserModel {
        var newUser = UserModel()
        newUser.uuid = UUID().uuidString
        
        return newUser
    }
}
