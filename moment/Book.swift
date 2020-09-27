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
//    @objc dynamic var desc = ""
//    @objc dynamic var desc = ""
}
