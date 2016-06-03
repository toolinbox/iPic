//
//  UploadService.swift
//  UploadImageDemo
//
//  Created by Jason Zheng on 6/3/16.
//  Copyright © 2016 Jason Zheng. All rights reserved.
//

import Cocoa

enum UploadResult {
  case UploadStarted
  case InvalidFilePath
  case InvalidUploadServiceURL
  case UploadServiceNotAvailable
}

class UploadService {
  
  private struct Constants {
    static let UploadImageServiceURL = "iPic:///upload?filePath=%@&callback=%@"
    static let UploadImageCallbackURL = "iPicDemo://%@"
    static let UploadImageCallbackURLPath = "/uploadResult"
    static let UploadImageFilePathKey = "filePath"
    static let UploadImageURLKey = "url"
  }
  
  private var callback = ""
  private var handler: ((filePath: String, url: String?) -> Void)?
  
  static let sharedInstance = UploadService()
  private init() {
    let url = String(format: Constants.UploadImageCallbackURL, Constants.UploadImageCallbackURLPath)
    callback = encodeString(url) ?? url
    
    // Set event handler for URL scheme calls.
    let appleEventManager = NSAppleEventManager.sharedAppleEventManager()
    appleEventManager.setEventHandler(self, andSelector: #selector(self.handleURLSchemeEvent(_:withReplyEvent:)), forEventClass: AEEventClass(kInternetEventClass), andEventID: AEEventID(kAEGetURL))
  }
  
  // MARK: - Public Method
  
  func uploadImage(filePath: String, handler: ((filePath: String, url: String?) -> Void)) -> UploadResult {
    guard let filePath = encodeString(filePath) else {
      return UploadResult.InvalidFilePath
    }
    
    guard let url = NSURL(string: String(format: Constants.UploadImageServiceURL, filePath, callback)) else {
      return UploadResult.InvalidUploadServiceURL
    }
    
    do {
      try NSWorkspace.sharedWorkspace().openURL(url, options: NSWorkspaceLaunchOptions.Default, configuration: [:])
      
      self.handler = handler
      return UploadResult.UploadStarted
      
    } catch {
      // iPic not installed, or not ever run (thus hasn't registered the URL scheme).
      return UploadResult.UploadServiceNotAvailable
    }
  }
  
  // MARK: - Helper
  
  @objc private func handleURLSchemeEvent(event: NSAppleEventDescriptor!, withReplyEvent: NSAppleEventDescriptor!) {
    
    if let urlString = event.paramDescriptorForKeyword(AEKeyword(keyDirectObject))?.stringValue {
      let url = NSURL(string: urlString)
      if let path = url?.path, query = url?.query {
        // Identify the URL scheme path
        if path == Constants.UploadImageCallbackURLPath {
          // Parase the parameters from query and deal with them.
          let paramDict = parseParamsDictFrom(query)
          if let filePath = decodeString(paramDict[Constants.UploadImageFilePathKey]) {
            let url = decodeString(paramDict[Constants.UploadImageURLKey])
            handler?(filePath: filePath, url: url)
          }
        }
      }
    }
  }
  
  private func parseParamsDictFrom(query: String) -> [String: String] {
    var dict = [String: String]()
    let keyValues = query.componentsSeparatedByString("&")
    if keyValues.count > 0 {
      for pair in keyValues {
        let kv = pair.componentsSeparatedByString("=")
        if kv.count > 1 {
          dict.updateValue(kv[1], forKey: kv[0])
        }
      }
    }
    return dict
  }
  
  private func encodeString(str: String?) -> String? {
    return str?.stringByAddingPercentEncodingWithAllowedCharacters(.URLQueryAllowedCharacterSet())?
      .stringByReplacingOccurrencesOfString("&", withString: "%26")
      .stringByReplacingOccurrencesOfString("=", withString: "%3d")
  }
  
  private func decodeString(str: String?) -> String? {
    return str?.stringByRemovingPercentEncoding
  }
}
