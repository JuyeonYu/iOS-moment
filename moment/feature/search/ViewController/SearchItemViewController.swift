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
    func saveData(progress: Float, memo: String?, type: NaverSearchType)
}

class SearchItemViewController: UIViewController {
    
    @IBOutlet weak var manualInputLabel: UILabel!
    @IBOutlet weak var manualInputButton: UIButton!
    @IBAction func didTapManualInputButton(_ sender: Any) {
        print("didTapManualInputButton")
    }
    lazy var realm: Realm = {
        return try! Realm()
    }()

    @IBOutlet weak var searchBar: UISearchBar!
    @IBOutlet weak var searchResultTableView: UITableView!
    @IBOutlet weak var searchHistoryTableView: UITableView!
    
    var books: [Book] = [] {
        didSet {
            self.searchResultTableView.reloadData()
        }
    }
    
    var movies: [Movie] = [] {
        didSet {
            self.searchResultTableView.reloadData()
        }
    }
    
    var keywords: [Keyword] = [] {
        didSet {
            self.searchHistoryTableView.reloadData()
        }
    }
    
    var selectedBook: Book? = nil
    var selectedMovie: Movie? = nil
    
    weak var delegate: MainViewControllerDelegate?
    
    override func viewDidLoad() {
        super.viewDidLoad()

        searchResultTableView.delegate = self
        searchResultTableView.dataSource = self
        searchHistoryTableView.delegate = self
        searchHistoryTableView.dataSource = self
        searchBar.delegate = self
        
        searchResultTableView.isHidden = false
        searchHistoryTableView.isHidden = true
                
        searchResultTableView.register(UINib(nibName: "SearchItemTableViewCell", bundle: nil),
                                       forCellReuseIdentifier: "SearchItemTableViewCell")
        
        searchHistoryTableView.register(UINib(nibName: "SearchHistoryTableViewCell", bundle: nil),
                           forCellReuseIdentifier: "SearchHistoryTableViewCell")
        
        searchBar.scopeButtonTitles?[0] = NSLocalizedString("book/comics", comment: "")
        searchBar.scopeButtonTitles?[1] = NSLocalizedString("movie/drama", comment: "")
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        manualInputLabel.text = NSLocalizedString("no what you want?", comment: "")
        manualInputButton.setTitle(NSLocalizedString("input manually",
                                                     comment: ""), for: .normal)
        self.initSearchHistory()
    }
    
    func initSearchHistory() {
        var tempKeyword: [Keyword] = []
        for keywordRealm in Array(realm.objects(KeywordRealm.self)).reversed() {
            let keyword = Keyword(keywordRealm: keywordRealm)
            tempKeyword.append(keyword)
        }
        keywords = tempKeyword
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
        self.initSearchHistory()
    }
}

extension SearchItemViewController: UISearchBarDelegate {
    func searchBarTextDidBeginEditing(_ searchBar: UISearchBar) {
        self.searchResultTableView.isHidden = true
        self.searchHistoryTableView.isHidden = false
        
        self.initSearchHistory()
    }
    
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        if searchText == "" {
            self.books.removeAll()
        }
    }
    
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        guard let keyword = searchBar.text else { return }
        self.saveKeyword(keyword: keyword)
        if searchBar.selectedScopeButtonIndex == 0 {
            requestNaverBookSearchAPI(keyword, start: 1)
        } else {
            requestNaverMovieSearchAPI(keyword, start: 1)
        }
        
        self.searchResultTableView.isHidden = false
        self.searchHistoryTableView.isHidden = true
        searchBar.endEditing(true)
    }
    
    func searchBarCancelButtonClicked(_ searchBar: UISearchBar) {
        searchBar.resignFirstResponder()
    }
    
    func searchBar(_ searchBar: UISearchBar, selectedScopeButtonIndexDidChange selectedScope: Int) {
        print("selected index: \(selectedScope)")
        searchBar.text = ""
        if selectedScope == 0 {
            books.removeAll()
        } else {
            movies.removeAll()
        }
    }
    
    fileprivate func requestNaverBookSearchAPI(_ keyword: String, start: Int) {
        NetworkManager.sharedInstance.requestNaverBookList(keyword: keyword, start: start) { (result) in
            guard let naverBooks = result as? NaverBook else {
                return
            }
            
            var tempBooks: [Book] = []
            for naverBook in naverBooks.items {
                let book: Book = Book(naverBook: naverBook)
                tempBooks.append(book)
                
                if self.books.count + tempBooks.count == naverBooks.total {
                    break
                }
            }
            self.books = self.books + tempBooks
        }
    }
    
    fileprivate func requestNaverMovieSearchAPI(_ keyword: String, start: Int) {
        NetworkManager.sharedInstance.requestNaverMovieList(keyword: keyword, start: start) { (result) in
            guard let naverMovies = result as? NaverMovie else {
                return
            }
            
            var tempMovies: [Movie] = []
            for naverMovie in naverMovies.items {
                let movie: Movie = Movie(naverMovie: naverMovie)
                tempMovies.append(movie)
                
                if self.movies.count + tempMovies.count == naverMovies.total {
                    break
                }
            }
            self.movies = self.movies + tempMovies
        }
    }
    
    func searchKeyword(keyword: String) {
        books.removeAll()
        movies.removeAll()
        self.searchBar.text = keyword
        searchBarSearchButtonClicked(searchBar)
    }
}

extension SearchItemViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        switch tableView {
        case searchResultTableView:
            if searchBar.selectedScopeButtonIndex == 0 {
                selectedBook = self.books[indexPath.row]
                guard self.realm.objects(BookRealm.self).filter("isbn = '\(selectedBook!.isbn)'").first == nil else {
                    let alert = UIAlertController(title: NSLocalizedString("duplicate", comment: ""),
                                                  message: NSLocalizedString("can't save duplicate item", comment: ""),
                                                  preferredStyle: .alert)
                    let ok = UIAlertAction(title: NSLocalizedString("ok", comment: ""),
                                           style: .default)
                    alert.addAction(ok)
                    self.present(alert, animated: true)
                    return
                }
            } else {
                selectedMovie = self.movies[indexPath.row]
                guard self.realm.objects(MovieRealm.self).filter("link = '\(selectedMovie!.link)'").first == nil else {
                    let alert = UIAlertController(title: NSLocalizedString("duplicate", comment: ""),
                                                  message: NSLocalizedString("can't save duplicate item", comment: ""),
                                                  preferredStyle: .alert)
                    let ok = UIAlertAction(title: NSLocalizedString("ok", comment: ""),
                                           style: .default)
                    alert.addAction(ok)
                    self.present(alert, animated: true)
                    return
                }
            }
            
            let vc = self.storyboard?.instantiateViewController(withIdentifier: "SelectBookMarkViewController") as! SelectBookMarkViewController
            vc.delegate = self
            vc.selectedType = searchBar.selectedScopeButtonIndex == 0 ? .Book : .Movie
            self.present(vc, animated: true, completion: nil)
            
        case searchHistoryTableView:
            let keyword = keywords[indexPath.row].title
            self.searchKeyword(keyword: keyword)
        default:
            break
        }
    }
    
//    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
//        switch tableView {
//        case searchResultTableView:
//            return UIView()
//        case searchHistoryTableView:
//            let searchHeaderView = SearchHeaderView.init()
//            return searchHeaderView
//        default:
//            return UIView()
//        }
//    }
    
//    func tableView(_ tableView: UITableView, titleForFooterInSection section: Int) -> String? {
//        switch tableView {
//        case searchResultTableView:
//            return ""
//        case searchHistoryTableView:
//            return NSLocalizedString("show 20 keywords", comment: "")
//        default:
//            return ""
//        }
//    }
    
    func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        switch tableView {
        case searchResultTableView:
            return NSLocalizedString("search result", comment: "")
        case searchHistoryTableView:
            return NSLocalizedString("show 20 keywords", comment: "")
        default:
            return ""
        }
    }
}

extension SearchItemViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        switch tableView {
        case searchResultTableView:
            if searchBar.selectedScopeButtonIndex == 0 {
                return books.count
            } else {
                return movies.count
            }
        case searchHistoryTableView:
            return keywords.count
        default:
            return 0
        }
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        switch tableView {
        case searchResultTableView:
            let cell = tableView.dequeueReusableCell(withIdentifier: "SearchItemTableViewCell",
                                                     for: indexPath) as! SearchItemTableViewCell
            if searchBar.selectedScopeButtonIndex == 0 {
                cell.titleLabel.text = self.books[indexPath.row].title
                cell.descriptionLabel.text = self.books[indexPath.row].desc
                
                if let imageURL = URL(string: self.books[indexPath.row].imageURL) {
                    cell.bookImageView.kf.setImage(with:imageURL)
                } else {
                    cell.bookImageView.image = UIImage(named: "questionmark.square.fill")
                }
                
                if indexPath.row == self.books.count - 1 {
                    requestNaverBookSearchAPI(self.searchBar.text!, start: (indexPath.row) + 2)
                }
            } else {
                cell.titleLabel.text = self.movies[indexPath.row].title
                cell.descriptionLabel.text = self.movies[indexPath.row].subtitle
                
                if let imageURL = URL(string: self.movies[indexPath.row].image) {
                    cell.bookImageView.kf.setImage(with:imageURL)
                } else {
                    cell.bookImageView.image = UIImage(named: "questionmark.square.fill")
                }
                
                if indexPath.row == self.books.count - 1 {
                    requestNaverMovieSearchAPI(self.searchBar.text!, start: (indexPath.row) + 2)
                }
            }
            return cell
            
        case searchHistoryTableView:
            let cell = tableView.dequeueReusableCell(withIdentifier: "SearchHistoryTableViewCell",
                                                     for: indexPath) as! SearchHistoryTableViewCell
            let keyword = keywords[indexPath.row]
            cell.searchKeyword.text = keyword.title
            cell.searchDate.text = "\(keyword.date.month).\(keyword.date.day)"
            cell.indexPath = indexPath
            return cell
        default:
            return UITableViewCell()
        }
    }
}

extension SearchItemViewController: SearchItemViewControllerDelegate {
    func saveData(progress: Float, memo: String?, type: NaverSearchType) {
        switch type {
        case .Book:
            let bookRealm = BookRealm()
            guard let book = selectedBook else { return }
            bookRealm.title = book.title
            bookRealm.link = book.link
            bookRealm.image = book.imageURL
            bookRealm.author = book.author
            bookRealm.price = book.price
            bookRealm.discount = book.discount
            bookRealm.publisher = book.publisher
            bookRealm.pubdate = book.pubdate
            bookRealm.isbn = book.isbn
            bookRealm.desc = book.desc
            bookRealm.progress = progress
            bookRealm.memo = memo ?? ""

            try! self.realm.write {
                self.realm.add(bookRealm)
            }
        case .Movie:
            let movieRealm = MovieRealm()
            guard let movie = selectedMovie else { return }
            movieRealm.title = movie.title
            movieRealm.link = movie.link
            movieRealm.image = movie.image
            movieRealm.subtitle = movie.subtitle
            movieRealm.pubdate = movie.pubdate
            movieRealm.progress = progress
            movieRealm.memo = memo ?? ""

            try! self.realm.write {
                self.realm.add(movieRealm)
            }
        }

        self.dismiss(animated: false) {
            self.delegate?.needToRefresh()
        }
    }
    
    func saveData(value: Float, type: NaverSearchType) {
        switch type {
        case .Book:
            let bookRealm = BookRealm()
            guard let book = selectedBook else { return }
            bookRealm.title = book.title
            bookRealm.link = book.link
            bookRealm.image = book.imageURL
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
        case .Movie:
            let movieRealm = MovieRealm()
            guard let movie = selectedMovie else { return }
            movieRealm.title = movie.title
            movieRealm.link = movie.link
            movieRealm.image = movie.image
            movieRealm.subtitle = movie.subtitle
            movieRealm.pubdate = movie.pubdate
            movieRealm.progress = value

            try! self.realm.write {
                self.realm.add(movieRealm)
            }
        }

        self.dismiss(animated: false) {
            self.delegate?.needToRefresh()
        }
    }
}
