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
    @IBOutlet weak var headerLabel: UILabel!
    lazy var realm: Realm = {
        return try! Realm()
    }()
    @IBAction func didTapAddButton(_ sender: Any) {
        let vc = self.storyboard?.instantiateViewController(withIdentifier: "SearchItemViewController") as! SearchItemViewController
        vc.delegate = self
        self.present(vc, animated: true, completion: nil)
    }
    
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
}

extension MainViewController: UICollectionViewDelegate {
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {
        return UIEdgeInsets(top: 0, left: 15, bottom: 0, right: 15)
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let selectedBook = Array(realm.objects(BookRealm.self))[indexPath.row - 1]
        let vc = self.storyboard?.instantiateViewController(withIdentifier: "DetailItemViewController") as! DetailItemViewController
        vc.currentBook = selectedBook
        self.navigationController?.pushViewController(vc, animated: true)
    }
    
    func collectionView(_ collectionView: UICollectionView,
                        layout collectionViewLayout: UICollectionViewLayout,
                        referenceSizeForHeaderInSection section: Int) -> CGSize {
        return CGSize(width: collectionView.frame.width, height: 50)
    }
}

extension MainViewController: UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView,
                        numberOfItemsInSection section: Int) -> Int {
            return realm.objects(BookRealm.self).count
    }
    
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return NaverSearchType.allCases.count * 2
    }
    
    func collectionView(_ collectionView: UICollectionView,
                        cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "ItemCollectionViewCell",
                                                      for: indexPath) as! ItemCollectionViewCell
            let books = Array(realm.objects(BookRealm.self))
            if let url = URL(string: books[indexPath.row].image) {
                cell.itemImageView.kf.setImage(with: url)
            } else {
                cell.itemImageView.image = UIImage(named: "test3")
            }
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView,
                        viewForSupplementaryElementOfKind kind: String,
                        at indexPath: IndexPath) -> UICollectionReusableView {
        let headerCell = collectionView.dequeueReusableSupplementaryView(ofKind: UICollectionView.elementKindSectionHeader,
                                                                     withReuseIdentifier: "HeaderCollectionReusableView",
                                                                     for: indexPath) as! HeaderCollectionReusableView
        if indexPath.section == 0 {
            headerCell.headerLabel.text = "읽고 있어요"
        } else if indexPath.section == 1 {
            headerCell.headerLabel.text = "보고 있어요"
        } else if indexPath.section == 2 {
            headerCell.headerLabel.text = "다 읽었어요"
        } else {
            headerCell.headerLabel.text = "다 봤어요"
        }
        return headerCell
    }
}

extension MainViewController: UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: self.view.bounds.width / 5, height: self.view.bounds.height / 6)
    }
}

extension MainViewController: MainViewControllerDelegate {
    func adddData() {
        self.collectionView.reloadData()
    }
}
