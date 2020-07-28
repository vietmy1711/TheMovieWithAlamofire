//
//  Session.swift
//  TheMovieWithAlamofire
//
//  Created by MM on 7/28/20.
//  Copyright © 2020 MM. All rights reserved.
//

import Foundation

struct Session: Codable {
    let session_id: String?
    let success: Bool?
}

struct SessionLogOut: Codable {
    let success: Bool?
}
