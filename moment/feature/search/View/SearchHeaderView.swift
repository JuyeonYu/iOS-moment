//
//  SearchHeaderView.swift
//  moment
//
//  Created by Juyeon on 2020/10/14.
//  Copyright © 2020 주연  유. All rights reserved.
//

import UIKit

protocol SearchHeaderViewDelegate: class {
    func didTapInpuManualButton()
}

class SearchHeaderView: UIView {
    
    //MARK: Variable: IBOutlet
    
    @IBOutlet var mainView: UIView!
    
    @IBOutlet weak var inputManualButton: UIButton!
    @IBOutlet weak var guideLabel: UILabel!
    
    weak var delegate: SearchHeaderViewDelegate?
    
    @IBAction func didTapInpuManualButton(_ sender: Any) {
        self.delegate?.didTapInpuManualButton()
    }
    
    // 스토리보드로 초기화 시킬 때 필요
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        customInit()
    }
    
    // 코드로 초기화 시킬 때 필요
    override init(frame: CGRect) {
        super.init(frame: frame)
        customInit()
    }
    
    //MARK: Custom Init
    
    private func customInit() {
        Bundle.main.loadNibNamed("SearchHeaderView", owner: self, options: nil)
        
        mainView.frame = self.bounds
        mainView.autoresizingMask = [.flexibleWidth, .flexibleHeight]
        inputManualButton.setTitle(NSLocalizedString("input manually", comment: ""), for: .normal)
        guideLabel.text = NSLocalizedString("no result in searching", comment: "")
        addSubview(mainView)
    }
}
