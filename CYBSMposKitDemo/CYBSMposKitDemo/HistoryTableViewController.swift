//
//  HistoryTableViewController.swift
//  CYBSMposKitDemo
//
//  Created by CyberSource on 7/6/16.
//  Copyright © 2016 CyberSource. All rights reserved.
//

import UIKit

class HistoryTableViewController: UITableViewController, CYBSMposManagerDelegate {

  @IBOutlet var spinner: UIActivityIndicatorView!

  let dateFormatter = NSDateFormatter()
  let transactions = NSMutableArray()

  var query = CYBSMposTransactionSearchQuery()
  var didRefresh = false
  var result: CYBSMposTransactionSearchResult? = nil

  override func viewDidLoad() {
    super.viewDidLoad()

    navigationItem.titleView = UIImageView(image: UIImage(named: "Logo"))

    self.refreshControl = UIRefreshControl()
    self.refreshControl?.backgroundColor = UIColor.whiteColor()
    self.refreshControl?.tintColor = UIColor.grayColor()
    self.refreshControl?.addTarget(self, action: #selector(HistoryTableViewController.refresh), forControlEvents: UIControlEvents.ValueChanged)

    dateFormatter.dateFormat = "yyyy-MM-dd HH:mm"

    spinner.color = UIColor.grayColor()

    let navigationBarHeight = self.navigationController!.navigationBar.frame.size.height
    let tabBarHeight = self.tabBarController!.tabBar.frame.size.height
    spinner.center = CGPointMake(self.view.frame.size.width / 2.0, (self.view.frame.size.height  - navigationBarHeight - tabBarHeight) / 2.0);

    view.addSubview(spinner)

    spinner.hidesWhenStopped = true
    spinner.startAnimating()

    getHistory()
  }

  override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
    if let result = self.result {
      if (self.transactions.count == result.total) {
        return transactions.count
      } else {
        return transactions.count + 1
      }
    }
    return transactions.count
  }

  override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
    if !(self.spinner.isAnimating()) && (self.transactions.count > 0) && (indexPath.row == self.transactions.count) {
      let cell = tableView.dequeueReusableCellWithIdentifier("LoadingCell", forIndexPath: indexPath)
      let activityIndicator = cell.contentView.viewWithTag(100) as! UIActivityIndicatorView
      activityIndicator.startAnimating()
      return cell
    }

    let cell = tableView.dequeueReusableCellWithIdentifier("HistoryTableViewCell",
                                                           forIndexPath: indexPath) as! HistoryTableViewCell

    let transaction = transactions[indexPath.row] as! CYBSMposTransaction

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

    return cell
  }

  override func tableView(tableView: UITableView, willDisplayCell cell: UITableViewCell, forRowAtIndexPath indexPath: NSIndexPath) {
    if (!self.spinner.isAnimating()) && (indexPath.row == (self.transactions.count - 1)) {
      if let result = self.result {
        Utils.createAccessToken { (accessToken, error) in
          if let accessToken = accessToken {
            let manager = Utils.getManager()
            manager.nextTransactionSearchResult(result, accessToken: accessToken, delegate: self)
          } else {
            self.showAlert("Error", message: (error?.userInfo["message"] as? String) ?? "Failed to get the access token")
          }
        }
      }
    }
  }

  override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
    if segue.identifier == "showTransactionDetail" {
      if let indexPath = self.tableView.indexPathForSelectedRow {
        let destinationController = segue.destinationViewController as! TransactionDetailTableViewController
        destinationController.transaction = transactions[indexPath.row] as? CYBSMposTransaction
      }
    }
  }

  func performTransactionSearchDidFinish(result: CYBSMposTransactionSearchResult?, error: NSError?) {
    self.refreshControl?.endRefreshing()
    self.spinner.stopAnimating()
    if let error = error {
      self.showAlert("Error", message: error.localizedDescription)
    } else if let result = result {
      self.result = result
      if let t = result.transactions {
        if self.didRefresh {
          transactions.removeAllObjects()
          didRefresh = false
        }
        transactions.addObjectsFromArray(t)
        tableView.reloadData()
      }
    }
  }

  func showAlert(title: String, message: String) {
    let alertController = UIAlertController(title: title, message: message, preferredStyle: .Alert)
    let cancelAction = UIAlertAction(title: "OK", style: .Cancel) { (action) in
    }
    alertController.addAction(cancelAction)
    self.presentViewController(alertController, animated: true) {
    }
  }

  func refresh() {
    self.didRefresh = true
    getHistory()
  }

  func getHistory() {
    Utils.createAccessToken { (accessToken, error) in
      if let accessToken = accessToken {
        let manager = Utils.getManager()
        manager.performTransactionSearch(self.query, accessToken: accessToken, delegate: self)
      } else {
        self.spinner.stopAnimating()
        self.showAlert("Error", message: (error?.userInfo["message"] as? String) ?? "Failed to get the access token")
      }
    }
  }

}
