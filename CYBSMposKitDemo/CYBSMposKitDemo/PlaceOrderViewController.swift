//
//  PlaceOrderViewController.swift
//  CYBSMposKitDemo
//
//  Created by CyberSource on 1/28/16.
//  Copyright © 2016 CyberSource. All rights reserved.
//

import UIKit

import CocoaLumberjackSwift

class PlaceOrderViewController: UIViewController, UITextFieldDelegate, CYBSMposManagerDelegate {

  var accessToken: String?

  // MARK: - UIViewController

  override func viewDidLoad(){
    super.viewDidLoad()
    navigationItem.titleView = UIImageView(image: UIImage(named: "Logo"))
    Settings.sharedInstance.reload()

    let view = self.view as! PlaceOrderView

    let tap: UITapGestureRecognizer = UITapGestureRecognizer(target: self,
                                                             action: #selector(PlaceOrderViewController.dismissKeyboard))

    view.addGestureRecognizer(tap)

    view.descriptionTextField.delegate = self
  }

  // MARK: - IBAction

  @IBAction func pay(sender: AnyObject) {
    Utils.createAccessToken { (accessToken, error) in
      if let accessToken = accessToken {

        let view = self.view as! PlaceOrderView

        self.accessToken = accessToken
        let merchantID = Settings.sharedInstance.merchantID ?? ""
        let merchantReferenceCode = view.descriptionTextField.text!
        let currency = "USD"
        let amount = NSDecimalNumber(string: "\(view.integerLabel.text!).\(view.decimalLabel.text!)")

        let manager = Utils.getManager()

        let paymentRequest = CYBSMposPaymentRequest(merchantID: merchantID,
          accessToken: accessToken,
          merchantReferenceCode: merchantReferenceCode.isEmpty ? "test" : merchantReferenceCode,
          currency: currency,
          amount: amount,
          entryMode: .CardReader)

        manager.performPayment(paymentRequest, parentViewController: self, delegate: self)
      } else {
        self.showAlert("Error", message: (error?.userInfo["message"] as? String) ?? "Failed to get the access token")
      }
    }
  }

  @IBAction func keyIn(sender: AnyObject) {
    Utils.createAccessToken { (accessToken, error) in
      if let accessToken = accessToken {

        let view = self.view as! PlaceOrderView

        self.accessToken = accessToken
        let merchantID = Settings.sharedInstance.merchantID ?? ""
        let merchantReferenceCode = view.descriptionTextField.text!
        let currency = "USD"
        let amount = NSDecimalNumber(string: "\(view.integerLabel.text!).\(view.decimalLabel.text!)")

        let manager = Utils.getManager()

        let paymentRequest = CYBSMposPaymentRequest(merchantID: merchantID,
          accessToken: accessToken,
          merchantReferenceCode: merchantReferenceCode.isEmpty ? "test" : merchantReferenceCode,
          currency: currency,
          amount: amount,
          entryMode: .KeyEntry)

        manager.performPayment(paymentRequest, parentViewController: self, delegate: self)
      } else {
        self.showAlert("Error", message: (error?.userInfo["message"] as? String) ?? "Failed to get the access token")
      }
    }
  }

  // MARK: - UITextFieldDelegate

  func textFieldDidBeginEditing(textField: UITextField) {
    let view = self.view as! PlaceOrderView
    view.isKeyboardShown = true
  }

  // MARK: - CYBSMposManagerDelegate

  func performPaymentDidFinish(result: CYBSMposPaymentResponse?, error: NSError?) {
    if let result = result {
      DDLogDebug("Received payment response: \(result.description)")
      if error == nil {
        let alertController = UIAlertController(title: "Receipt",
                                                message: "Please enter your email address to receive an electronic receipt.",
                                                preferredStyle: .Alert)
        alertController.addTextFieldWithConfigurationHandler({ (textField) in
          textField.placeholder = "Customer E-mail Address"
        })
        let skipAction = UIAlertAction(title: "Skip", style: .Cancel) { (action) in
        }
        alertController.addAction(skipAction)
        let doneAction = UIAlertAction(title: "Done", style: .Default) { (action) in

          let view = self.view as! PlaceOrderView

          let manager = Utils.getManager()

          let receiptRequest = CYBSMposReceiptRequest(toEmail: alertController.textFields![0].text!,
                                                      fromEmail: "no-reply@cybersource.com",
                                                      emailSubject: "Your Transaction Receipt",
                                                      merchantDescriptor: "CyberSource",
                                                      merchantDescriptorStreet: "P.O. Box 8999",
                                                      merchantDescriptorCity: "San Francisco",
                                                      merchantDescriptorState: "CA",
                                                      merchantDescriptorPostalCode: "94128-8999",
                                                      merchantDescriptorCountry: "USA",
                                                      merchantReferenceCode: view.descriptionTextField.text!,
                                                      authCode: result.authorizationCode!,
                                                      shippingAmount: "USD $0.00",
                                                      taxAmount: "USD $0.00",
                                                      totalPurchaseAmount: "USD $\(view.integerLabel.text!).\(view.decimalLabel.text!)",
                                                      accessToken: self.accessToken!)

          manager.sendReceipt(receiptRequest, delegate: self)
        }
        alertController.addAction(doneAction)
        self.presentViewController(alertController, animated: true) {
        }
      }
    }
    if let error = error {
      DDLogDebug("Received payment error: \(error.localizedDescription)")
    }
  }

  // MARK: -

  func showAlert(title: String, message: String) {
    let alertController = UIAlertController(title: title, message: message, preferredStyle: .Alert)
    let cancelAction = UIAlertAction(title: "OK", style: .Cancel) { (action) in
    }
    alertController.addAction(cancelAction)
    self.presentViewController(alertController, animated: true) {
    }
  }

  func dismissKeyboard() {
    let view = self.view as! PlaceOrderView
    if view.isKeyboardShown {
      view.endEditing(true)
      view.isKeyboardShown = false
    } else {
      view.becomeFirstResponder()
      view.isKeyboardShown = true
    }
  }

}
