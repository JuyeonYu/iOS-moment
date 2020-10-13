//
//  SearchViewController.swift
//  moment
//
//  Created by Juyeon on 2020/10/10.
//  Copyright © 2020 주연  유. All rights reserved.
//

import UIKit
import RealmSwift

class SearchViewController: UIViewController {
    lazy var realm: Realm = {
        return try! Realm()
    }()
    
    @IBOutlet weak var textField: UITextField!
    
    @IBOutlet weak var tableView: UITableView!

    var keywords: [Keyword] = [] {
        didSet {
            tableView.reloadData()
        }
    }
    
    weak var delegate: SearchItemViewControllerDelegate?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.delegate = self
        tableView.dataSource = self
        textField.delegate = self
        textField.becomeFirstResponder()
        
        tableView.register(UINib(nibName: "SearchHistoryTableViewCell", bundle: nil),
                           forCellReuseIdentifier: "SearchHistoryTableViewCell")
        textField.placeholder = "검색하실 작품의 정보를 입력하세요"
        textField.borderStyle = .none
        textField.addLeftPadding()
        initdata()
    }
    
    func initdata() {
        var tempKeyword: [Keyword] = []
        for keywordRealm in Array(realm.objects(KeywordRealm.self)).reversed() {
            let keyword = Keyword(keywordRealm: keywordRealm)
            tempKeyword.append(keyword)
        }
        keywords = tempKeyword
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        guard let keyword = textField.text else {
            return false
        }
        
        guard keyword != "" else {
            let alert = UIAlertController(title: NSLocalizedString("warnning", comment: ""),
                                          message: NSLocalizedString("can't search empty", comment: ""),
                                          preferredStyle: .alert)
            let ok = UIAlertAction(title: NSLocalizedString("ok", comment: ""),
                                   style: .default)
            alert.addAction(ok)
            self.present(alert, animated: true)
            return false
        }
        
        self.dismiss(animated: false) {
            self.delegate?.searchKeyword(keyword: keyword)
            self.saveKeyword(keyword: keyword)
        }
        return true
    }
    
    func saveKeyword(keyword: String?) {
        guard let keyword = keyword else { return }
        
        if Array(realm.objects(KeywordRealm.self)).count == 20 {
            try! self.realm.write {
                self.realm.delete(self.realm.objects(KeywordRealm.self).first!)
            }
        }
        
        if let duplicateKeywordRealm = self.realm.objects(KeywordRealm.self).filter("title = '\(keyword)'").first {
            try! self.realm.write {
                duplicateKeywordRealm.date = Date()
            }
        } else {
            let keywordRealm = KeywordRealm()
            keywordRealm.title = keyword
            keywordRealm.date = Date()
            try! self.realm.write {
                self.realm.add(keywordRealm)
            }
        }
    }
}

extension SearchViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 50
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let keyword = keywords[indexPath.row].title
        self.dismiss(animated: false) {
            self.delegate?.searchKeyword(keyword: keyword)
            self.saveKeyword(keyword: keyword)
        }
    }
}

extension SearchViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return keywords.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "SearchHistoryTableViewCell",
                                                 for: indexPath) as! SearchHistoryTableViewCell
        let keyword = keywords[indexPath.row]
        cell.searchKeyword.text = keyword.title
        cell.searchDate.text = "\(keyword.date.month).\(keyword.date.day)"
        cell.delegate = self
        cell.indexPath = indexPath
        return cell
    }
}

extension SearchViewController: SearchHistoryTableViewCellDelegate {
    func didTouchDeleteButton(indexPath: IndexPath) {
        let keyword = Array(realm.objects(KeywordRealm.self))[indexPath.row]
        try! self.realm.write {
            self.realm.delete(keyword)
            self.initdata()
        }
    }
}
