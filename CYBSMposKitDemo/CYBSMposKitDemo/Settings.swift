//
//  Settings.swift
//  CYBSMposKitDemo
//
//  Created by CyberSource on 6/14/16.
//  Copyright © 2016 CyberSource. All rights reserved.
//

import Foundation

class Settings : NSObject, NSCoding {

  static let sharedInstance = Settings()

  static let environments = ["LIVE", "TEST"]
  static let defaultEnvironment = 1

  var merchantID: String?
  var deviceID: String?
  var clientID: String?
  var clientSecret: String?
  var username: String?
  var password: String?
  var accessToken: String?
  var generatingAccessTokenMethod: Int = 0
  var terminalID: String?
  var terminalIDAlternate: String?
  var mid: String?
  var simpleOrderAPIVersion: String?
  var topImageURL: String?
  var backgroundColor: String?
  var spinnerColor: String?
  var textLabelColor: String?
  var detailLabelColor: String?
  var textFieldColor: String?
  var placeholderColor: String?
  var signatureColor: String?
  var signatureBackgroundColor: String?
  var tintColor: String?
  var ultraLightFont: String?
  var thinFont: String?
  var lightFont: String?
  var regularFont: String?
  var mediumFont: String?
  var semiboldFont: String?
  var boldFont: String?
  var heavyFont: String?
  var blackFont: String?

  required convenience init(settings: Dictionary<String, String>) {
    self.init()
    merchantID = settings["merchantID"]
    deviceID = settings["deviceID"]
    clientID = settings["clientID"]
    clientSecret = settings["clientSecret"]
    username = settings["username"]
    password = settings["password"]
    accessToken = settings["accessToken"]
    generatingAccessTokenMethod = Int(settings["generatingAccessTokenMethod"] ?? "0") ?? 0
    terminalID = settings["terminalID"]
    terminalIDAlternate = settings["terminalIDAlternate"]
    mid = settings["mid"]
    simpleOrderAPIVersion = settings["simpleOrderAPIVersion"]
    topImageURL = settings["topImageURL"]
    backgroundColor = settings["backgroundColor"]
    spinnerColor = settings["spinnerColor"]
    textLabelColor = settings["textLabelColor"]
    detailLabelColor = settings["detailLabelColor"]
    textFieldColor = settings["textFieldColor"]
    placeholderColor = settings["placeholderColor"]
    signatureColor = settings["signatureColor"]
    signatureBackgroundColor = settings["signatureBackgroundColor"]
    tintColor = settings["tintColor"]
    ultraLightFont = settings["ultraLightFont"]
    thinFont = settings["thinFont"]
    lightFont = settings["lightFont"]
    regularFont = settings["regularFont"]
    mediumFont = settings["mediumFont"]
    semiboldFont = settings["semiboldFont"]
    boldFont = settings["boldFont"]
    heavyFont = settings["heavyFont"]
    blackFont = settings["blackFont"]
  }

  required convenience init?(coder aDecoder: NSCoder) {
    self.init()
    merchantID = aDecoder.decodeObjectForKey("merchantID") as? String
    deviceID = aDecoder.decodeObjectForKey("deviceID") as? String
    clientID = aDecoder.decodeObjectForKey("clientID") as? String
    clientSecret = aDecoder.decodeObjectForKey("clientSecret") as? String
    username = aDecoder.decodeObjectForKey("username") as? String
    password = aDecoder.decodeObjectForKey("password") as? String
    accessToken = aDecoder.decodeObjectForKey("accessToken") as? String
    generatingAccessTokenMethod = aDecoder.decodeIntegerForKey("generatingAccessTokenMethod")
    terminalID = aDecoder.decodeObjectForKey("terminalID") as? String
    terminalIDAlternate = aDecoder.decodeObjectForKey("terminalIDAlternate") as? String
    mid = aDecoder.decodeObjectForKey("mid") as? String
    simpleOrderAPIVersion = aDecoder.decodeObjectForKey("simpleOrderAPIVersion") as? String
    topImageURL = aDecoder.decodeObjectForKey("topImageURL") as? String
    backgroundColor = aDecoder.decodeObjectForKey("backgroundColor") as? String
    spinnerColor = aDecoder.decodeObjectForKey("spinnerColor") as? String
    textLabelColor = aDecoder.decodeObjectForKey("textLabelColor") as? String
    detailLabelColor = aDecoder.decodeObjectForKey("detailLabelColor") as? String
    textFieldColor = aDecoder.decodeObjectForKey("textFieldColor") as? String
    placeholderColor = aDecoder.decodeObjectForKey("placeholderColor") as? String
    signatureColor = aDecoder.decodeObjectForKey("signatureColor") as? String
    signatureBackgroundColor = aDecoder.decodeObjectForKey("signatureBackgroundColor") as? String
    tintColor = aDecoder.decodeObjectForKey("tintColor") as? String
    ultraLightFont = aDecoder.decodeObjectForKey("ultraLightFont") as? String
    thinFont = aDecoder.decodeObjectForKey("thinFont") as? String
    lightFont = aDecoder.decodeObjectForKey("lightFont") as? String
    regularFont = aDecoder.decodeObjectForKey("regularFont") as? String
    mediumFont = aDecoder.decodeObjectForKey("mediumFont") as? String
    semiboldFont = aDecoder.decodeObjectForKey("semiboldFont") as? String
    boldFont = aDecoder.decodeObjectForKey("boldFont") as? String
    heavyFont = aDecoder.decodeObjectForKey("heavyFont") as? String
    blackFont = aDecoder.decodeObjectForKey("blackFont") as? String
  }

  func encodeWithCoder(aCoder: NSCoder) {
    aCoder.encodeObject(merchantID, forKey: "merchantID")
    aCoder.encodeObject(deviceID, forKey: "deviceID")
    aCoder.encodeObject(clientID, forKey: "clientID")
    aCoder.encodeObject(clientSecret, forKey: "clientSecret")
    aCoder.encodeObject(username, forKey: "username")
    aCoder.encodeObject(password, forKey: "password")
    aCoder.encodeObject(accessToken, forKey: "accessToken")
    aCoder.encodeInteger(generatingAccessTokenMethod, forKey: "generatingAccessTokenMethod")
    aCoder.encodeObject(terminalID, forKey: "terminalID")
    aCoder.encodeObject(terminalIDAlternate, forKey: "terminalIDAlternate")
    aCoder.encodeObject(mid, forKey: "mid")
    aCoder.encodeObject(simpleOrderAPIVersion, forKey: "simpleOrderAPIVersion")
    aCoder.encodeObject(topImageURL, forKey: "topImageURL")
    aCoder.encodeObject(backgroundColor, forKey: "backgroundColor")
    aCoder.encodeObject(spinnerColor, forKey: "spinnerColor")
    aCoder.encodeObject(textLabelColor, forKey: "textLabelColor")
    aCoder.encodeObject(detailLabelColor, forKey: "detailLabelColor")
    aCoder.encodeObject(textFieldColor, forKey: "textFieldColor")
    aCoder.encodeObject(placeholderColor, forKey: "placeholderColor")
    aCoder.encodeObject(signatureColor, forKey: "signatureColor")
    aCoder.encodeObject(signatureBackgroundColor, forKey: "signatureBackgroundColor")
    aCoder.encodeObject(tintColor, forKey: "tintColor")
    aCoder.encodeObject(ultraLightFont, forKey: "ultraLightFont")
    aCoder.encodeObject(thinFont, forKey: "thinFont")
    aCoder.encodeObject(lightFont, forKey: "lightFont")
    aCoder.encodeObject(regularFont, forKey: "regularFont")
    aCoder.encodeObject(mediumFont, forKey: "mediumFont")
    aCoder.encodeObject(semiboldFont, forKey: "semiboldFont")
    aCoder.encodeObject(boldFont, forKey: "boldFont")
    aCoder.encodeObject(heavyFont, forKey: "heavyFont")
    aCoder.encodeObject(blackFont, forKey: "blackFont")
  }

  func reload() {
    reset()
    let key = Settings.environments[Settings.getEnvironment()].lowercaseString
    let data = KeychainStore.getSecureDataForKey(key)
    if (data != nil) {
      if let settings = NSKeyedUnarchiver.unarchiveObjectWithData(data) as? Settings {
        merchantID = settings.merchantID
        deviceID = settings.deviceID
        clientID = settings.clientID
        clientSecret = settings.clientSecret
        username = settings.username
        password = settings.password
        accessToken = settings.accessToken
        generatingAccessTokenMethod = settings.generatingAccessTokenMethod
        terminalID = settings.terminalID
        terminalIDAlternate = settings.terminalIDAlternate
        mid = settings.mid
        simpleOrderAPIVersion = settings.simpleOrderAPIVersion
        topImageURL = settings.topImageURL
        backgroundColor = settings.backgroundColor
        spinnerColor = settings.spinnerColor
        textLabelColor = settings.textLabelColor
        detailLabelColor = settings.detailLabelColor
        textFieldColor = settings.textFieldColor
        placeholderColor = settings.placeholderColor
        signatureColor = settings.signatureColor
        signatureBackgroundColor = settings.signatureBackgroundColor
        tintColor = settings.tintColor
        ultraLightFont = settings.ultraLightFont
        thinFont = settings.thinFont
        lightFont = settings.lightFont
        regularFont = settings.regularFont
        mediumFont = settings.mediumFont
        semiboldFont = settings.semiboldFont
        boldFont = settings.boldFont
        heavyFont = settings.heavyFont
        blackFont = settings.blackFont
      }
    }
  }

  func reset() {
    merchantID = nil
    deviceID = nil
    clientID = nil
    clientSecret = nil
    username = nil
    password = nil
    accessToken = nil
    generatingAccessTokenMethod = 0
    terminalID = nil
    terminalIDAlternate = nil
    mid = nil
    simpleOrderAPIVersion = nil
    topImageURL = nil
    backgroundColor = nil
    spinnerColor = nil
    textLabelColor = nil
    detailLabelColor = nil
    textFieldColor = nil
    placeholderColor = nil
    signatureColor = nil
    signatureBackgroundColor = nil
    tintColor = nil
    ultraLightFont = nil
    thinFont = nil
    lightFont = nil
    regularFont = nil
    mediumFont = nil
    semiboldFont = nil
    boldFont = nil
    heavyFont = nil
    blackFont = nil
  }

  func save() {
    let key = Settings.environments[Settings.getEnvironment()].lowercaseString
    let data = NSKeyedArchiver.archivedDataWithRootObject(self)
    KeychainStore.storeSecureData(data, forKey: key)
  }

  class func getEnvironment() -> Int {
    let prefs = NSUserDefaults.standardUserDefaults()
    if let environment = prefs.objectForKey("environment") as? Int where environment < environments.count {
      return environment
    }
    return Settings.defaultEnvironment
  }

  class func setEnvironment(environment: Int) {
    let prefs = NSUserDefaults.standardUserDefaults()
    prefs.setValue(environment, forKey: "environment")
  }

}
