//
//  Book.swift
//  moment
//
//  Created by Juyeon on 2020/09/27.
//  Copyright © 2020 주연  유. All rights reserved.
//

import Foundation
import RealmSwift

struct Book {
    var title = ""
    var link = ""
    var image = ""
    var author = ""
    var price = ""
    var discount = ""
    var publisher = ""
    var pubdate = ""
    var isbn = ""
    var desc = ""
}

class BookRealm: Object {
    @objc dynamic var title = ""
    @objc dynamic var link = ""
    @objc dynamic var image = ""
    @objc dynamic var author = ""
    @objc dynamic var price = ""
    @objc dynamic var discount = ""
    @objc dynamic var publisher = ""
    @objc dynamic var pubdate = ""
    @objc dynamic var isbn = ""
    @objc dynamic var desc = ""
    @objc dynamic var progress: Int = 0
    @objc dynamic var memo = ""
}

struct NaverBook: Codable {
    let lastBuildDate: String
    let total, start, display: Int
    let items: [Item]
}

struct Item: Codable {
    let title: String
    let link: String
    let image: String
    let author, price, discount, publisher: String
    let pubdate, isbn, itemDescription: String

    enum CodingKeys: String, CodingKey {
        case title, link, image, author, price, discount, publisher, pubdate, isbn
        case itemDescription = "description"
    }
}
