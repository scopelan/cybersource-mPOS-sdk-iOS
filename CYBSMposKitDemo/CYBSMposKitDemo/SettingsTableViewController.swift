//
//  SettingsTableViewController.swift
//  CYBSMposKitDemo
//
//  Created by CyberSource on 7/6/16.
//  Copyright © 2016 CyberSource. All rights reserved.
//

import UIKit

class SettingsTableViewController: UITableViewController, UITextFieldDelegate {

  let sections = ["Account", "Endpoints", "Generating Access Token", "POS", "UI Settings", "About", ""]
  let numberOfRowsInSection = [8, 7, 3, 3, 19, 2, 1]
  let generatingAccessTokenMethods = ["Use Client Credentials", "Use Username and Password", "Manual"]

  var pendingTextField: UITextField? = nil

  // MARK: - UIViewController

  override func viewDidLoad() {
    super.viewDidLoad()

    navigationItem.titleView = UIImageView(image: UIImage(named: "Logo"))

    // make the keyboard disappear when tapping background
    let tap: UITapGestureRecognizer = UITapGestureRecognizer(target: self,
                                                             action: #selector(SettingsTableViewController.dismissKeyboard))
    tap.cancelsTouchesInView = false
    view.addGestureRecognizer(tap)
  }

  // MARK: - IBAction

  @IBAction func segmentedControlValueChanged(sender: AnyObject) {
    if let indexPath = getSenderIndexPath(sender) {
      switch indexPath.section {
      case 0:
        switch indexPath.row {
        case 0:
          if let control = sender as? UISegmentedControl {
            if let textField = pendingTextField {
              updateSetting(textField)
            }
            Settings.setEnvironment(control.selectedSegmentIndex)
            Settings.sharedInstance.reload()
            tableView.reloadData()
          }
        default:
          break
        }
      default:
        break
      }
    }
  }


  @IBAction func resetAllSettings(sender: AnyObject) {
    Utils.resetSettings()
    Settings.sharedInstance.reload()
    tableView.reloadData()
  }

  // MARK: - UITableViewDataSource

  override func numberOfSectionsInTableView(tableView: UITableView) -> Int {
    return sections.count
  }

  override func tableView(tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
    return sections[section]
  }

  override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
    return numberOfRowsInSection[section]
  }

  override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
    if indexPath.section == 6 {
      return tableView.dequeueReusableCellWithIdentifier("ResetTableViewCell", forIndexPath: indexPath)
    }

    let cell = getSettingsTableViewCell(tableView, forIndexPath: indexPath)
    switch indexPath.section {
    case 0:
      switch indexPath.row {
      case 0:
        buildOptions(cell, label: "Environment", options: Settings.environments, selected: Settings.getEnvironment())
      case 1:
        buildTextField(cell, label: "Merchant ID", value: Settings.sharedInstance.merchantID, secureTextEntry: false)
      case 2:
        buildTextField(cell, label: "Device ID", value: Settings.sharedInstance.deviceID, secureTextEntry: false)
      case 3:
        buildTextField(cell, label: "Client ID", value: Settings.sharedInstance.clientID, secureTextEntry: false)
      case 4:
        buildTextField(cell, label: "Client Secret", value: Settings.sharedInstance.clientSecret, secureTextEntry: true)
      case 5:
        buildTextField(cell, label: "Username", value: Settings.sharedInstance.username, secureTextEntry: false)
      case 6:
        buildTextField(cell, label: "Password", value: Settings.sharedInstance.password, secureTextEntry: true)
      case 7:
        buildTextField(cell, label: "Access Token", value: Settings.sharedInstance.accessToken, secureTextEntry: true)
      default:
        break
      }
    case 1:
      if Settings.getEnvironment() == 0 {
        switch indexPath.row {
        case 0:
          buildLabel(cell, label: "Simple Order", value: CYBSMposSettingsLiveSimpleOrderAPIURL)
        case 1:
          buildLabel(cell, label: "Transaction Search", value: CYBSMposSettingsLiveTransactionSearchAPIURL)
        case 2:
          buildLabel(cell, label: "Transaction Detail", value: CYBSMposSettingsLiveTransactionDetailAPIURL)
        case 3:
          buildLabel(cell, label: "Receipt", value: CYBSMposSettingsLiveReceiptAPIURL)
        case 4:
          buildLabel(cell, label: "Substitute Receipt", value: CYBSMposSettingsLiveSubstituteReceiptAPIURL)
        case 5:
          buildLabel(cell, label: "OAuth Token", value: "https://auth.ic3.com/apiauth/v1/oauth/token")
        case 6:
          buildTextField(cell, label: "Simple Order Ver", value: Settings.sharedInstance.simpleOrderAPIVersion, secureTextEntry: false)
        default:
          break
        }
      } else if Settings.getEnvironment() == 1 {
        switch indexPath.row {
        case 0:
          buildLabel(cell, label: "Simple Order", value: CYBSMposSettingsTestSimpleOrderAPIURL)
        case 1:
          buildLabel(cell, label: "Transaction Search", value: CYBSMposSettingsTestTransactionSearchAPIURL)
        case 2:
          buildLabel(cell, label: "Transaction Detail", value: CYBSMposSettingsTestTransactionDetailAPIURL)
        case 3:
          buildLabel(cell, label: "Receipt", value: CYBSMposSettingsTestReceiptAPIURL)
        case 4:
          buildLabel(cell, label: "Substitute Receipt", value: CYBSMposSettingsTestSubstituteReceiptAPIURL)
        case 5:
          buildLabel(cell, label: "OAuth Token", value: "https://authtest.ic3.com/apiauth/v1/oauth/token")
        case 6:
          buildTextField(cell, label: "Simple Order Ver", value: Settings.sharedInstance.simpleOrderAPIVersion, secureTextEntry: false)
        default:
          break
        }
      } else {
      }
    case 2:
      cell.label.text = generatingAccessTokenMethods[indexPath.row];
      if Settings.sharedInstance.generatingAccessTokenMethod == indexPath.row {
        cell.accessoryType = .Checkmark
      }
    case 3:
      switch indexPath.row {
      case 0:
        buildTextField(cell, label: "Terminal ID", value: Settings.sharedInstance.terminalID, secureTextEntry: false)
      case 1:
        buildTextField(cell, label: "Alternate ID", value: Settings.sharedInstance.terminalIDAlternate, secureTextEntry: false)
      case 2:
        buildTextField(cell, label: "MID", value: Settings.sharedInstance.mid, secureTextEntry: false)
      default:
        break
      }
    case 4:
      switch indexPath.row {
      case 0:
        buildTextField(cell, label: "Top Image URL", value: Settings.sharedInstance.topImageURL, secureTextEntry: false)
      case 1:
        buildTextField(cell, label: "Background Color", value: Settings.sharedInstance.backgroundColor, secureTextEntry: false)
      case 2:
        buildTextField(cell, label: "Spinner Color", value: Settings.sharedInstance.spinnerColor, secureTextEntry: false)
      case 3:
        buildTextField(cell, label: "Text Label Color", value: Settings.sharedInstance.textLabelColor, secureTextEntry: false)
      case 4:
        buildTextField(cell, label: "Detail Label Color", value: Settings.sharedInstance.detailLabelColor, secureTextEntry: false)
      case 5:
        buildTextField(cell, label: "Text Field Color", value: Settings.sharedInstance.textFieldColor, secureTextEntry: false)
      case 6:
        buildTextField(cell, label: "Placeholder Color", value: Settings.sharedInstance.placeholderColor, secureTextEntry: false)
      case 7:
        buildTextField(cell, label: "Signature Color", value: Settings.sharedInstance.signatureColor, secureTextEntry: false)
      case 8:
        buildTextField(cell, label: "Signature Bg Color", value: Settings.sharedInstance.signatureBackgroundColor, secureTextEntry: false)
      case 9:
        buildTextField(cell, label: "Tint Color", value: Settings.sharedInstance.tintColor, secureTextEntry: false)
      case 10:
        buildTextField(cell, label: "Ultra Light Font", value: Settings.sharedInstance.ultraLightFont, secureTextEntry: false)
      case 11:
        buildTextField(cell, label: "Thin Font", value: Settings.sharedInstance.thinFont, secureTextEntry: false)
      case 12:
        buildTextField(cell, label: "Light Font", value: Settings.sharedInstance.lightFont, secureTextEntry: false)
      case 13:
        buildTextField(cell, label: "Regular Font", value: Settings.sharedInstance.regularFont, secureTextEntry: false)
      case 14:
        buildTextField(cell, label: "Medium Font", value: Settings.sharedInstance.mediumFont, secureTextEntry: false)
      case 15:
        buildTextField(cell, label: "Semibold Font", value: Settings.sharedInstance.semiboldFont, secureTextEntry: false)
      case 16:
        buildTextField(cell, label: "Bold Font", value: Settings.sharedInstance.boldFont, secureTextEntry: false)
      case 17:
        buildTextField(cell, label: "Heavy Font", value: Settings.sharedInstance.heavyFont, secureTextEntry: false)
      case 18:
        buildTextField(cell, label: "Black Font", value: Settings.sharedInstance.blackFont, secureTextEntry: false)
      default:
        break
      }
    case 5:
      switch indexPath.row {
      case 0:
        buildLabel(cell, label: "Version", value: getVersion())
      case 1:
        buildLabel(cell, label: "Build", value: getBuild())
      default:
        break
      }
    default:
      break
    }
    return cell
  }

  override func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
    switch indexPath.section {
    case 2:
      tableView.cellForRowAtIndexPath(indexPath)?.accessoryType = .Checkmark
      for row in 0...2 {
        if row != indexPath.row {
          tableView.cellForRowAtIndexPath(NSIndexPath(forRow: row, inSection: 2))?.accessoryType = .None
        }
      }
      Settings.sharedInstance.generatingAccessTokenMethod = indexPath.row
      Settings.sharedInstance.save()
    default:
      break
    }
  }

  // MARK: - UITextFieldDelegate

  func textFieldDidBeginEditing(textField: UITextField) {
    pendingTextField = textField
  }

  func textFieldDidEndEditing(textField: UITextField) {
    if pendingTextField != nil {
      updateSetting(textField)
    }
  }

  // MARK: -

  func buildLabel(cell: SettingsTableViewCell, label: String?, value: String?) {
    cell.label.text = label
    cell.valueLabel.text = value
    cell.valueLabel.hidden = false
  }

  func buildOptions(cell: SettingsTableViewCell, label: String?, options: [String], selected: Int) {
    cell.label.text = label
    for (index, option) in options.enumerate() {
      cell.segmentedControl.insertSegmentWithTitle(option, atIndex: index, animated: false)
    }
    cell.segmentedControl.selectedSegmentIndex = selected
    cell.segmentedControl.hidden = false
  }

  func buildTextField(cell: SettingsTableViewCell, label: String?, value: String?, secureTextEntry: Bool) {
    cell.label.text = label
    cell.textField.text = value
    cell.textField.secureTextEntry = secureTextEntry
    cell.textField.hidden = false
    cell.textField.adjustsFontSizeToFitWidth = !secureTextEntry
  }

  func buildUiSwitch(cell: SettingsTableViewCell, label: String?, on: Bool, enable: Bool) {
    cell.label.text = label
    cell.uiSwitch.on = on
    cell.uiSwitch.hidden = false
    cell.uiSwitch.enabled = enable
  }

  func dismissKeyboard() {
    view.endEditing(true)
  }

  func getBuild() -> String? {
    if let dictionary = NSBundle.mainBundle().infoDictionary {
      if let build = dictionary["CFBundleVersion"] as? String {
        return build
      }
    }
    return nil
  }

  func getSenderIndexPath(sender: AnyObject) -> NSIndexPath? {
    if let view = sender as? UIView {
      let point = tableView.convertPoint(CGPoint.zero, fromView: view)
      return tableView.indexPathForRowAtPoint(point)
    }
    return nil
  }

  func getSettingsTableViewCell(tableView: UITableView, forIndexPath: NSIndexPath) -> SettingsTableViewCell {
    let cell = tableView.dequeueReusableCellWithIdentifier("SettingsTableViewCell",
                                                           forIndexPath: forIndexPath) as! SettingsTableViewCell
    cell.accessoryType = .None
    cell.textField.hidden = true
    cell.textField.delegate = self
    cell.segmentedControl.hidden = true
    cell.segmentedControl.removeAllSegments()
    cell.valueLabel.hidden = true
    cell.uiSwitch.hidden = true
    return cell
  }

  func getVersion() -> String? {
    if let dictionary = NSBundle.mainBundle().infoDictionary {
      if let version = dictionary["CFBundleShortVersionString"] as? String {
        return version
      }
    }
    return nil
  }

  func updateSetting(textField: UITextField) {
    pendingTextField = nil
    if let text = textField.text {
      if let indexPath = getSenderIndexPath(textField) {
        switch indexPath.section {
        case 0:
          switch indexPath.row {
          case 1:
            Settings.sharedInstance.merchantID = text
          case 2:
            Settings.sharedInstance.deviceID = text
          case 3:
            Settings.sharedInstance.clientID = text
          case 4:
            Settings.sharedInstance.clientSecret = text
          case 5:
            Settings.sharedInstance.username = text
          case 6:
            Settings.sharedInstance.password = text
          case 7:
            Settings.sharedInstance.accessToken = text
          default:
            break
          }
        case 1:
          if indexPath.row == 6 {
            Settings.sharedInstance.simpleOrderAPIVersion = text
          }
          break
        case 3:
          switch indexPath.row {
          case 0:
            Settings.sharedInstance.terminalID = text
          case 1:
            Settings.sharedInstance.terminalIDAlternate = text
          case 2:
            Settings.sharedInstance.mid = text
          default:
            break
          }
        case 4:
          switch indexPath.row {
          case 0:
            Settings.sharedInstance.topImageURL = text
          case 1:
            Settings.sharedInstance.backgroundColor = text
          case 2:
            Settings.sharedInstance.spinnerColor = text
          case 3:
            Settings.sharedInstance.textLabelColor = text
          case 4:
            Settings.sharedInstance.detailLabelColor = text
          case 5:
            Settings.sharedInstance.textFieldColor = text
          case 6:
            Settings.sharedInstance.placeholderColor = text
          case 7:
            Settings.sharedInstance.signatureColor = text
          case 8:
            Settings.sharedInstance.signatureBackgroundColor = text
          case 9:
            Settings.sharedInstance.tintColor = text
          case 10:
            Settings.sharedInstance.ultraLightFont = text
          case 11:
            Settings.sharedInstance.thinFont = text
          case 12:
            Settings.sharedInstance.lightFont = text
          case 13:
            Settings.sharedInstance.regularFont = text
          case 14:
            Settings.sharedInstance.mediumFont = text
          case 15:
            Settings.sharedInstance.semiboldFont = text
          case 16:
            Settings.sharedInstance.boldFont = text
          case 17:
            Settings.sharedInstance.heavyFont = text
          case 18:
            Settings.sharedInstance.blackFont = text
          default:
            break
          }
        default:
          break
        }
        Settings.sharedInstance.save()
      }
    }
  }

}
