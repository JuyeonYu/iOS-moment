//
//  NaverBook.swift
//  moment
//
//  Created by Juyeon on 2020/09/27.
//  Copyright © 2020 주연  유. All rights reserved.
//

import Foundation

// This file was generated from JSON Schema using quicktype, do not modify it directly.
// To parse the JSON, add this file to your project and do:
//
//   let book = try? newJSONDecoder().decode(Book.self, from: jsonData)

import Foundation

// MARK: - Book
struct NaverBook: Codable {
    let lastBuildDate: String
    let total, start, display: Int
    let items: [Item]
}

// MARK: - Item
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
