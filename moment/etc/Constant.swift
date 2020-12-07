//
//  Constant.swift
//  moment
//
//  Created by Juyeon on 2020/09/29.
//  Copyright © 2020 주연  유. All rights reserved.
//

import Foundation

class Constant {
    static let detailTextFieldPlaceHolder = "메모"
    static let googleADModID = "ca-app-pub-7604048409167711/3193147154"
    
}

enum NaverSearchType: CaseIterable {
    case Book, Movie
}

enum ShowDataType: Int {
    case ProgressBook = 0
    case CompleteBook = 1
    case ProgressMovie = 2
    case CompleteMovie = 3
    
    static let count: Int = {
            var max: Int = 0
            while let _ = ShowDataType(rawValue: max) { max += 1 }
            return max
        }()
}
