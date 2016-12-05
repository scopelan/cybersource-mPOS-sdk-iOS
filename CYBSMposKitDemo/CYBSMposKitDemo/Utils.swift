//
//  Utils.swift
//  CYBSMposKitDemo
//
//  Created by CyberSource on 7/26/16.
//  Copyright © 2016 CyberSource. All rights reserved.
//

import UIKit

import CocoaLumberjackSwift

class Cache: NSObject {
  var expiration: NSTimeInterval = 0
  var value: AnyObject?
}

class Utils: NSObject, NSURLSessionDelegate {

  static let defaultSettings: Dictionary<String, Dictionary<String, String>> = [:]

  static let cache = NSCache()

  func URLSession(session: NSURLSession, didReceiveChallenge challenge: NSURLAuthenticationChallenge,
                  completionHandler: (NSURLSessionAuthChallengeDisposition, NSURLCredential?) -> Void) {
    completionHandler(.PerformDefaultHandling, NSURLCredential(trust: challenge.protectionSpace.serverTrust!))
  }

  class func createAccessToken(completionHandler:(accessToken: String?, error: NSError?) -> Void) {
    let accessToken = Settings.sharedInstance.accessToken ?? ""

    if Settings.sharedInstance.generatingAccessTokenMethod == 2 {
      completionHandler(accessToken: accessToken, error: nil)
      return
    }

    if let accessTokenCache = cache.objectForKey("accessToken") as? Cache where accessTokenCache.expiration >= NSDate().timeIntervalSince1970 {
      if let accessToken = accessTokenCache.value as? String {
        DDLogDebug("found access token in cache: \(accessToken)")
        completionHandler(accessToken: accessToken, error: nil)
        return
      }
    }

    let headers = [
      "cache-control": "no-cache",
      "content-type": "application/x-www-form-urlencoded"
    ]

    let createTokenRequest = createGeneratingAccessTokenRequest()

    DDLogDebug("create token request: \(createTokenRequest)")

    let request = NSMutableURLRequest(URL: getGeneratingAccessTokenURL(),
                                      cachePolicy: .UseProtocolCachePolicy,
                                      timeoutInterval: 10.0)

    request.HTTPMethod = "POST"
    request.allHTTPHeaderFields = headers
    request.HTTPBody = createTokenRequest.dataUsingEncoding(NSUTF8StringEncoding)

    let configuration = NSURLSessionConfiguration.defaultSessionConfiguration()
    let session = NSURLSession(configuration: configuration, delegate: Utils(), delegateQueue: nil)
    let dataTask = session.dataTaskWithRequest(request, completionHandler: { (data, response, error) -> Void in
      if error != nil {
        dispatch_async(dispatch_get_main_queue()) {
          completionHandler(accessToken: nil, error: error)
        }
        return
      }
      if let httpResponse = response as? NSHTTPURLResponse {
        if httpResponse.statusCode == 200 {
          do {
            let json = try NSJSONSerialization.JSONObjectWithData(data!, options: [])
            DDLogDebug("create token response: \(json)")
            if let accessToken = json["access_token"] as? String {
              let accessTokenCache = Cache()
              accessTokenCache.expiration = NSDate().timeIntervalSince1970 + 240
              accessTokenCache.value = accessToken
              cache.setObject(accessTokenCache, forKey: "accessToken")
              dispatch_async(dispatch_get_main_queue()) {
                completionHandler(accessToken: accessToken, error: nil)
              }
            } else {
              dispatch_async(dispatch_get_main_queue()) {
                completionHandler(accessToken: nil, error: NSError(domain: "CYBSMposKitDemoError", code: 101,
                  userInfo: ["message": "Failed to get the access token"]))
              }
            }
          } catch {
            dispatch_async(dispatch_get_main_queue()) {
              completionHandler(accessToken: nil, error: NSError(domain: "CYBSMposKitDemoError", code: 102,
                userInfo: ["message": "Failed to parse the JSON response"]))
            }
          }
        } else {
          var message: String
          do {
            let json = try NSJSONSerialization.JSONObjectWithData(data!, options: [])
            print(json)
            if let errorDescription = json["error_description"] as? String {
              message = errorDescription
            } else {
              message = "http status: \(httpResponse.statusCode) response: " +
                (NSString(data: data!, encoding: NSUTF8StringEncoding)! as String)
            }
          } catch {
            message = "http status: \(httpResponse.statusCode)"
          }
          dispatch_async(dispatch_get_main_queue()) {
            completionHandler(accessToken: nil, error: NSError(domain: "CYBSMposKitDemoError", code: 103,
              userInfo: ["message": message]))
          }
        }
      }
    })

    dataTask.resume()
  }

  class func getManager() -> CYBSMposManager {
    let settings = getSettings()
    settings.terminalID = Settings.sharedInstance.terminalID ?? ""
    settings.terminalIDAlternate = Settings.sharedInstance.terminalIDAlternate ?? ""
    settings.mid = Settings.sharedInstance.mid ?? ""
    settings.simpleOrderAPIVersion = Settings.sharedInstance.simpleOrderAPIVersion ?? ""
    let manager = CYBSMposManager(settings: settings)
    if let topImageURL = Settings.sharedInstance.topImageURL where !topImageURL.isEmpty {
      if let imageURL = NSURL(string: topImageURL) {
        if let imageData = NSData(contentsOfURL: imageURL) {
          manager.uiSettings.topImage = UIImage(data: imageData)
        }
      }
    }
    manager.uiSettings.backgroundColor = getUIColor(Settings.sharedInstance.backgroundColor)
    manager.uiSettings.tintColor = getUIColor(Settings.sharedInstance.tintColor) ?? UIApplication.sharedApplication().delegate?.window??.rootViewController?.view.tintColor;
    manager.uiSettings.spinnerColor = getUIColor(Settings.sharedInstance.spinnerColor)
    manager.uiSettings.textLabelColor = getUIColor(Settings.sharedInstance.textLabelColor)
    manager.uiSettings.detailTextLabelColor = getUIColor(Settings.sharedInstance.detailLabelColor)
    manager.uiSettings.textFieldColor = getUIColor(Settings.sharedInstance.textFieldColor)
    manager.uiSettings.textFieldPlaceholderColor = getUIColor(Settings.sharedInstance.placeholderColor)
    manager.uiSettings.signatureColor = getUIColor(Settings.sharedInstance.signatureColor)
    manager.uiSettings.signatureBackgroundColor = getUIColor(Settings.sharedInstance.signatureBackgroundColor)
    manager.uiSettings.ultraLightFontName = Settings.sharedInstance.ultraLightFont
    manager.uiSettings.thinFontName = Settings.sharedInstance.thinFont
    manager.uiSettings.lightFontName = Settings.sharedInstance.lightFont
    manager.uiSettings.regularFontName = Settings.sharedInstance.regularFont
    manager.uiSettings.mediumFontName = Settings.sharedInstance.mediumFont
    manager.uiSettings.semiboldFontName = Settings.sharedInstance.semiboldFont
    manager.uiSettings.boldFontName = Settings.sharedInstance.boldFont
    manager.uiSettings.heavyFontName = Settings.sharedInstance.heavyFont
    manager.uiSettings.blackFontName = Settings.sharedInstance.blackFont
    return manager;
  }

  class func getUIColor(hex: String?) -> UIColor? {
    if let hex = hex where !hex.isEmpty {
      let scanner = NSScanner(string: hex)
      var color: UInt32 = 0
      scanner.scanHexInt(&color)
      let mask = 0x000000FF
      let r = CGFloat(Float(Int(color >> 16) & mask) / 255.0)
      let g = CGFloat(Float(Int(color >> 8) & mask) / 255.0)
      let b = CGFloat(Float(Int(color) & mask) / 255.0)
      return UIColor(red: r, green: g, blue: b, alpha: CGFloat(1.0))
    }
    return nil
  }

  private class func createGeneratingAccessTokenRequest() -> String {
    let urlComponents = NSURLComponents()

    let platform = NSURLQueryItem(name: "platform", value: "1")
    let deviceID = NSURLQueryItem(name: "device_id", value: Settings.sharedInstance.deviceID ?? "")
    let merchantID = NSURLQueryItem(name: "merchant_id", value: Settings.sharedInstance.merchantID ?? "")
    let clientID = NSURLQueryItem(name: "client_id", value: Settings.sharedInstance.clientID ?? "")

    if Settings.sharedInstance.generatingAccessTokenMethod == 0 {
      let grantType = NSURLQueryItem(name: "grant_type", value: "client_credentials")
      let clientSecret = NSURLQueryItem(name: "client_secret", value: Settings.sharedInstance.clientSecret ?? "")
      urlComponents.queryItems = [platform, grantType, deviceID, merchantID, clientID, clientSecret];
    } else {
      let grantType = NSURLQueryItem(name: "grant_type", value: "password")
      let username = NSURLQueryItem(name: "username", value: Settings.sharedInstance.username ?? "")
      let password = NSURLQueryItem(name: "password", value: Settings.sharedInstance.password ?? "")
      urlComponents.queryItems = [platform, grantType, deviceID, merchantID, clientID, username, password];
    }

    return urlComponents.URL!.query!
  }

  private class func getSettings() -> CYBSMposSettings {
    let deviceID = Settings.sharedInstance.deviceID ?? ""
    switch Settings.getEnvironment() {
    case 0:
      return CYBSMposSettings(environment: .Live, deviceID: deviceID)
    case 1:
      return CYBSMposSettings(environment: .Test, deviceID: deviceID)
    default:
      return CYBSMposSettings(environment: .Test, deviceID: deviceID)
    }
  }

  private class func getGeneratingAccessTokenURL() -> NSURL {
    switch Settings.getEnvironment() {
    case 0:
      return NSURL(string: "https://auth.ic3.com/apiauth/v1/oauth/token")!
    case 1:
      return NSURL(string: "https://authtest.ic3.com/apiauth/v1/oauth/token")!
    default:
      return NSURL(string: "https://authtest.ic3.com/apiauth/v1/oauth/token")!
    }
  }

  class func initSettings() {
    for environment in Settings.environments {
      if (KeychainStore.getSecureDataForKey(environment.lowercaseString) == nil) {
        if let defaultSettings = defaultSettings[environment.lowercaseString] {
          save(Settings(settings: defaultSettings), environment: environment)
        } else {
          save(Settings(), environment: environment)
        }
      }
    }
    let prefs = NSUserDefaults.standardUserDefaults()
    if (prefs.objectForKey("environment") as? Int) == nil {
      prefs.setValue(Settings.defaultEnvironment, forKey: "environment")
    }
  }

  class func resetSettings() {
    for environment in Settings.environments {
      KeychainStore.deleteKeychainValue(environment.lowercaseString)
    }
    let prefs = NSUserDefaults.standardUserDefaults()
    prefs.setObject(nil, forKey: "environment")
    initSettings()
  }

  private class func save(settings: Settings, environment: String) {
    let data = NSKeyedArchiver.archivedDataWithRootObject(settings)
    KeychainStore.storeSecureData(data, forKey: environment.lowercaseString)
  }

}
