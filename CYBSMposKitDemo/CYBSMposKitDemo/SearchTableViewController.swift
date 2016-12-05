//
//  SearchTableViewController.swift
//  CYBSMposKitDemo
//
//  Created by CyberSource on 7/28/16.
//  Copyright © 2016 CyberSource. All rights reserved.
//

import UIKit

class SearchTableViewController: UITableViewController {

  // MARK: - IBOutlet
  @IBOutlet weak var fromDatePicker: UIDatePicker!
  @IBOutlet weak var toDatePicker: UIDatePicker!

  let timeFormatter = NSDateFormatter()
  let dateFormatter = NSDateFormatter()
  let fromDateCellIndexPath = NSIndexPath(forRow: 0, inSection:  0)
  let fromDatePickerCellIndexPath = NSIndexPath(forRow: 1, inSection: 0)
  let toDateCellIndexPath = NSIndexPath(forRow: 2, inSection: 0)
  let toDatePickerCellIndexPath = NSIndexPath(forRow: 3, inSection: 0)
  let todayDateCellIndexPath = NSIndexPath(forRow: 4, inSection: 0)
  let yesterdayDateCellIndexPath = NSIndexPath(forRow: 5, inSection: 0)
  let last60DaysDateCellIndexPath = NSIndexPath(forRow: 6, inSection: 0)
  let filterByAccountSuffixCellIndexPath = NSIndexPath(forRow: 0, inSection: 1)
  let filterByAccountPrefixAndSuffixCellIndexPath = NSIndexPath(forRow: 1, inSection: 1)
  let filterByLastNameCellIndexPath = NSIndexPath(forRow: 2, inSection: 1)
  let filterByDeviceIDCellIndexPath = NSIndexPath(forRow: 3, inSection: 1)
  let filterByMerchantReferenceNumberCellIndexPath = NSIndexPath(forRow: 4, inSection: 1)

  var query = CYBSMposTransactionSearchQuery()
  var selectedDatePickerCellIndexPath: NSIndexPath?
  var lastSelectedDateCellIndexPath: NSIndexPath?
  var lastSelectedFilterCellIndexPath: NSIndexPath?

  // MARK: - UIViewController

  override func viewDidLoad() {
    super.viewDidLoad()
    navigationItem.titleView = UIImageView(image: UIImage(named: "Logo"))
    timeFormatter.dateFormat = "yyyy-MM-dd hh:mm a"
    dateFormatter.dateFormat = "yyyy-MM-dd"
    lastSelectedDateCellIndexPath = last60DaysDateCellIndexPath
  }

  override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
    if segue.identifier == "showSearchResult" {
      let destinationController = segue.destinationViewController as! HistoryTableViewController
      destinationController.query = self.query
    }
  }

  // MARK: - IBAction

  @IBAction func fromDatePickerValueChanged(fromDatePicker: UIDatePicker) {
    setDetailTextLabelText(fromDateCellIndexPath, text: timeFormatter.stringFromDate(fromDatePicker.date))
    query.dateFrom = fromDatePicker.date.timeIntervalSince1970
  }

  @IBAction func toDatePickerValueChanged(toDatePicker: UIDatePicker) {
    setDetailTextLabelText(toDateCellIndexPath, text: timeFormatter.stringFromDate(toDatePicker.date))
    query.dateTo = toDatePicker.date.timeIntervalSince1970
  }

  @IBAction func search(sender: AnyObject) {
    performSegueWithIdentifier("showSearchResult", sender: self)
  }

  // MARK: - UITableViewDelegate

  override func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
    switch indexPath {
    case fromDateCellIndexPath:
      fromDateCellSelected()
    case toDateCellIndexPath:
      toDateCellSelected()
    case todayDateCellIndexPath:
      todayDateCellSelected()
    case yesterdayDateCellIndexPath:
      yesterdayDateCellSelected()
    case last60DaysDateCellIndexPath:
      last60DaysDateCellSelected()
    case filterByAccountSuffixCellIndexPath:
      filterByAccountSuffixCellSelected()
    case filterByAccountPrefixAndSuffixCellIndexPath:
      filterByAccountPrefixAndSuffixCellSelected()
    case filterByLastNameCellIndexPath:
      filterByLastNameCellSelected()
    case filterByDeviceIDCellIndexPath:
      filterByDeviceIDCellSelected()
    case filterByMerchantReferenceNumberCellIndexPath:
      filterByMerchantReferenceNumberCellSelected()
    default:
      break
    }
  }

  override func tableView(tableView: UITableView, heightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat {
    if (indexPath == fromDatePickerCellIndexPath || indexPath == toDatePickerCellIndexPath) && indexPath != selectedDatePickerCellIndexPath {
      return 0
    }
    return super.tableView(tableView, heightForRowAtIndexPath: indexPath)
  }

  // MARK: -

  func getDetailTextLabelText(indexPath: NSIndexPath) -> String {
    return tableView.cellForRowAtIndexPath(indexPath)!.detailTextLabel!.text ?? ""
  }

  func setDetailTextLabelText(indexPath: NSIndexPath, text: String) {
    tableView.cellForRowAtIndexPath(indexPath)?.detailTextLabel!.text = text
    tableView.reloadRowsAtIndexPaths([indexPath], withRowAnimation: .None)
  }

  func fromDateCellSelected() {
    if !(lastSelectedDateCellIndexPath == fromDateCellIndexPath || lastSelectedDateCellIndexPath == toDateCellIndexPath) {
      tableView.cellForRowAtIndexPath(lastSelectedDateCellIndexPath!)!.accessoryType = .None
      query.dateFrom = 0
      query.dateTo = 0
    }
    lastSelectedDateCellIndexPath = fromDateCellIndexPath
    tableView.beginUpdates()
    if selectedDatePickerCellIndexPath == fromDatePickerCellIndexPath {
      selectedDatePickerCellIndexPath = nil
    } else {
      selectedDatePickerCellIndexPath = fromDatePickerCellIndexPath
      if getDetailTextLabelText(fromDateCellIndexPath).isEmpty {
        fromDatePicker.date = NSDate()
      }
      setDetailTextLabelText(fromDateCellIndexPath, text: timeFormatter.stringFromDate(fromDatePicker.date))
      query.dateFrom = fromDatePicker.date.timeIntervalSince1970
    }
    tableView.endUpdates()
  }

  func toDateCellSelected() {
    if !(lastSelectedDateCellIndexPath == fromDateCellIndexPath || lastSelectedDateCellIndexPath == toDateCellIndexPath) {
      tableView.cellForRowAtIndexPath(lastSelectedDateCellIndexPath!)!.accessoryType = .None
      query.dateFrom = 0
      query.dateTo = 0
    }
    lastSelectedDateCellIndexPath = toDateCellIndexPath
    tableView.beginUpdates()
    if selectedDatePickerCellIndexPath == toDatePickerCellIndexPath {
      selectedDatePickerCellIndexPath = nil
    } else {
      selectedDatePickerCellIndexPath = toDatePickerCellIndexPath
      if getDetailTextLabelText(toDateCellIndexPath).isEmpty {
        toDatePicker.date = NSDate()
      }
      setDetailTextLabelText(toDateCellIndexPath, text: timeFormatter.stringFromDate(toDatePicker.date))
      query.dateTo = toDatePicker.date.timeIntervalSince1970
    }
    tableView.endUpdates()
  }

  func todayDateCellSelected() {
    if !(lastSelectedDateCellIndexPath == fromDateCellIndexPath || lastSelectedDateCellIndexPath == toDateCellIndexPath) {
      tableView.cellForRowAtIndexPath(lastSelectedDateCellIndexPath!)!.accessoryType = .None
    }
    lastSelectedDateCellIndexPath = todayDateCellIndexPath
    tableView.beginUpdates()
    selectedDatePickerCellIndexPath = nil
    tableView.reloadRowsAtIndexPaths([todayDateCellIndexPath], withRowAnimation: .None)
    tableView.endUpdates()
    tableView.cellForRowAtIndexPath(todayDateCellIndexPath)!.accessoryType = .Checkmark
    query.dateFrom = dateFormatter.dateFromString(dateFormatter.stringFromDate(NSDate()))!.timeIntervalSince1970
    query.dateTo = query.dateFrom + 86400
    setDetailTextLabelText(fromDateCellIndexPath, text: "")
    setDetailTextLabelText(toDateCellIndexPath, text: "")
  }

  func yesterdayDateCellSelected() {
    if !(lastSelectedDateCellIndexPath == fromDateCellIndexPath || lastSelectedDateCellIndexPath == toDateCellIndexPath) {
      tableView.cellForRowAtIndexPath(lastSelectedDateCellIndexPath!)!.accessoryType = .None
    }
    lastSelectedDateCellIndexPath = yesterdayDateCellIndexPath
    tableView.beginUpdates()
    selectedDatePickerCellIndexPath = nil
    tableView.reloadRowsAtIndexPaths([yesterdayDateCellIndexPath], withRowAnimation: .None)
    tableView.endUpdates()
    tableView.cellForRowAtIndexPath(yesterdayDateCellIndexPath)!.accessoryType = .Checkmark
    query.dateTo = dateFormatter.dateFromString(dateFormatter.stringFromDate(NSDate()))!.timeIntervalSince1970
    query.dateFrom = query.dateTo - 86400
    setDetailTextLabelText(fromDateCellIndexPath, text: "")
    setDetailTextLabelText(toDateCellIndexPath, text: "")
  }

  func last60DaysDateCellSelected() {
    if !(lastSelectedDateCellIndexPath == fromDateCellIndexPath || lastSelectedDateCellIndexPath == toDateCellIndexPath) {
      tableView.cellForRowAtIndexPath(lastSelectedDateCellIndexPath!)!.accessoryType = .None
    }
    lastSelectedDateCellIndexPath = last60DaysDateCellIndexPath
    tableView.beginUpdates()
    selectedDatePickerCellIndexPath = nil
    tableView.reloadRowsAtIndexPaths([last60DaysDateCellIndexPath], withRowAnimation: .None)
    tableView.endUpdates()
    tableView.cellForRowAtIndexPath(last60DaysDateCellIndexPath)!.accessoryType = .Checkmark
    query.dateTo = 0
    query.dateFrom = 0
    setDetailTextLabelText(fromDateCellIndexPath, text: "")
    setDetailTextLabelText(toDateCellIndexPath, text: "")
  }

  func filterByAccountSuffixCellSelected() {
    let alertController = UIAlertController(title: "FILTER BY", message: nil, preferredStyle: .Alert)
    alertController.addTextFieldWithConfigurationHandler({ (textField) in
      textField.placeholder = "Account Suffix"
    })
    let cancelAction = UIAlertAction(title: "Cancel", style: .Cancel) { (action) in
    }
    alertController.addAction(cancelAction)
    let doneAction = UIAlertAction(title: "Done", style: .Default) { (action) in
      if let lastSelectedFilterCellIndexPath = self.lastSelectedFilterCellIndexPath {
        if lastSelectedFilterCellIndexPath != self.filterByAccountSuffixCellIndexPath {
          self.setDetailTextLabelText(lastSelectedFilterCellIndexPath, text: "")
        }
      }
      let accountSuffix = alertController.textFields![0].text!
      if accountSuffix.isEmpty {
        self.lastSelectedFilterCellIndexPath = nil
        self.query.filters = 0
        self.setDetailTextLabelText(self.filterByAccountSuffixCellIndexPath, text: "")
        self.query.accountSuffix = nil
      } else {
        self.lastSelectedFilterCellIndexPath = self.filterByAccountSuffixCellIndexPath
        self.query.filters = CYBSMposTransactionSearchQueryFilter.AccountSuffix.rawValue
        self.setDetailTextLabelText(self.filterByAccountSuffixCellIndexPath, text: accountSuffix)
        self.query.accountSuffix = accountSuffix
      }
    }
    alertController.addAction(doneAction)
    dispatch_async(dispatch_get_main_queue(), {
      self.presentViewController(alertController, animated: true) {
      }
    })
  }

  func filterByAccountPrefixAndSuffixCellSelected() {
    let alertController = UIAlertController(title: "FILTER BY", message: nil, preferredStyle: .Alert)
    alertController.addTextFieldWithConfigurationHandler({ (textField) in
      textField.placeholder = "Account Prefix"
    })
    alertController.addTextFieldWithConfigurationHandler({ (textField) in
      textField.placeholder = "Account Suffix"
    })
    let cancelAction = UIAlertAction(title: "Cancel", style: .Cancel) { (action) in
    }
    alertController.addAction(cancelAction)
    let doneAction = UIAlertAction(title: "Done", style: .Default) { (action) in
      if let lastSelectedFilterCellIndexPath = self.lastSelectedFilterCellIndexPath {
        if lastSelectedFilterCellIndexPath != self.filterByAccountPrefixAndSuffixCellIndexPath {
          self.setDetailTextLabelText(lastSelectedFilterCellIndexPath, text: "")
        }
      }
      let accountPrefix = alertController.textFields![0].text!
      let accountSuffix = alertController.textFields![1].text!

      if accountPrefix.isEmpty || accountSuffix.isEmpty {
        self.lastSelectedFilterCellIndexPath = nil
        self.query.filters = 0
        self.setDetailTextLabelText(self.filterByAccountPrefixAndSuffixCellIndexPath, text: "")
        self.query.accountPrefix = nil
        self.query.accountSuffix = nil
      } else {
        self.lastSelectedFilterCellIndexPath = self.filterByAccountPrefixAndSuffixCellIndexPath
        self.query.filters = CYBSMposTransactionSearchQueryFilter.AccountPrefix.rawValue | CYBSMposTransactionSearchQueryFilter.AccountSuffix.rawValue
        self.setDetailTextLabelText(self.filterByAccountPrefixAndSuffixCellIndexPath, text: "\(accountPrefix) \(accountSuffix)")
        self.query.accountPrefix = accountPrefix
        self.query.accountSuffix = accountSuffix
      }
    }
    alertController.addAction(doneAction)
    dispatch_async(dispatch_get_main_queue(), {
      self.presentViewController(alertController, animated: true) {
      }
    })
  }

  func filterByLastNameCellSelected() {
    let alertController = UIAlertController(title: "FILTER BY", message: nil, preferredStyle: .Alert)
    alertController.addTextFieldWithConfigurationHandler({ (textField) in
      textField.placeholder = "Last Name"
    })
    let cancelAction = UIAlertAction(title: "Cancel", style: .Cancel) { (action) in
    }
    alertController.addAction(cancelAction)
    let doneAction = UIAlertAction(title: "Done", style: .Default) { (action) in
      if let lastSelectedFilterCellIndexPath = self.lastSelectedFilterCellIndexPath {
        if lastSelectedFilterCellIndexPath != self.filterByLastNameCellIndexPath {
          self.setDetailTextLabelText(lastSelectedFilterCellIndexPath, text: "")
        }
      }
      let lastName = alertController.textFields![0].text!
      if lastName.isEmpty {
        self.lastSelectedFilterCellIndexPath = nil
        self.query.filters = 0
        self.setDetailTextLabelText(self.filterByLastNameCellIndexPath, text: "")
        self.query.lastName = nil
      } else {
        self.lastSelectedFilterCellIndexPath = self.filterByLastNameCellIndexPath
        self.query.filters = CYBSMposTransactionSearchQueryFilter.LastName.rawValue
        self.setDetailTextLabelText(self.filterByLastNameCellIndexPath, text: lastName)
        self.query.lastName = lastName
      }
    }
    alertController.addAction(doneAction)
    dispatch_async(dispatch_get_main_queue(), {
      self.presentViewController(alertController, animated: true) {
      }
    })
  }

  func filterByDeviceIDCellSelected() {
    let alertController = UIAlertController(title: "FILTER BY", message: nil, preferredStyle: .Alert)
    alertController.addTextFieldWithConfigurationHandler({ (textField) in
      textField.placeholder = "Device ID"
    })
    let cancelAction = UIAlertAction(title: "Cancel", style: .Cancel) { (action) in
    }
    alertController.addAction(cancelAction)
    let doneAction = UIAlertAction(title: "Done", style: .Default) { (action) in
      if let lastSelectedFilterCellIndexPath = self.lastSelectedFilterCellIndexPath {
        if lastSelectedFilterCellIndexPath != self.filterByDeviceIDCellIndexPath {
          self.setDetailTextLabelText(lastSelectedFilterCellIndexPath, text: "")
        }
      }
      let deviceID = alertController.textFields![0].text!
      if deviceID.isEmpty {
        self.lastSelectedFilterCellIndexPath = nil
        self.query.filters = 0
        self.setDetailTextLabelText(self.filterByDeviceIDCellIndexPath, text: "")
        self.query.deviceId = nil
      } else {
        self.lastSelectedFilterCellIndexPath = self.filterByDeviceIDCellIndexPath
        self.query.filters = CYBSMposTransactionSearchQueryFilter.DeviceId.rawValue
        self.setDetailTextLabelText(self.filterByDeviceIDCellIndexPath, text: deviceID)
        self.query.deviceId = deviceID
      }
    }
    alertController.addAction(doneAction)
    dispatch_async(dispatch_get_main_queue(), {
      self.presentViewController(alertController, animated: true) {
      }
    })
  }

  func filterByMerchantReferenceNumberCellSelected() {
    let alertController = UIAlertController(title: "FILTER BY", message: nil, preferredStyle: .Alert)
    alertController.addTextFieldWithConfigurationHandler({ (textField) in
      textField.placeholder = "Merchant Reference Number"
    })
    let cancelAction = UIAlertAction(title: "Cancel", style: .Cancel) { (action) in
    }
    alertController.addAction(cancelAction)
    let doneAction = UIAlertAction(title: "Done", style: .Default) { (action) in
      if let lastSelectedFilterCellIndexPath = self.lastSelectedFilterCellIndexPath {
        if lastSelectedFilterCellIndexPath != self.filterByMerchantReferenceNumberCellIndexPath {
          self.setDetailTextLabelText(lastSelectedFilterCellIndexPath, text: "")
        }
      }
      let merchantReferenceNumber = alertController.textFields![0].text!
      if merchantReferenceNumber.isEmpty {
        self.lastSelectedFilterCellIndexPath = nil
        self.query.filters = 0
        self.setDetailTextLabelText(self.filterByMerchantReferenceNumberCellIndexPath, text: "")
        self.query.merchantReferenceCode = nil
      } else {
        self.lastSelectedFilterCellIndexPath = self.filterByMerchantReferenceNumberCellIndexPath
        self.query.filters = CYBSMposTransactionSearchQueryFilter.MerchantReferenceCode.rawValue
        self.setDetailTextLabelText(self.filterByMerchantReferenceNumberCellIndexPath, text: merchantReferenceNumber)
        self.query.merchantReferenceCode = merchantReferenceNumber
      }
    }
    alertController.addAction(doneAction)
    dispatch_async(dispatch_get_main_queue(), {
      self.presentViewController(alertController, animated: true) {
      }
    })
  }

}
