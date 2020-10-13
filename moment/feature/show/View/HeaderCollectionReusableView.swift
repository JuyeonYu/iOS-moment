//
//  HeaderCollectionReusableView.swift
//  moment
//
//  Created by Juyeon on 2020/10/04.
//  Copyright © 2020 주연  유. All rights reserved.
//

import UIKit

class HeaderCollectionReusableView: UICollectionReusableView {
    @IBOutlet weak var headerLabel: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        self.layer.cornerRadius = 0.1 * self.frame.size.height
    }
}
