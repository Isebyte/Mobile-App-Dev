//
//  CodeableMovie.swift
//  Movie Search App
//
//  Created by Isabelle Xu on 10/9/18.
//  Copyright © 2018 WashU. All rights reserved.
//

import Foundation

// Codable protocol stucts for parsing the JSON data from TMDb

struct APIResults:Decodable {
    let page: Int
    let total_results: Int
    let total_pages: Int
    let results: [Movie]
}
struct Movie: Decodable {
    let id: Int!
    let poster_path: String?
    let title: String
    let release_date: String
    let vote_average: Double
    let overview: String
    let vote_count:Int!
}
