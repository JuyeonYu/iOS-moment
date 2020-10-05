//
//  Movie.swift
//  moment
//
//  Created by 주연  유 on 2020/10/03.
//  Copyright © 2020 주연  유. All rights reserved.
//

import Foundation
import RealmSwift

// This file was generated from JSON Schema using quicktype, do not modify it directly.
// To parse the JSON, add this file to your project and do:
//
//   let post = try? newJSONDecoder().decode(Post.self, from: jsonData)
// MARK: - Post

struct Movie {
    let title: String
    let link: String
    let image: String
    let pubdate: String
    let director: String
    let subtitle: String
    var progress: Float?
    var memo: String?
    
    init() {
        self.title = ""
        self.link = ""
        self.image = ""
        self.director = ""
        self.pubdate = ""
        self.subtitle = ""
        self.progress = 0
        self.memo = ""
    }
    
    init(movieRealm: MovieRealm) {
        self.title = movieRealm.title
        self.link = movieRealm.link
        self.image = movieRealm.image
        self.director = movieRealm.director
        self.pubdate = movieRealm.pubdate
        self.subtitle = movieRealm.subtitle
        self.progress = movieRealm.progress
        self.memo = movieRealm.memo
    }
    
    init(naverMovie: NaverMovieItem) {
        self.title = naverMovie.title.withoutHtml
        self.link = naverMovie.link
        self.director = naverMovie.director
        self.image = naverMovie.image
        self.pubdate = naverMovie.pubDate
        self.subtitle = naverMovie.subtitle.withoutHtml
    }
}

class MovieRealm: Object {
    @objc dynamic var title = ""
    @objc dynamic var link = ""
    @objc dynamic var image = ""
    @objc dynamic var subtitle = ""
    @objc dynamic var pubdate = ""
    @objc dynamic var director = ""
    @objc dynamic var actor = ""
    @objc dynamic var progress: Float = 0
    @objc dynamic var memo = ""
}

struct NaverMovie: Codable {
    let lastBuildDate: String
    let total, start, display: Int
    let items: [NaverMovieItem]
}

// MARK: - Item
struct NaverMovieItem: Codable {
    let title: String
    let link: String
    let image: String
    let subtitle, pubDate, director, actor: String
    let userRating: String
}
