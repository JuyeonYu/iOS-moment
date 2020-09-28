//
//  DetailItemViewController.swift
//  moment
//
//  Created by 주연  유 on 2020/09/24.
//  Copyright © 2020 주연  유. All rights reserved.
//

import UIKit
import Kingfisher

class DetailItemViewController: UIViewController {

    @IBOutlet weak var bookImageView: UIImageView!
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var textView: UITextView!
    @IBOutlet weak var progressView: UIProgressView!
    
    var currentBook: BookRealm? = nil
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.textView.delegate = self
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.titleLabel.text = self.currentBook?.title
        self.bookImageView.kf.setImage(with: URL(string: self.currentBook?.image ?? ""))
        
        self.textView.text = "내용입력"
        textView.textColor = UIColor.lightGray
        
        self.progressView.progress = Float(Float(self.currentBook!.progress) / 100)
    }
    
    func textViewSetupView() {
        if textView.text == "내용입력" {
            textView.text = ""
            textView.textColor = UIColor.label
        } else if textView.text == "" {
            textView.text = "내용입력"
            textView.textColor = UIColor.lightGray
        }
    }

}

extension DetailItemViewController: UITextViewDelegate {
    func textViewDidBeginEditing(_ textView: UITextView) {
        self.textViewSetupView()
    }
    
    func textViewDidEndEditing(_ textView: UITextView) {
        if textView.text == "" {
            self.textViewSetupView()
        }
    }
    
    func textView(_ textView: UITextView, shouldChangeTextIn range: NSRange, replacementText text: String) -> Bool {
        if text == "\n" {
            textView.resignFirstResponder()
        }
        return true
    }
}
