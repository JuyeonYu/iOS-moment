//
//  SelectBookMarkViewController.swift
//  moment
//
//  Created by Juyeon on 2020/09/28.
//  Copyright © 2020 주연  유. All rights reserved.
//

import UIKit

class SelectBookMarkViewController: UIViewController {
    var selectedType: NaverSearchType = .Book
    @IBOutlet weak var processingLabel: UILabel!
    @IBOutlet weak var slider: UISlider!
    @IBAction func didSliderMove(_ sender: Any) {
        self.guideLabel.isHidden = true
        let stepCount = 25
        let roundedCurrent = (slider.value/Float(stepCount)).rounded()
        let newValue = Int(roundedCurrent) * stepCount
        slider.setValue(Float(newValue), animated: true)
        self.processingLabel.text = Util.processingText(percent: slider.value)
    }
    @IBOutlet weak var saveButton: UIButton!
    weak var delegate: SearchItemViewControllerDelegate?
    
    @IBAction func didTapSaveButton(_ sender: Any) {
        self.dismiss(animated: false) {
            self.delegate?.saveData(value: self.slider.value, type: self.selectedType)
        }
    }
    
    @IBOutlet weak var guideLabel: UILabel!
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        saveButton.layer.cornerRadius = 0.5 * saveButton.bounds.size.height
    }
}
