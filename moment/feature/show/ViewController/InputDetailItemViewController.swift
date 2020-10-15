//
//  InputDetailItemViewController.swift
//  moment
//
//  Created by Juyeon on 2020/10/15.
//  Copyright © 2020 주연  유. All rights reserved.
//

import UIKit
import RealmSwift

class InputDetailItemViewController: UIViewController, UINavigationControllerDelegate {
    lazy var realm: Realm = {
        return try! Realm()
    }()
    
    @IBOutlet weak var imageView: UIImageView!
    @IBOutlet weak var slider: UISlider!
    @IBOutlet weak var titleTextField: UITextField!
    @IBOutlet weak var processingLabel: UILabel!
    @IBOutlet weak var memoTextView: UITextView!
    @IBOutlet weak var saveButton: UIButton!
    @IBAction func didTabSaveButton(_ sender: Any) {
        self.presentingViewController?
            .presentingViewController?
            .presentingViewController?
            .dismiss(animated: true) {
            // save data
            self.delegate?.adddData()
        }
    }
    
    weak var delegate: MainViewControllerDelegate?
    
    @IBAction func didSliderMove(_ sender: Any) {
        let stepCount = 25
        let roundedCurrent = (slider.value/Float(stepCount)).rounded()
        let newValue = Int(roundedCurrent) * stepCount
        slider.setValue(Float(newValue), animated: true)
        self.processingLabel.text = Util.processingText(percent: slider.value)
    }
    
    let picker = UIImagePickerController()

    override func viewDidLoad() {
        super.viewDidLoad()
        
        let tapGesture = UITapGestureRecognizer(target: self,
                                                action: #selector(touchToPickPhoto))
        imageView.addGestureRecognizer(tapGesture)
        imageView.isUserInteractionEnabled = true
        
        picker.delegate = self
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        memoTextView.layer.cornerRadius = 0.05 * memoTextView.bounds.size.width
        saveButton.setTitle(NSLocalizedString("save", comment: "save item"), for: .normal)
        saveButton.layer.cornerRadius = 0.5 * saveButton.bounds.size.height
    }
    
    @objc func touchToPickPhoto() {
        let actionSheet = UIAlertController(title: NSLocalizedString("input image", comment: ""),
                                            message: nil,
                                            preferredStyle: .actionSheet)
        actionSheet.addAction(UIAlertAction(title: NSLocalizedString("camera", comment: ""),
                                            style: .default,
                                            handler: { (result) in
            self.openCamera()
        }))
        actionSheet.addAction(UIAlertAction(title: NSLocalizedString("album", comment: ""),
                                            style: .default,
                                            handler: { (result) in
            self.openLibrary()
        }))
        actionSheet.addAction(UIAlertAction(title: NSLocalizedString("Cancel", comment: ""),
                                            style: .cancel,
                                            handler: nil))

        self.present(actionSheet, animated: true, completion: nil)
    }
    
    func openCamera() {
        picker.sourceType = .camera
        present(picker, animated: false, completion: nil)
    }
    
    func openLibrary() {
        picker.sourceType = .photoLibrary
        present(picker, animated: false, completion: nil)
    }
}

extension InputDetailItemViewController: UIImagePickerControllerDelegate {
    func imagePickerController(_ picker: UIImagePickerController,
                               didFinishPickingMediaWithInfo
                                info: [UIImagePickerController.InfoKey : Any]) {
            picker.dismiss(animated: true, completion: nil)
            guard let selectedImage = info[.originalImage] as? UIImage else {
                print("Image not found!")
                return
            }
            imageView.image = selectedImage
        }
}
