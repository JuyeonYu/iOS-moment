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
    @IBOutlet weak var memoTextView: UITextView!
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
            self.delegate?.saveData(progress: self.slider.value,
                                    memo: self.memoTextView.text,
                                    type: self.selectedType)
        }
    }
    
    @IBOutlet weak var guideLabel: UILabel!
    override func viewDidLoad() {
        super.viewDidLoad()
        self.memoTextView.delegate = self
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        guideLabel.text = NSLocalizedString("proceeding", comment: "")
        processingLabel.text = NSLocalizedString("begin", comment: "")
        saveButton.setTitle(NSLocalizedString("save", comment: ""), for: .normal) 
        saveButton.layer.cornerRadius = 0.5 * saveButton.bounds.size.height
        memoTextView.layer.cornerRadius = 0.05 * memoTextView.bounds.size.width
    }
}

extension SelectBookMarkViewController: UITextViewDelegate {
    func textViewDidBeginEditing(_ textView: UITextView) {
        Util.setMemoTextView(textView: memoTextView)
    }
    
    func textViewDidEndEditing(_ textView: UITextView) {
        if textView.text == "" {
            Util.setMemoTextView(textView: memoTextView)
        }
    }
}
