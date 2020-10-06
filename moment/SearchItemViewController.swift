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
    func saveData(value: Float, type: NaverSearchType)
}

class SearchItemViewController: UIViewController {
    
    lazy var realm: Realm = {
        return try! Realm()
    }()

    @IBOutlet weak var searchBar: UISearchBar!
    @IBOutlet weak var tableView: UITableView!

    var books: [Book] = [] {
        didSet {
            self.tableView.reloadData()
        }
    }
    
        var movies: [Movie] = [] {
            didSet {
                self.tableView.reloadData()
            }
        }
    
    var selectedBook: Book? = nil
    var selectedMovie: Movie? = nil
    
    weak var delegate: MainViewControllerDelegate?
    
    override func viewDidLoad() {
        super.viewDidLoad()

        tableView.delegate = self
        tableView.dataSource = self
        searchBar.delegate = self
                
        tableView.register(UINib(nibName: "SearchItemTableViewCell", bundle: nil), forCellReuseIdentifier: "SearchItemTableViewCell")
        
        searchBar.scopeButtonTitles?[0] = NSLocalizedString("book/comic", comment: "")
        searchBar.scopeButtonTitles?[1] = NSLocalizedString("movie/drama", comment: "")
    }
}

extension SearchItemViewController: UISearchBarDelegate {
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        if searchText == "" {
            self.books.removeAll()
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
}

extension SearchItemViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let vc = self.storyboard?.instantiateViewController(withIdentifier: "SelectBookMarkViewController") as! SelectBookMarkViewController
        vc.delegate = self
        vc.selectedType = searchBar.selectedScopeButtonIndex == 0 ? .Book : .Movie
        self.present(vc, animated: true, completion: nil)
        
        if searchBar.selectedScopeButtonIndex == 0 {
            selectedBook = self.books[indexPath.row]
        } else {
            selectedMovie = self.movies[indexPath.row]
        }
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
    }
}

extension SearchItemViewController: SearchItemViewControllerDelegate {
    func saveData(value: Float, type: NaverSearchType) {
        switch type {
        case .Book:
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
