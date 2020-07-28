//
//  RequestToken.swift
//  TheMovieWithAlamofire
//
//  Created by MM on 7/24/20.
//  Copyright © 2020 MM. All rights reserved.
//

import Foundation

struct RequestToken: Codable {
    let success: Bool?
    let expires_at: String?
    let request_token: String?
}
