//
//  MainWindowController.swift
//  UploadImageDemo
//
//  Created by Jason Zheng on 6/2/16.
//  Copyright © 2016 Jason Zheng. All rights reserved.
//

import Cocoa

class MainWindowController: NSWindowController {
  
  @IBOutlet var urlTextView: NSTextView!
  @IBOutlet weak var waitingIndicator: NSProgressIndicator!
  
  override var windowNibName: String? {
    return "MainWindowController"
  }
  
  override func windowDidLoad() {
    super.windowDidLoad()
    
    urlTextView.alignment = .Center
  }
  
  // MARK: - Action
  
  @IBAction func uploadImage(sender: NSButton!) {
    displayStringInURLTextView("", color: NSColor.controlTextColor())
    
    let openPanel = NSOpenPanel()
    openPanel.canChooseDirectories = false
    openPanel.canChooseFiles = true
    openPanel.prompt = NSLocalizedString("Select", comment: "Open Panel")
    
    openPanel.beginSheetModalForWindow(self.window!) { (response) in
      if response == NSFileHandlingPanelOKButton {
        if let filePath = openPanel.URL?.path {
          let result = UploadService.sharedInstance.uploadImage(filePath, handler: self.dealWithUploadResult)
          switch result {
          case .UploadStarted:
            self.waitingIndicator.startAnimation(self)
            
          case .UploadServiceNotAvailable:
            self.displayStringInURLTextView("iPic not available.", color: NSColor.redColor())
            
          case .InvalidFilePath:
            self.displayStringInURLTextView("Invalid file: \(filePath)", color: NSColor.redColor())
            
          case .InvalidUploadServiceURL:
            self.displayStringInURLTextView("Invalid upload service url.", color: NSColor.redColor())
          }
        }
      }
    }
  }
  
  // MARK: - Helper
  
  func dealWithUploadResult(filePath: String, url: String?) {
    let attrStr: NSAttributedString
    
    if let url = url {
      // Uploaded succeed, has url for image.
      let attrs = [NSLinkAttributeName: NSString(string: url)]
      attrStr = NSAttributedString(string: url, attributes: attrs)
      
    } else {
      // Uploaded failed, doesn't have url for image.
      let attrs = [NSForegroundColorAttributeName: NSColor.redColor()]
      attrStr = NSAttributedString(string: "Upload Failed", attributes: attrs)
    }
    
    if let textStorage = urlTextView.textStorage {
      textStorage.replaceCharactersInRange(NSRange(0..<textStorage.length), withAttributedString: attrStr)
    }
    
    waitingIndicator.stopAnimation(self)
  }
  
  func displayStringInURLTextView(str: String, color: NSColor) {
    if let textStorage = urlTextView.textStorage {
      let attrs = [NSForegroundColorAttributeName: NSColor.redColor()]
      let attrStr = NSAttributedString(string: str, attributes: attrs)
      textStorage.replaceCharactersInRange(NSRange(0..<textStorage.length), withAttributedString: attrStr)
    }
  }
}
