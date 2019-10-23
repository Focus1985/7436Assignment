//
//  User.swift
//  HelpByDrone
//
//  Created by Focus on 22/10/19.
//  Copyright © 2019 Focus. All rights reserved.
//

import Foundation

struct User: Decodable {
    let id: Int
    let username: String
    let name: String
    let age: Int
}
