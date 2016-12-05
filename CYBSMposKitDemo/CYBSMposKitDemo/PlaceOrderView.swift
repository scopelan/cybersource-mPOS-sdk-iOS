//
//  PlaceOrderView.swift
//  CYBSMposKitDemo
//
//  Created by CyberSource on 8/16/16.
//  Copyright © 2016 CyberSource. All rights reserved.
//

import UIKit

class PlaceOrderView: UIView, UIKeyInput, UITextFieldDelegate {

  @IBOutlet weak var integerLabel: UILabel!
  @IBOutlet weak var decimalLabel: UILabel!
  @IBOutlet weak var descriptionTextField: UITextField!
  @IBOutlet weak var payByCardReaderButton: UIButton!
  @IBOutlet weak var payByKeyedInButton: UIButton!

  @objc var keyboardType: UIKeyboardType = .DecimalPad

  var isKeyboardShown = false
  var hasDecimal = false
  var decimalSize = 0

  // MARK: - UIView

  override func canBecomeFirstResponder() -> Bool {
    return !isKeyboardShown
  }

  // MARK: - UIKeyInput

  func hasText() -> Bool {
    return true
  }

  func insertText(text: String) {
    if hasDecimal {
      if decimalSize < 2 {
        let str = decimalLabel.text!.stringByReplacingCharactersInRange(
          decimalLabel.text!.startIndex.advancedBy(decimalSize)..<decimalLabel.text!.startIndex.advancedBy(decimalSize + 1),
          withString: text)
        let attributed = NSMutableAttributedString(string: str)
        attributed.addAttribute(NSForegroundColorAttributeName,
                                value: UIColor.blackColor(),
                                range: NSRange(location: 0, length: decimalSize + 1))
        attributed.addAttribute(NSForegroundColorAttributeName,
                                value: UIColor.lightGrayColor(),
                                range: NSRange(location: decimalSize + 1, length: 2 - decimalSize - 1))
        decimalLabel.attributedText = attributed
        decimalSize += 1
      }
    } else if text == "." {
      integerLabel.textColor = UIColor.blackColor()
      decimalLabel.textColor = UIColor.lightGrayColor()
      hasDecimal = true
    } else if integerLabel.text == "0" {
      integerLabel.text = text
      integerLabel.textColor = UIColor.blackColor()
    } else {
      integerLabel.text = (integerLabel.text ?? "") + text
    }

    let amount = NSDecimalNumber(string: "\(integerLabel.text!).\(decimalLabel.text!)")

    if amount.doubleValue > 0 {
      payByCardReaderButton.enabled = true
      payByKeyedInButton.enabled = true
    }
  }

  func deleteBackward() {
    if hasDecimal {
      decimalSize -= 1
      let str = decimalLabel.text!.stringByReplacingCharactersInRange(
        decimalLabel.text!.startIndex.advancedBy(decimalSize)..<decimalLabel.text!.startIndex.advancedBy(decimalSize + 1),
        withString: "0")
      let attributed = NSMutableAttributedString(string: str)
      attributed.addAttribute(NSForegroundColorAttributeName,
                              value: UIColor.blackColor(),
                              range: NSRange(location: 0, length: decimalSize))
      attributed.addAttribute(NSForegroundColorAttributeName,
                              value: UIColor.lightGrayColor(),
                              range: NSRange(location: decimalSize, length: 2 - decimalSize))
      decimalLabel.attributedText = attributed
      if decimalSize <= 0 {
        decimalLabel.textColor = UIColor.whiteColor()
        hasDecimal = false
      }
    } else if !integerLabel.text!.isEmpty {
      var text = integerLabel.text![integerLabel.text!.startIndex..<integerLabel.text!.endIndex.predecessor()]
      if text.isEmpty {
        text = "0"
        integerLabel.textColor = UIColor.lightGrayColor()
      }
      integerLabel.text = text
    }

    let amount = NSDecimalNumber(string: "\(integerLabel.text!).\(decimalLabel.text!)")

    if amount.doubleValue == 0 {
      payByCardReaderButton.enabled = false
      payByKeyedInButton.enabled = false
    }
  }

}
