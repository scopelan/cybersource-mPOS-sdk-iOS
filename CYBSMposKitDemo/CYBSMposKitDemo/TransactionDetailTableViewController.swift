//
//  TransactionDetailTableViewController.swift
//  CYBSMposKitDemo
//
//  Created by CyberSource on 7/29/16.
//  Copyright © 2016 CyberSource. All rights reserved.
//

import UIKit

class TransactionDetailTableViewController: UITableViewController, CYBSMposManagerDelegate {

  @IBOutlet var spinner: UIActivityIndicatorView!

  let sections = ["Transaction Info", "Payment Info", "Actions", "Events"]
  let numberOfRowsInSection = [12, 7, 0, 0]
  let actions: [CYBSMposTransactionType: [CYBSMposTransactionActionType]] = [
    .Authorization: [.Reverse],
    .Capture: [.SendReceipt, .Void, .Refund],
    .Sale: [.SendReceipt, .Void, .Refund],
    .Refund: [.Void]
  ]

  let dateFormatter = NSDateFormatter()

  var transaction: CYBSMposTransaction?
  var events: [CYBSMposTransaction] = []
  var transactionReady = false
  var gotAllEvents = false

  override func viewDidLoad() {
    super.viewDidLoad()
    navigationItem.titleView = UIImageView(image: UIImage(named: "Logo"))
    dateFormatter.dateFormat = "yyyy-MM-dd HH:mm"

    if !transactionReady {
      spinner.color = UIColor.grayColor()

      let navigationBarHeight = self.navigationController!.navigationBar.frame.size.height
      let tabBarHeight = self.tabBarController!.tabBar.frame.size.height
      spinner.center = CGPointMake(self.view.frame.size.width / 2.0, (self.view.frame.size.height  - navigationBarHeight - tabBarHeight) / 2.0);

      view.addSubview(spinner)

      spinner.hidesWhenStopped = true

      view.userInteractionEnabled = false
      spinner.startAnimating()

      Utils.createAccessToken { (accessToken, error) in
        let manager = Utils.getManager()
        manager.getTransactionDetail(self.transaction!.transactionID, accessToken: accessToken!, delegate: self)
      }
    }
  }

  override func numberOfSectionsInTableView(tableView: UITableView) -> Int {
    return sections.count
  }

  override func tableView(tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
    return sections[section]
  }

  override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
    var numberOfRows = numberOfRowsInSection[section]
    if numberOfRows == 0 {
      if let transaction = self.transaction {
        if section == 2 {
          if let actions = actions[transaction.transactionType] {
            numberOfRows = actions.count
          }
        } else if section == 3 {
          if gotAllEvents {
            numberOfRows = events.count
          } else if transaction.events?.count > 0 {
            numberOfRows = 1
          }
        }
      }
    }
    return numberOfRows
  }

  func createTransactionInfoCell(indexPath: NSIndexPath) -> UITableViewCell {

    let cell = tableView.dequeueReusableCellWithIdentifier("TransactionDetailCell", forIndexPath: indexPath)

    cell.detailTextLabel!.text = ""

    switch indexPath.row {
    case 0:
      cell.textLabel!.text = "Transaction ID"
      if let transaction = self.transaction {
        cell.detailTextLabel!.text = transaction.transactionID
      }
    case 1:
      cell.textLabel!.text = "Transaction Date"
      if let transaction = self.transaction {
        cell.detailTextLabel!.text = dateFormatter.stringFromDate(transaction.transactionDate)
      }
    case 2:
      cell.textLabel!.text = "Transaction Type"
      if let transaction = self.transaction {
        switch (transaction.transactionType) {
        case .Authorization:
          cell.detailTextLabel!.text = "Authorization"
        case .Capture:
          cell.detailTextLabel!.text = "Capture"
        case .Sale:
          cell.detailTextLabel!.text = "Sale"
        case .Refund:
          cell.detailTextLabel!.text = "Refund"
        case .Reversal:
          cell.detailTextLabel!.text = "Reversal"
        case .Void:
          cell.detailTextLabel!.text = "Void"
        case .Metadata:
          cell.detailTextLabel!.text = "Metadata"
        default:
          cell.detailTextLabel!.text = "Undefined"
        }
      }
    case 3:
      cell.textLabel!.text = "Currency"
      if let transaction = self.transaction {
        cell.detailTextLabel!.text = transaction.currency
      }
    case 4:
      cell.textLabel!.text = "Amount"
      if let amount = self.transaction?.amount {
        cell.detailTextLabel!.text = NSString(format:"$%.2f", amount.doubleValue) as String
      }
    case 5:
      cell.textLabel!.text = "Merchant Reference Code"
      if let transaction = self.transaction {
        cell.detailTextLabel!.text = transaction.merchantReferenceCode
      }
    case 6:
      cell.textLabel!.text = "Transaction Reference No"
      if let transaction = self.transaction {
        cell.detailTextLabel!.text = transaction.transRefNo
      }
    case 7:
      cell.textLabel!.text = "Authorization Code"
      if let transaction = self.transaction {
        cell.detailTextLabel!.text = transaction.authCode
      }
    case 8:
      cell.textLabel!.text = "Reason Code"
      if let transaction = self.transaction where transaction.reasonCode != 0 {
        cell.detailTextLabel!.text = String(transaction.reasonCode)
      }
    case 9:
      cell.textLabel!.text = "Reply Message"
      if let transaction = self.transaction {
        cell.detailTextLabel!.text = transaction.replyMessage
      }
    case 10:
      cell.textLabel!.text = "Request Token"
      if let transaction = self.transaction {
        cell.detailTextLabel!.text = transaction.requestToken
      }
    case 11:
      cell.textLabel!.text = "Status"
      if let transaction = self.transaction {
        cell.detailTextLabel!.text = transaction.status
      }
    default:
      break
    }

    return cell
  }

  func createPaymentInfoCell(indexPath: NSIndexPath) -> UITableViewCell {

    let cell = tableView.dequeueReusableCellWithIdentifier("TransactionDetailCell", forIndexPath: indexPath)

    cell.detailTextLabel!.text = ""

    switch indexPath.row {
    case 0:
      cell.textLabel!.text = "Payment Type"
      if let paymentInfo = self.transaction?.paymentInfo {
        cell.detailTextLabel!.text = paymentInfo.paymentType
      }
    case 1:
      cell.textLabel!.text = "Full Name"
      if let paymentInfo = self.transaction?.paymentInfo {
        cell.detailTextLabel!.text = paymentInfo.fullName
      }
    case 2:
      cell.textLabel!.text = "Account Suffix"
      if let paymentInfo = self.transaction?.paymentInfo {
        cell.detailTextLabel!.text = paymentInfo.accountSuffix
      }
    case 3:
      cell.textLabel!.text = "Expiration Month"
      if let paymentInfo = self.transaction?.paymentInfo {
        cell.detailTextLabel!.text = paymentInfo.expirationMonth
      }
    case 4:
      cell.textLabel!.text = "Expiration Year"
      if let paymentInfo = self.transaction?.paymentInfo {
        cell.detailTextLabel!.text = paymentInfo.expirationYear
      }
    case 5:
      cell.textLabel!.text = "Card Type"
      if let paymentInfo = self.transaction?.paymentInfo {
        cell.detailTextLabel!.text = paymentInfo.cardType
      }
    case 6:
      cell.textLabel!.text = "Processor"
      if let paymentInfo = self.transaction?.paymentInfo {
        cell.detailTextLabel!.text = paymentInfo.processor
      }
    default:
      break
    }

    return cell
  }

  func canRefund() -> Bool {
    if let transaction = self.transaction  where transactionReady && !transaction.error {
      switch transaction.transactionType {
      case .Capture, .Sale:
        if (transaction.status == "PENDING" || transaction.status == "TRANSMITTED") &&
          ((transaction.actions & CYBSMposTransactionActionType.Refund.rawValue) == CYBSMposTransactionActionType.Refund.rawValue) {
          if gotAllEvents && !events.isEmpty {
            var refundAmount = 0.0
            for event in events {
              if event.transactionType == .Refund {
                refundAmount += event.amount?.doubleValue ?? 0.0
              }
            }
            if refundAmount < transaction.amount?.doubleValue {
              return true
            }
          }
        }
      default:
        break
      }
    }
    return false
  }

  func canReverse() -> Bool {
    if let transaction = self.transaction where transactionReady && !transaction.error {
      switch transaction.transactionType {
      case .Authorization:
        if (transaction.actions & CYBSMposTransactionActionType.Reverse.rawValue) == CYBSMposTransactionActionType.Reverse.rawValue {
          return true
        }
      default:
        break
      }
    }
    return false
  }

  func canVoid() -> Bool {
    if let transaction = self.transaction where transactionReady && !transaction.error {
      switch transaction.transactionType {
      case .Capture, .Sale, .Refund:
        if transaction.status == "PENDING" {
          return true
        }
      default:
        break
      }
    }
    return false
  }

  func canSendReceipt() -> Bool {
    if let transaction = self.transaction where transactionReady && !transaction.error {
      switch transaction.transactionType {
      case .Capture, .Sale:
        return true
      default:
        break
      }
    }
    return false
  }

  func createActionCell(indexPath: NSIndexPath) -> UITableViewCell {

    let cell = tableView.dequeueReusableCellWithIdentifier("TransactionActionCell", forIndexPath: indexPath) as! TransactionActionCell

    cell.button.enabled = false

    switch actions[transaction!.transactionType]![indexPath.row] {
    case .Refund:
      cell.button.setTitle("Refund", forState: .Normal)
      cell.button.enabled = canRefund()
      cell.button.tag = Int(CYBSMposTransactionActionType.Refund.rawValue)
    case .Reverse:
      cell.button.setTitle("Reverse", forState: .Normal)
      cell.button.enabled = canReverse()
      cell.button.tag = Int(CYBSMposTransactionActionType.Reverse.rawValue)
    case .Void:
      cell.button.setTitle("Void", forState: .Normal)
      cell.button.enabled = canVoid()
      cell.button.tag = Int(CYBSMposTransactionActionType.Void.rawValue)
    case .SendReceipt:
      cell.button.setTitle("Send Receipt", forState: .Normal)
      cell.button.enabled = canSendReceipt()
      cell.button.tag = Int(CYBSMposTransactionActionType.SendReceipt.rawValue)
    default:
      break
    }

    return cell
  }

  func createEventCell(indexPath: NSIndexPath) -> UITableViewCell {

    let cell = tableView.dequeueReusableCellWithIdentifier("TransactionEventCell", forIndexPath: indexPath) as! HistoryTableViewCell

    let transaction = events[indexPath.row]

    cell.transactionDateLabel.text = self.dateFormatter.stringFromDate(transaction.transactionDate)
    cell.transactionIDLabel.text = transaction.transactionID

    if let info = transaction.paymentInfo {
      var paymentInfo = String()
      if info.cardType == "Visa" {
        cell.paymentTypeImage.image = UIImage(named: "VisaLogo")
      } else if info.cardType == "MasterCard" {
        cell.paymentTypeImage.image = UIImage(named: "MasterCardLogo")
      } else if info.cardType == "American Express" {
        cell.paymentTypeImage.image = UIImage(named: "AmericanExpressLogo")
      } else if info.cardType == "Discover" {
        cell.paymentTypeImage.image = UIImage(named: "DiscoverLogo")
      } else {
        cell.paymentTypeImage.image = UIImage()
        paymentInfo += info.cardType ?? ""
      }

      if let accountSuffix = info.accountSuffix {
        paymentInfo += " " + accountSuffix
      }

      if let fullName = info.fullName {
        paymentInfo += " " + fullName
      }

      cell.paymentInfoLabel.text = paymentInfo
    }

    cell.merchantReferenceCodeLabel.text = transaction.merchantReferenceCode ?? ""
    cell.amountLabel.text = transaction.amount != nil ? NSString(format:"$%.2f", transaction.amount!.doubleValue) as String : ""

    switch (transaction.transactionType) {
    case .Authorization:
      cell.transactionTypeLabel.text = "Authorization"
    case .Capture:
      cell.transactionTypeLabel.text = "Capture"
    case .Sale:
      cell.transactionTypeLabel.text = "Sale"
    case .Refund:
      cell.transactionTypeLabel.text = "Refund"
    case .Reversal:
      cell.transactionTypeLabel.text = "Reversal"
    case .Void:
      cell.transactionTypeLabel.text = "Void"
    case .Metadata:
      cell.transactionTypeLabel.text = "Metadata"
    default:
      cell.transactionTypeLabel.text = "Undefined"
    }

    if transaction.error {
      cell.transactionTypeLabel.textColor = UIColor.redColor()
    } else {
      cell.transactionTypeLabel.textColor = nil;
    }

    if transaction.transactionID == self.transaction?.transactionID {
      cell.accessoryType = .Checkmark
      cell.selectionStyle = .None
    } else {
      cell.accessoryType = .DisclosureIndicator
      cell.selectionStyle = .Default
    }

    return cell
  }

  override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
    if indexPath.section == 0 {
      return createTransactionInfoCell(indexPath)
    } else if indexPath.section == 1 {
      return createPaymentInfoCell(indexPath)
    } else if indexPath.section == 2 {
      return createActionCell(indexPath)
    } else if gotAllEvents {
      return createEventCell(indexPath)
    } else {
      let cell = tableView.dequeueReusableCellWithIdentifier("LoadingCell", forIndexPath: indexPath)
      let activityIndicator = cell.contentView.viewWithTag(100) as! UIActivityIndicatorView
      activityIndicator.startAnimating()
      return cell
    }
  }

  override func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
    if indexPath.section == 3 {
      let cell = tableView.cellForRowAtIndexPath(indexPath)
      if cell?.accessoryType == .DisclosureIndicator {
        let controller = self.storyboard?.instantiateViewControllerWithIdentifier("TransactionDetailTableViewController") as! TransactionDetailTableViewController
        controller.transaction = events[indexPath.row]
        controller.transactionReady = true
        controller.events = events
        controller.gotAllEvents = true
        self.navigationController?.pushViewController(controller, animated: true)
      }
    }
  }

  func sendReceipt() {
    let alertController = UIAlertController(title: "Receipt",
                                            message: "Please enter the email address to receive an electronic receipt.",
                                            preferredStyle: .Alert)
    alertController.addTextFieldWithConfigurationHandler({ (textField) in
      textField.placeholder = "Customer E-mail Address"
    })
    let cancelAction = UIAlertAction(title: "Cancel", style: .Cancel) { (action) in
    }
    alertController.addAction(cancelAction)
    let doneAction = UIAlertAction(title: "Done", style: .Default) { (action) in
      Utils.createAccessToken { (accessToken, error) in

        let manager = Utils.getManager()

        let receiptRequest = CYBSMposReceiptRequest(transactionID: self.transaction!.transactionID,
                                                          toEmail: alertController.textFields![0].text!,
                                                      accessToken: accessToken!)

        manager.sendReceipt(receiptRequest, delegate: self)
      }
    }
    alertController.addAction(doneAction)
    self.presentViewController(alertController, animated: true) {
    }
  }

  func refund() {
    let alertController = UIAlertController(title: "Refund",
                                            message: "Please enter the merchant reference code.",
                                            preferredStyle: .Alert)
    alertController.addTextFieldWithConfigurationHandler({ (textField) in
      textField.placeholder = "Merchant Reference Code"
    })
    let cancelAction = UIAlertAction(title: "Cancel", style: .Cancel) { (action) in
    }
    alertController.addAction(cancelAction)
    let doneAction = UIAlertAction(title: "Done", style: .Default) { (action) in
      Utils.createAccessToken { (accessToken, error) in
        let merchantID = Settings.sharedInstance.merchantID ?? ""

        let manager = Utils.getManager()

        let refundRequest = CYBSMposRefundRequest(merchantID: merchantID, accessToken: accessToken!,
          merchantReferenceCode: alertController.textFields![0].text!, transactionID: self.transaction!.transactionID,
          currency: self.transaction!.currency!, amount: self.transaction!.amount!)

        manager.performRefund(refundRequest, delegate: self)
      }
    }
    alertController.addAction(doneAction)
    self.presentViewController(alertController, animated: true) {
    }
  }

  func void() {
    let alertController = UIAlertController(title: "Void",
                                            message: "Please enter the merchant reference code.",
                                            preferredStyle: .Alert)
    alertController.addTextFieldWithConfigurationHandler({ (textField) in
      textField.placeholder = "Merchant Reference Code"
    })
    let cancelAction = UIAlertAction(title: "Cancel", style: .Cancel) { (action) in
    }
    alertController.addAction(cancelAction)
    let doneAction = UIAlertAction(title: "Done", style: .Default) { (action) in
      Utils.createAccessToken { (accessToken, error) in
        let merchantID = Settings.sharedInstance.merchantID ?? ""

        let manager = Utils.getManager()

        let voidRequest = CYBSMposVoidRequest(merchantID: merchantID, accessToken: accessToken!,
          merchantReferenceCode: alertController.textFields![0].text!, transactionID: self.transaction!.transactionID)

        manager.performVoid(voidRequest, delegate: self)
      }
    }
    alertController.addAction(doneAction)
    self.presentViewController(alertController, animated: true) {
    }
  }

  func getTransactionDetailDidFinish(transaction: CYBSMposTransaction?, error: NSError?) {
    if  let transaction = transaction {
      if !transactionReady {
        spinner.stopAnimating()
        view.userInteractionEnabled = true
        self.transaction = transaction
        transactionReady = true
        tableView.reloadData()
        if let events = transaction.events {
          if !events.isEmpty {
            dispatch_async(dispatch_get_main_queue(), {
              Utils.createAccessToken { (accessToken, error) in
                let manager = Utils.getManager()
                manager.getTransactionDetail(events[0].transactionID, accessToken: accessToken!, delegate: self)
              }
            })
          }
        }
      } else {
        events.append(transaction)
        if events.count < self.transaction!.events!.count {
          dispatch_async(dispatch_get_main_queue(), {
            Utils.createAccessToken { (accessToken, error) in
              let manager = Utils.getManager()
              manager.getTransactionDetail(self.transaction!.events![self.events.count].transactionID, accessToken: accessToken!, delegate: self)
            }
          })
        } else {
          var ids = Set<String>()
          var removeDuplicated: [CYBSMposTransaction] = []
          for event in events {
            if !ids.contains(event.transactionID) {
              ids.insert(event.transactionID)
              removeDuplicated.append(event)
            }
          }
          events = removeDuplicated
          gotAllEvents = true
          tableView.reloadData()
        }
      }
    }
  }

  @IBAction func buttonClicked(button: UIButton) {
    if button.tag == Int(CYBSMposTransactionActionType.Refund.rawValue) {
      refund()
    } else if button.tag == Int(CYBSMposTransactionActionType.Void.rawValue) {
      void()
    } else if button.tag == Int(CYBSMposTransactionActionType.SendReceipt.rawValue) {
      sendReceipt()
    }
  }

}
