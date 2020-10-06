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
            return NSLocalizedString("begin", comment: "")
        } else if percent == 25 {
            return NSLocalizedString("proceeding1", comment: "")
        } else if percent == 50 {
            return NSLocalizedString("proceeding2", comment: "")
        } else if percent == 75 {
            return NSLocalizedString("proceeding3", comment: "")
        } else {
            return NSLocalizedString("end", comment: "")
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
