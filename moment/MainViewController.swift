//
//  ViewController.swift
//  moment
//
//  Created by 주연  유 on 2020/09/24.
//  Copyright © 2020 주연  유. All rights reserved.
//

import UIKit
import RealmSwift
import Kingfisher

protocol MainViewControllerDelegate: class {
    func adddData()
    func needToRefresh()
}

class MainViewController: UIViewController {
    @IBOutlet weak var headerLabel: UILabel!
    lazy var realm: Realm = {
        return try! Realm()
    }()
    @IBAction func didTapAddButton(_ sender: Any) {
        let vc = self.storyboard?.instantiateViewController(withIdentifier: "SearchItemViewController") as! SearchItemViewController
        vc.delegate = self
        self.present(vc, animated: true, completion: nil)
    }
    
    var progressBooks: [Book] = []
    var progressMovies: [Movie] = []
    var completeBooks: [Book] = []
    var completeMovies: [Movie] = []
    
    @IBOutlet weak var collectionView: UICollectionView!
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.collectionView.delegate = self
        self.collectionView.dataSource = self
        self.collectionView.register(UINib(nibName: "ItemCollectionViewCell", bundle: nil),
                                     forCellWithReuseIdentifier: "ItemCollectionViewCell")
        self.collectionView.register(UINib(nibName: "HeaderCollectionReusableView", bundle: nil),
                                     forSupplementaryViewOfKind: UICollectionView.elementKindSectionHeader,
                                     withReuseIdentifier: "HeaderCollectionReusableView")
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        initdata()
    }
    
    func initdata() {
        progressBooks.removeAll()
        progressMovies.removeAll()
        completeBooks.removeAll()
        completeMovies.removeAll()
        
        let books = Array(realm.objects(BookRealm.self))
        
        for bookRealm in books {
            let book = Book(bookRealm: bookRealm)
            if book.progress == 100 {
                completeBooks.append(book)
            } else {
                progressBooks.append(book)
            }
        }
        
        let movies = Array(realm.objects(MovieRealm.self))
        
        for movieRealm in movies {
            let movie = Movie(movieRealm: movieRealm)
            if movie.progress == 100 {
                completeMovies.append(movie)
            } else {
                progressMovies.append(movie)
            }
        }
    }
}

extension MainViewController: UICollectionViewDelegate {
    func collectionView(_ collectionView: UICollectionView,
                        layout collectionViewLayout: UICollectionViewLayout,
                        insetForSectionAt section: Int) -> UIEdgeInsets {
        return UIEdgeInsets(top: 0, left: 15, bottom: 0, right: 15)
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let showDataType: ShowDataType.RawValue = indexPath.section
        let vc = self.storyboard?.instantiateViewController(withIdentifier: "DetailItemViewController") as! DetailItemViewController
        vc.delegate = self
        var selectedBook: Book = Book()
        var selectedMovie: Movie = Movie()
        var selectedType: NaverSearchType = NaverSearchType.Book
        switch showDataType {
            case ShowDataType.ProgressBook.rawValue:
                selectedBook = progressBooks[indexPath.row]
                selectedType = .Book
            case ShowDataType.ProgressMovie.rawValue:
                selectedMovie = progressMovies[indexPath.row]
                selectedType = .Movie
            case ShowDataType.CompleteBook.rawValue:
                selectedBook = completeBooks[indexPath.row]
                selectedType = .Book
            case ShowDataType.CompleteMovie.rawValue:
                selectedMovie = completeMovies[indexPath.row]
                selectedType = .Movie
        default:
            break
        }
        vc.currentBook = selectedBook
        vc.currentMovie = selectedMovie
        vc.currentItemType = selectedType
        
        self.navigationController?.pushViewController(vc, animated: true)
    }
    
    func collectionView(_ collectionView: UICollectionView,
                        layout collectionViewLayout: UICollectionViewLayout,
                        referenceSizeForHeaderInSection section: Int) -> CGSize {
        let showDataType: ShowDataType.RawValue = section
        let noHeaderCGSize: CGSize = CGSize(width: collectionView.frame.width, height: 0)
        let headerCGSize: CGSize = CGSize(width: collectionView.frame.width, height: 50)
        
        switch showDataType {
            case ShowDataType.ProgressBook.rawValue:
                return progressBooks.count == 0 ? noHeaderCGSize : headerCGSize
            case ShowDataType.ProgressMovie.rawValue:
                return progressMovies.count == 0 ? noHeaderCGSize : headerCGSize
            case ShowDataType.CompleteBook.rawValue:
                return completeBooks.count == 0 ? noHeaderCGSize : headerCGSize
            case ShowDataType.CompleteMovie.rawValue:
                return completeMovies.count == 0 ? noHeaderCGSize : headerCGSize
        default:
            return headerCGSize
        }
    }
}

extension MainViewController: UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView,
                        numberOfItemsInSection section: Int) -> Int {
        let showDataType: ShowDataType.RawValue = section
        switch showDataType {
            case ShowDataType.ProgressBook.rawValue:
                return progressBooks.count
            case ShowDataType.ProgressMovie.rawValue:
                return progressMovies.count
            case ShowDataType.CompleteBook.rawValue:
                return completeBooks.count
            case ShowDataType.CompleteMovie.rawValue:
                return completeMovies.count
        default:
            return 0
        }
    }
    
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return ShowDataType.count
    }
    
    func collectionView(_ collectionView: UICollectionView,
                        cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "ItemCollectionViewCell",
                                                      for: indexPath) as! ItemCollectionViewCell
        let showDataType: ShowDataType.RawValue = indexPath.section
        
        switch showDataType {
            case ShowDataType.ProgressBook.rawValue:
                if let url = URL(string: progressBooks[indexPath.row].image) {
                    cell.itemImageView.kf.setImage(with: url)
                } else {
                    cell.itemImageView.image = UIImage(named: "test3")
                }
                return cell
            case ShowDataType.ProgressMovie.rawValue:
                if let url = URL(string: progressMovies[indexPath.row].image) {
                    cell.itemImageView.kf.setImage(with: url)
                } else {
                    cell.itemImageView.image = UIImage(named: "test3")
                }
                return cell
            case ShowDataType.CompleteBook.rawValue:
                if let url = URL(string: completeBooks[indexPath.row].image) {
                    cell.itemImageView.kf.setImage(with: url)
                } else {
                    cell.itemImageView.image = UIImage(named: "test3")
                }
                return cell
            case ShowDataType.CompleteMovie.rawValue:
                if let url = URL(string: completeMovies[indexPath.row].image) {
                    cell.itemImageView.kf.setImage(with: url)
                } else {
                    cell.itemImageView.image = UIImage(named: "test3")
                }
                return cell
            default:
                return cell
        }
    }
    
    func collectionView(_ collectionView: UICollectionView,
                        viewForSupplementaryElementOfKind kind: String,
                        at indexPath: IndexPath) -> UICollectionReusableView {
        let headerCell = collectionView.dequeueReusableSupplementaryView(ofKind: UICollectionView.elementKindSectionHeader,
                                                                     withReuseIdentifier: "HeaderCollectionReusableView",
                                                                     for: indexPath) as! HeaderCollectionReusableView
        let showDataType: ShowDataType.RawValue = indexPath.section
        
        switch showDataType {
        case ShowDataType.ProgressBook.rawValue:
                headerCell.headerLabel.text = "읽고 있어요"
                break
            case ShowDataType.ProgressMovie.rawValue:
                headerCell.headerLabel.text = "보고 있어요"
                break
            case ShowDataType.CompleteBook.rawValue:
                headerCell.headerLabel.text = "다 읽었어요"
                break
            case ShowDataType.CompleteMovie.rawValue:
                headerCell.headerLabel.text = "다 봤어요"
                break
        default:
            break
        }
        return headerCell
    }
}

extension MainViewController: UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView,
                        layout collectionViewLayout: UICollectionViewLayout,
                        sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: self.view.bounds.width / 5, height: self.view.bounds.height / 6)
    }
}

extension MainViewController: MainViewControllerDelegate {
    func needToRefresh() {
        initdata()
        self.collectionView.reloadData()
    }
    
//    fileprivate func initdata() {
//        progressBooks.removeAll()
//        progressMovies.removeAll()
//        completeBooks.removeAll()
//        completeMovies.removeAll()
//
//        let books = Array(realm.objects(BookRealm.self))
//
//        for bookRealm in books {
//            let book = Book(bookRealm: bookRealm)
//            if book.progress == 100 {
//                completeBooks.append(book)
//            } else {
//                progressBooks.append(book)
//            }
//        }
//
//        let movies = Array(realm.objects(MovieRealm.self))
//
//        for movieRealm in movies {
//            let movie = Movie(movieRealm: movieRealm)
//            if movie.progress == 100 {
//                completeMovies.append(movie)
//            } else {
//                progressMovies.append(movie)
//            }
//        }
//    }
    
    func adddData() {
        initdata()
        self.collectionView.reloadData()
    }
}
