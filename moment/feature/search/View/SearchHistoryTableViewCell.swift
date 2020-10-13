//
//  SearchHistoryTableViewCell.swift
//  moment
//
//  Created by Juyeon on 2020/10/10.
//  Copyright © 2020 주연  유. All rights reserved.
//

import UIKit

protocol SearchHistoryTableViewCellDelegate: class {
    func didTouchDeleteButton(indexPath: IndexPath)
}

class SearchHistoryTableViewCell: UITableViewCell {
    @IBOutlet weak var searchKeyword: UILabel!
    @IBOutlet weak var searchDate: UILabel!
    var indexPath: IndexPath!
    
    weak var delegate: SearchHistoryTableViewCellDelegate?
    
    @IBAction func didTouchDeleteButton(_ sender: Any) {
        self.delegate?.didTouchDeleteButton(indexPath: indexPath)
    }
    override func awakeFromNib() {
        super.awakeFromNib()
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}
