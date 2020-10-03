//
//  Util.swift
//  moment
//
//  Created by Juyeon on 2020/09/27.
//  Copyright © 2020 주연  유. All rights reserved.
//

import Foundation
import Kingfisher

class Util {
    class func processingText (percent: Float) -> String{
        if percent == 0 {
            return "이제 보기 시작했어요"
        } else if percent == 25 {
            return "조금 봤어요"
        } else if percent == 50 {
            return "중간쯤 봤어요"
        } else if percent == 75 {
            return "거의 다 봤어요"
        } else {
            return "다 봤어요!"
        }
    }
}

extension String {
    public var withoutHtml: String {
        guard let data = self.data(using: .utf8) else {
            return self
        }

        let options: [NSAttributedString.DocumentReadingOptionKey: Any] = [
            .documentType: NSAttributedString.DocumentType.html,
            .characterEncoding: String.Encoding.utf8.rawValue
        ]

        guard let attributedString = try? NSAttributedString(data: data, options: options, documentAttributes: nil) else {
            return self
        }

        return attributedString.string
    }
    
    
}
