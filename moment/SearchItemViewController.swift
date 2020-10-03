//
//  SearchItemViewController.swift
//  moment
//
//  Created by 주연  유 on 2020/09/24.
//  Copyright © 2020 주연  유. All rights reserved.
//

import UIKit
import Kingfisher
import RealmSwift

protocol SearchItemViewControllerDelegate: class {
    func saveData(value: Float)
}

class SearchItemViewController: UIViewController {
    
    lazy var realm: Realm = {
        return try! Realm()
    }()

    @IBOutlet weak var searchBar: UISearchBar!
    @IBOutlet weak var tableView: UITableView!

    var books: [Book] = [] {
        didSet {
        }
    }
    
        var movies: [Movie] = [] {
            didSet {
            }
        }
    
    var totalItemNumber: Int = 0
    var showedItemNumber: Int = 0
    var selectedBook: Book? = nil
    var selectedMovie: Movie? = nil
    
    weak var delegate: MainViewControllerDelegate?
    
    override func viewDidLoad() {
        super.viewDidLoad()

        tableView.delegate = self
        tableView.dataSource = self
        searchBar.delegate = self
                
        tableView.register(UINib(nibName: "SearchItemTableViewCell", bundle: nil), forCellReuseIdentifier: "SearchItemTableViewCell")
        
        searchBar.scopeButtonTitles?[0] = "책/만화"
        searchBar.scopeButtonTitles?[1] = "영화/드라마"
    }
}

extension SearchItemViewController: UISearchBarDelegate {
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        if searchText == "" {
            self.books.removeAll()
            self.tableView.reloadData()
        }
    }
    
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        guard let keyword = searchBar.text else { return }
        if searchBar.selectedScopeButtonIndex == 0 {
            requestNaverBookSearchAPI(keyword, start: 1)
        } else {
            requestNaverMovieSearchAPI(keyword, start: 1)
        }
        
    }
    
    func searchBarCancelButtonClicked(_ searchBar: UISearchBar) {
        searchBar.resignFirstResponder()
    }
    
    fileprivate func requestNaverBookSearchAPI(_ keyword: String, start: Int) {
        NetworkManager.sharedInstance.requestNaverBookList(keyword: keyword, start: start) { (result) in
            guard let naverBooks = result as? NaverBook else {
                return
            }
            
            self.totalItemNumber = naverBooks.total
            
            for naverBook in naverBooks.items {
                if let encoded  = naverBook.image.addingPercentEncoding(withAllowedCharacters: .urlFragmentAllowed),
                   let myURL = URL(string: encoded) {
                    print(myURL)
                }
                
                let book: Book = Book(naverBook: naverBook)
                self.books.append(book)
            }
            self.showedItemNumber = self.books.count
            self.tableView.reloadData()
        }
    }
    
    fileprivate func requestNaverMovieSearchAPI(_ keyword: String, start: Int) {
        NetworkManager.sharedInstance.requestNaverMovieList(keyword: keyword, start: start) { (result) in
            guard let naverMovies = result as? NaverMovie else {
                return
            }
            
            self.totalItemNumber = naverMovies.total
            
            for naverMovie in naverMovies.items {
                if let encoded  = naverMovie.image.addingPercentEncoding(withAllowedCharacters: .urlFragmentAllowed),
                   let myURL = URL(string: encoded) {
                    print(myURL)
                }
                
                let movie: Movie = Movie(naverMovie: naverMovie)
                self.movies.append(movie)
            }
            self.showedItemNumber = self.books.count
            self.tableView.reloadData()
        }
    }
}

extension SearchItemViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let vc = self.storyboard?.instantiateViewController(withIdentifier: "SelectBookMarkViewController") as! SelectBookMarkViewController
        vc.delegate = self
        self.present(vc, animated: true, completion: nil)
        selectedBook = self.books[indexPath.row]
//        let alert = UIAlertController(title: "등록", message: nil, preferredStyle: .alert)
//
//        alert.addTextField { (tf) in
//            tf.placeholder = "(옵션)몇 권까지 봤나요?)"
//        }
//
//        alert.addTextField { (tf) in
//            tf.placeholder = "(옵션)몇 페이지까지 봤나요?)"
//        }
//
//        let cancel = UIAlertAction(title: "취소", style: .cancel)
//        let ok = UIAlertAction(title: "추가", style: .default) { (_) in
//            let bookRealm = BookRealm()
//            bookRealm.title = selectedBook.title
//            bookRealm.link = selectedBook.link
//            bookRealm.image = selectedBook.image
//            bookRealm.author = selectedBook.author
//            bookRealm.price = selectedBook.price
//            bookRealm.discount = selectedBook.discount
//            bookRealm.publisher = selectedBook.publisher
//            bookRealm.pubdate = selectedBook.pubdate
//            bookRealm.isbn = selectedBook.isbn
//            bookRealm.desc = selectedBook.desc
//
//            try! self.realm.write {
//                self.realm.add(bookRealm)
//            }
//
//            self.dismiss(animated: true) {
//                self.delegate?.adddData()
//            }
//        }
//        alert.addAction(cancel)
//        alert.addAction(ok)
//        self.present(alert, animated: true)
    }
}

extension SearchItemViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if searchBar.selectedScopeButtonIndex == 0 {
            return books.count
        } else {
            return movies.count
        }
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "SearchItemTableViewCell", for: indexPath) as! SearchItemTableViewCell
        
        if searchBar.selectedScopeButtonIndex == 0 {
            cell.titleLabel.text = self.books[indexPath.row].title
            cell.descriptionLabel.text = self.books[indexPath.row].desc
            
            if let imageURL = URL(string: self.books[indexPath.row].image) {
                cell.bookImageView.kf.setImage(with:imageURL)
            } else {
                cell.bookImageView.image = UIImage(named: "test3")
            }
            
            if indexPath.row == self.books.count - 1
                && self.showedItemNumber < self.totalItemNumber {
                requestNaverBookSearchAPI(self.searchBar.text!, start: (indexPath.row / 19) + 1)
            }
        } else {
            cell.titleLabel.text = self.movies[indexPath.row].title
            cell.descriptionLabel.text = self.movies[indexPath.row].subtitle
            
            if let imageURL = URL(string: self.movies[indexPath.row].image) {
                cell.bookImageView.kf.setImage(with:imageURL)
            } else {
                cell.bookImageView.image = UIImage(named: "test3")
            }
            
            if indexPath.row == self.books.count - 1
                && self.showedItemNumber < self.totalItemNumber {
                requestNaverMovieSearchAPI(self.searchBar.text!, start: (indexPath.row / 19) + 1)
            }
        }
        return cell
    }
}

extension SearchItemViewController: SearchItemViewControllerDelegate {
    func saveData(value: Float) {
        let bookRealm = BookRealm()
        guard let book = selectedBook else { return }
        bookRealm.title = book.title
        bookRealm.link = book.link
        bookRealm.image = book.image
        bookRealm.author = book.author
        bookRealm.price = book.price
        bookRealm.discount = book.discount
        bookRealm.publisher = book.publisher
        bookRealm.pubdate = book.pubdate
        bookRealm.isbn = book.isbn
        bookRealm.desc = book.desc
        bookRealm.progress = value

        try! self.realm.write {
            self.realm.add(bookRealm)
        }

        self.dismiss(animated: false) {
            self.delegate?.adddData()
        }
    }
}
