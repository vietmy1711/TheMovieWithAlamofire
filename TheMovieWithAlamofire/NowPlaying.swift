//
//  NowPlaying.swift
//  TheMovieWithAlamofire
//
//  Created by MM on 7/24/20.
//  Copyright © 2020 MM. All rights reserved.
//

import Foundation

struct NowPlaying: Decodable {
    let results: [Results?]
}

struct Results: Decodable {
    let id: Int?
    let title: String?
    let poster_path: String?
    var vote_count: Int?
    var vote_average: Float?
    let release_date: String?
    let overview: String?
}
