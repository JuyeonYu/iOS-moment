//
//  SelectBookMarkViewController.swift
//  moment
//
//  Created by Juyeon on 2020/09/28.
//  Copyright © 2020 주연  유. All rights reserved.
//

import UIKit

class SelectBookMarkViewController: UIViewController {

    @IBOutlet weak var processingLabel: UILabel!
    @IBOutlet weak var slider: UISlider!
    @IBAction func didSliderMove(_ sender: Any) {
        self.guideLabel.isHidden = true
        let stepCount = 25
        let roundedCurrent = (slider.value/Float(stepCount)).rounded()
        let newValue = Int(roundedCurrent) * stepCount
        slider.setValue(Float(newValue), animated: true)
        
        self.setProcessingLabel(value: newValue)
    }
    @IBOutlet weak var saveButton: UIButton!
    weak var delegate: SearchItemViewControllerDelegate?
    
    @IBAction func didTapSaveButton(_ sender: Any) {
        self.dismiss(animated: false) {
            self.delegate?.saveData(value: Int(self.slider.value))
        }
    }
    
    @IBOutlet weak var guideLabel: UILabel!
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Do any additional setup after loading the view.
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        saveButton.layer.cornerRadius = 0.5 * saveButton.bounds.size.height
    }
    
    func setProcessingLabel(value: Int) {
        if value == 0 {
            self.processingLabel.text = "이제 보기 시작했어요"
        } else if value == 25 {
            self.processingLabel.text = "조금 봤어요"
        } else if value == 50 {
            self.processingLabel.text = "중간쯤 봤어요"
        } else if value == 75 {
            self.processingLabel.text = "거의 다 봤어요"
        } else {
            self.processingLabel.text = "다 봤어요!"
        }
    }
}
