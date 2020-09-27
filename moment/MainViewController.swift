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
}

class MainViewController: UIViewController {
    lazy var realm: Realm = {
        return try! Realm()
    }()
    
    @IBOutlet weak var collectionView: UICollectionView!
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.collectionView.delegate = self
        self.collectionView.dataSource = self
        self.collectionView.register(UINib(nibName: "ItemCollectionViewCell", bundle: nil), forCellWithReuseIdentifier: "ItemCollectionViewCell")
    }
}

extension MainViewController: UICollectionViewDelegate {
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {
        return UIEdgeInsets(top: 0, left: 15, bottom: 0, right: 15)
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        
        if indexPath.row == 0 {
            let vc = self.storyboard?.instantiateViewController(withIdentifier: "SearchItemViewController") as! SearchItemViewController
            vc.delegate = self
            self.present(vc, animated: true, completion: nil)
        } else {
            let selectedBook = Array(realm.objects(BookRealm.self))[indexPath.row - 1]
            let vc = self.storyboard?.instantiateViewController(withIdentifier: "DetailItemViewController") as! DetailItemViewController
            vc.currentBook = selectedBook
            self.navigationController?.pushViewController(vc, animated: true)
        }
    }
}

extension MainViewController: UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        if realm.objects(BookRealm.self).count == 0 {
            return 1
        } else {
            return realm.objects(BookRealm.self).count + 1
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "ItemCollectionViewCell", for: indexPath) as! ItemCollectionViewCell
        if indexPath.row == 0 {
            cell.itemImageView.image = UIImage(systemName: "plus")
        } else {
            let books = Array(realm.objects(BookRealm.self))
            if let url = URL(string: books[indexPath.row - 1].image) {
                cell.itemImageView.kf.setImage(with: url)
            } else {
                cell.itemImageView.image = UIImage(named: "test3")
            }
        }
        return cell
    }
}

extension MainViewController: UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: self.view.bounds.width / 5, height: self.view.bounds.height / 5)
    }
}

extension MainViewController: MainViewControllerDelegate {
    func adddData() {
        self.collectionView.reloadData()
    }
}
