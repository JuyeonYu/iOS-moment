//
//  DetailItemViewController.swift
//  moment
//
//  Created by 주연  유 on 2020/09/24.
//  Copyright © 2020 주연  유. All rights reserved.
//

import UIKit
import Kingfisher
import RealmSwift

class DetailItemViewController: UIViewController {
    
    lazy var realm: Realm = {
        return try! Realm()
    }()

    @IBOutlet weak var bookImageView: UIImageView!
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var memoTextView: UITextView!
    @IBOutlet weak var progressView: UIProgressView!
    @IBOutlet weak var processingLabel: UILabel!
    
    var currentBook: BookRealm? = nil
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.memoTextView.delegate = self
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.titleLabel.text = self.currentBook?.title
        self.bookImageView.kf.setImage(with: URL(string: self.currentBook?.image ?? ""))
        
        self.memoTextView.text = Constant.detailTextFieldPlaceHolder
        memoTextView.textColor = UIColor.lightGray
        
        self.progressView.progress = Float(Float(self.currentBook!.progress) / 100)
        self.processingLabel.text = Util.processingText(percent: self.progressView.progress)
        
        let book = self.realm.objects(BookRealm.self).filter("title = '\(currentBook!.title)'").first
        self.memoTextView.text = book?.memo
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        
        let book = self.realm.objects(BookRealm.self).filter("title = '\(currentBook!.title)'").first
        try! self.realm.write {
            book?.memo = self.memoTextView.text
        }
    }
    
    func textViewSetupView() {
        if memoTextView.text == Constant.detailTextFieldPlaceHolder {
            memoTextView.text = ""
            memoTextView.textColor = UIColor.label
        } else if memoTextView.text == "" {
            memoTextView.text = Constant.detailTextFieldPlaceHolder
            memoTextView.textColor = UIColor.lightGray
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
}
