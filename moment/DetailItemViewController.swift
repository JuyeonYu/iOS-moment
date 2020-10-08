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
    @IBOutlet weak var processingLabel: UILabel!
    @IBOutlet weak var slider: UISlider!
    @IBAction func didSliderMove(_ sender: Any) {
        let stepCount = 25
        let roundedCurrent = (slider.value/Float(stepCount)).rounded()
        let newValue = Int(roundedCurrent) * stepCount
        slider.setValue(Float(newValue), animated: true)
        self.processingLabel.text = Util.processingText(percent: slider.value)
    }
    
    var currentItemType: NaverSearchType = NaverSearchType.Book
    var currentBook: Book = Book()
    var currentMovie: Movie = Movie()
    
    weak var delegate: MainViewControllerDelegate?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.memoTextView.delegate = self
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        memoTextView.layer.cornerRadius = 0.05 * memoTextView.bounds.size.width
        
        navigationItem.rightBarButtonItem = UIBarButtonItem(image: UIImage(systemName: "trash.fill"), style: .plain, target: self, action: #selector(deleteItem))
        navigationItem.rightBarButtonItem?.tintColor = UIColor.systemRed
        
        switch currentItemType {
        case .Book:
            titleLabel.text = currentBook.title
            bookImageView.kf.setImage(with: URL(string: currentBook.image))
            memoTextView.text = currentBook.memo == "" ? Constant.detailTextFieldPlaceHolder : currentBook.memo
            self.slider.value = currentBook.progress!
        case .Movie:
            titleLabel.text = self.currentMovie.title
            bookImageView.kf.setImage(with: URL(string: currentMovie.image))
            memoTextView.text = currentMovie.memo == "" ? Constant.detailTextFieldPlaceHolder : currentMovie.memo
            self.slider.value = currentMovie.progress!
        }
        self.processingLabel.text = Util.processingText(percent: self.slider.value)
        memoTextView.textColor = memoTextView.text == "" || memoTextView.text == Constant.detailTextFieldPlaceHolder ? UIColor.systemGray3 : UIColor.label
    }
    
    @objc func deleteItem() {
        let alert = UIAlertController(title: NSLocalizedString("delete", comment: ""),
                                      message: NSLocalizedString("can't recover", comment: ""),
                                      preferredStyle: .alert)
        let cancel = UIAlertAction(title: NSLocalizedString("cancel", comment: ""), style: .cancel)
        let ok = UIAlertAction(title: NSLocalizedString("delete", comment: ""), style: .destructive) { (_) in
            switch self.currentItemType {
            case .Book:
                let book = self.realm.objects(BookRealm.self).filter("title = '\(self.currentBook.title)'").first!
                try! self.realm.write {
                    self.realm.delete(book)
                }
            case .Movie:
                let movie = self.realm.objects(MovieRealm.self).filter("title = '\(self.currentMovie.title)'").first!
                try! self.realm.write {
                    self.realm.delete(movie)
                }
            }
            
            self.delegate?.needToRefresh()
            self.navigationController?.popViewController(animated: false)
        }
        alert.addAction(cancel)
        alert.addAction(ok)
        self.present(alert, animated: true)
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        
        switch currentItemType {
        case .Book:
            let book = self.realm.objects(BookRealm.self).filter("title = '\(currentBook.title)'").first
            try! self.realm.write {
                book?.memo = self.memoTextView.text
                book?.progress = self.slider.value
            }
        case .Movie:
            let movie = self.realm.objects(MovieRealm.self).filter("title = '\(currentMovie.title)'").first
            try! self.realm.write {
                movie?.memo = self.memoTextView.text
                movie?.progress = self.slider.value
            }
        }
        self.delegate?.needToRefresh()
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
        Util.setMemoTextView(textView: memoTextView)
    }
    
    func textViewDidEndEditing(_ textView: UITextView) {
        if textView.text == "" {
            Util.setMemoTextView(textView: memoTextView)
        }
    }
}
