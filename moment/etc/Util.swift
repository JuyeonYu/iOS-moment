//
//  Util.swift
//  moment
//
//  Created by Juyeon on 2020/09/27.
//  Copyright © 2020 주연  유. All rights reserved.
//

import Foundation
import Kingfisher

class Util {
    class func processingText (percent: Float) -> String{
        if percent == 0 {
            return NSLocalizedString("begin", comment: "")
        } else if percent == 25 {
            return NSLocalizedString("proceeding1", comment: "")
        } else if percent == 50 {
            return NSLocalizedString("proceeding2", comment: "")
        } else if percent == 75 {
            return NSLocalizedString("proceeding3", comment: "")
        } else {
            return NSLocalizedString("end", comment: "")
        }
    }
    
    class func setMemoTextView(textView: UITextView) {
        if textView.text == Constant.detailTextFieldPlaceHolder {
            textView.text = ""
            textView.textColor = UIColor.label
        } else if textView.text == "" {
            textView.text = Constant.detailTextFieldPlaceHolder
            textView.textColor = UIColor.lightGray
        }
    }
}

extension String {
    public var withoutHtml: String {
        guard let data = self.data(using: .utf8) else {
            return self
        }

        let options: [NSAttributedString.DocumentReadingOptionKey: Any] = [
            .documentType: NSAttributedString.DocumentType.html,
            .characterEncoding: String.Encoding.utf8.rawValue
        ]

        guard let attributedString = try? NSAttributedString(data: data, options: options, documentAttributes: nil) else {
            return self
        }

        return attributedString.string
    }
}

extension UIViewController : UITextFieldDelegate {
    func addToolBar(textField: UITextField){
        let toolBar = UIToolbar()
        toolBar.barStyle = UIBarStyle.default
        toolBar.isTranslucent = true
        toolBar.tintColor = UIColor(red: 76/255, green: 217/255, blue: 100/255, alpha: 1)
        let doneButton = UIBarButtonItem(title: "Done", style: UIBarButtonItem.Style.done, target: self, action: Selector(("donePressed")))
        let cancelButton = UIBarButtonItem(title: "Cancel", style: UIBarButtonItem.Style.plain, target: self, action: Selector(("cancelPressed")))
        let spaceButton = UIBarButtonItem(barButtonSystemItem: UIBarButtonItem.SystemItem.flexibleSpace, target: nil, action: nil)
        toolBar.setItems([cancelButton, spaceButton, doneButton], animated: false)
        toolBar.isUserInteractionEnabled = true
        toolBar.sizeToFit()

        textField.delegate = self
        textField.inputAccessoryView = toolBar
    }
    func donePressed(){
        view.endEditing(true)
    }
    func cancelPressed(){
        view.endEditing(true) // or do something
    }
}

extension Date {
    public var year: Int {
        return Calendar.current.component(.year, from: self)
    }
    
    public var month: Int {
        return Calendar.current.component(.month, from: self)
    }
    
    public var day: Int {
        return Calendar.current.component(.day, from: self)
    }
    
    public var monthName: String {
        let nameFormatter = DateFormatter()
                nameFormatter.dateFormat = "MMMM" // format January, February, March, ...
                return nameFormatter.string(from: self)
    }
}

extension UITextField {
  func addLeftPadding() {
    let paddingView = UIView(frame: CGRect(x: 0, y: 0, width: 10, height: self.frame.height))
    self.leftView = paddingView
    self.leftViewMode = ViewMode.always
  }
}
