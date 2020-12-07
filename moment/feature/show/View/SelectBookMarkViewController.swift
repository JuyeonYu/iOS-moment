//
//  SelectBookMarkViewController.swift
//  moment
//
//  Created by Juyeon on 2020/09/28.
//  Copyright © 2020 주연  유. All rights reserved.
//

import UIKit
import GoogleMobileAds

class SelectBookMarkViewController: UIViewController {
    var selectedType: NaverSearchType = .Book
    @IBOutlet weak var processingLabel: UILabel!
    @IBOutlet weak var slider: UISlider!
    @IBOutlet weak var memoTextView: UITextView!
    @IBAction func didSliderMove(_ sender: Any) {
        self.guideLabel.isHidden = true
        let stepCount = 25
        let roundedCurrent = (slider.value/Float(stepCount)).rounded()
        let newValue = Int(roundedCurrent) * stepCount
        slider.setValue(Float(newValue), animated: true)
        self.processingLabel.text = Util.processingText(percent: slider.value)
    }
    @IBOutlet weak var saveButton: UIButton!
    weak var delegate: SearchItemViewControllerDelegate?
    
    @IBOutlet weak var bannerView: GADBannerView!
    @IBAction func didTapSaveButton(_ sender: Any) {
        self.dismiss(animated: false) {
            self.delegate?.saveData(progress: self.slider.value,
                                    memo: self.memoTextView.text,
                                    type: self.selectedType)
        }
    }
    
    @IBOutlet weak var guideLabel: UILabel!
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.memoTextView.delegate = self
        self.setupBannerView()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        guideLabel.text = NSLocalizedString("proceeding", comment: "")
        processingLabel.text = NSLocalizedString("begin", comment: "")
        saveButton.setTitle(NSLocalizedString("save", comment: "save item"), for: .normal)
        saveButton.layer.cornerRadius = 0.5 * saveButton.bounds.size.height
        memoTextView.layer.cornerRadius = 0.05 * memoTextView.bounds.size.width
    }
    
    private func setupBannerView() {
        bannerView.adUnitID = Constant.googleADModID
        bannerView.rootViewController = self
        bannerView.load(GADRequest())
        bannerView.delegate = self
    }
}

extension SelectBookMarkViewController: UITextViewDelegate {
    func textViewDidBeginEditing(_ textView: UITextView) {
        Util.setMemoTextView(textView: memoTextView)
    }
    
    func textViewDidEndEditing(_ textView: UITextView) {
        if textView.text == "" {
            Util.setMemoTextView(textView: memoTextView)
        }
    }
}

extension SelectBookMarkViewController: GADBannerViewDelegate {
    /// Tells the delegate an ad request loaded an ad.
func adViewDidReceiveAd(_ bannerView: GADBannerView) { print("adViewDidReceiveAd") }
/// Tells the delegate an ad request failed.
func adView(_ bannerView: GADBannerView, didFailToReceiveAdWithError error: GADRequestError) { print("adView:didFailToReceiveAdWithError: \(error.localizedDescription)") }
/// Tells the delegate that a full-screen view will be presented in response /// to the user clicking on an ad.
func adViewWillPresentScreen(_ bannerView: GADBannerView) { print("adViewWillPresentScreen") }
/// Tells the delegate that the full-screen view will be dismissed.
func adViewWillDismissScreen(_ bannerView: GADBannerView) { print("adViewWillDismissScreen") }
/// Tells the delegate that the full-screen view has been dismissed.
func adViewDidDismissScreen(_ bannerView: GADBannerView) { print("adViewDidDismissScreen") }
/// Tells the delegate that a user click will open another app (such as /// the App Store), backgrounding the current app.
func adViewWillLeaveApplication(_ bannerView: GADBannerView) { print("adViewWillLeaveApplication") } }

