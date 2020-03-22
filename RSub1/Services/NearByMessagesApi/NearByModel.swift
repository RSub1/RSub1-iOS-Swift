//
//  NearByModel.swift
//  RSub1
//
//  Created by Alexandru Petrescu on 21.03.20.
//  Copyright © 2020 RSub1. All rights reserved.
//

import Foundation

struct NearByModel: Codable {
    var uuid: String
    var distance: Int?
    var startExposure: Int
    var endExposure: Int?
}
