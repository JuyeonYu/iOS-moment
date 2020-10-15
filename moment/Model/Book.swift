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
    let title: String
    let link: String
    let imageURL: String
    let author: String
    let price: String
    let discount: String
    let publisher: String
    let pubdate: String
    let isbn: String
    let desc: String
    var progress: Float?
    var memo: String?
    var image: UIImage?
    
    init() {
        self.title = ""
        self.link = ""
        self.imageURL = ""
        self.author = ""
        self.price = ""
        self.discount = ""
        self.publisher = ""
        self.pubdate = ""
        self.isbn = ""
        self.desc = ""
        self.progress = 0
        self.memo = ""
    }
    
    init(bookRealm: BookRealm) {
        self.title = bookRealm.title
        self.link = bookRealm.link
        self.imageURL = bookRealm.image
        self.author = bookRealm.author
        self.price = bookRealm.price
        self.discount = bookRealm.discount
        self.publisher = bookRealm.publisher
        self.pubdate = bookRealm.pubdate
        self.isbn = bookRealm.isbn
        self.desc = bookRealm.desc
        self.progress = bookRealm.progress
        self.memo = bookRealm.memo
    }
    
    init(naverBook: NaverBookItem) {
        self.title = naverBook.title.withoutHtml
        self.link = naverBook.link
        self.imageURL = naverBook.image
        self.author = naverBook.author
        self.price = naverBook.price
        self.discount = naverBook.discount
        self.publisher = naverBook.publisher
        self.pubdate = naverBook.pubdate
        self.isbn = naverBook.isbn
        self.desc = naverBook.itemDescription.withoutHtml
    }
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
    @objc dynamic var progress: Float = 0
    @objc dynamic var memo = ""
    
//    init(book: Book) {
//        self.title = book.title
//        self.link = book.link
//    }
//    
//    required init() {
//        fatalError("init() has not been implemented")
//    }
}

struct NaverBook: Codable {
    let lastBuildDate: String
    let total, start, display: Int
    let items: [NaverBookItem]
}

struct NaverBookItem: Codable {
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
