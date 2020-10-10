//
//  Keyword.swift
//  moment
//
//  Created by Juyeon on 2020/10/10.
//  Copyright © 2020 주연  유. All rights reserved.
//

import Foundation
import RealmSwift

struct Keyword {
    let title: String
    let date: Date
    
    init() {
        self.title = ""
        self.date = Date()
    }
    
    init(keywordRealm: KeywordRealm) {
        self.title = keywordRealm.title
        self.date = keywordRealm.date
    }
}

class KeywordRealm: Object {
    @objc dynamic var title = ""
    @objc dynamic var date: Date = Date()
}
