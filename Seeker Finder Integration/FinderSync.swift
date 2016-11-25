//
//  FinderSync.swift
//  Seeker Finder Integration
//
//  Created by Yuhuan Jiang on 11/24/16.
//  Copyright © 2016 Yuhuan Jiang. All rights reserved.
//

import Cocoa
import FinderSync

class FinderSync: FIFinderSync {

    var myFolderURL = URL(fileURLWithPath: "/Users/Shared/FinderSyncDemo")
    
    override init() {
        super.init()
        
        NSLog("FinderSync() launched from %@", Bundle.main.bundlePath as NSString)
        
        // Set up the directory we are syncing.
        FIFinderSyncController.default().directoryURLs = [self.myFolderURL]
        
        // Set up images for our badge identifiers. For demonstration purposes, this uses off-the-shelf images.
        FIFinderSyncController.default().setBadgeImage(NSImage(named: NSImageNameColorPanel)!, label: "Status One" , forBadgeIdentifier: "One")
        FIFinderSyncController.default().setBadgeImage(NSImage(named: NSImageNameCaution)!, label: "Status Two", forBadgeIdentifier: "Two")
    }
    
    // MARK: - Primary Finder Sync protocol methods
    
    override func beginObservingDirectory(at url: URL) {
        // The user is now seeing the container's contents.
        // If they see it in more than one view at a time, we're only told once.
        NSLog("beginObservingDirectoryAtURL: %@", url.path as NSString)
    }
    
    
    override func endObservingDirectory(at url: URL) {
        // The user is no longer seeing the container's contents.
        NSLog("endObservingDirectoryAtURL: %@", url.path as NSString)
    }
    
    override func requestBadgeIdentifier(for url: URL) {
        NSLog("requestBadgeIdentifierForURL: %@", url.path as NSString)
        
        // For demonstration purposes, this picks one of our two badges, or no badge at all, based on the filename.
        let whichBadge = abs(url.path.hash) % 3
        let badgeIdentifier = ["", "One", "Two"][whichBadge]
        FIFinderSyncController.default().setBadgeIdentifier(badgeIdentifier, for: url)
    }
    
    // MARK: - Menu and toolbar item support
    
    override var toolbarItemName: String {
        return "FinderSy"
    }
    
    override var toolbarItemToolTip: String {
        return "FinderSy: Click the toolbar item for a menu."
    }
    
    override var toolbarItemImage: NSImage {
        return NSImage(named: NSImageNameCaution)!
    }
    
    func ImagedMenuItem(img: NSImage?, title: String, action: Selector?, keyEquivalent: String) -> NSMenuItem {
        let itm = NSMenuItem(title: title, action: action, keyEquivalent: keyEquivalent)
        if img != nil {
            itm.image = img!
        }
        return itm
    }
    
    func iconOfApp(withAppName appName: String) -> NSImage? {
        return iconOfApp(withPathToBundle: "/Applications/" + appName + ".app")
    }
    
    func iconOfApp(withPathToBundle bundlePath: String) -> NSImage? {
        let icon = NSWorkspace.shared().icon(forFile: bundlePath)
        return icon
    }
    
    override func menu(for menuKind: FIMenuKind) -> NSMenu {
        let menu = NSMenu(title: "")

        //let curDir = FIFinderSyncController.default().targetedURL()
        let selectedItems = FIFinderSyncController.default().selectedItemURLs()

        
        // The menu will only be triggered on a directory
        
        if selectedItems?.count == 1 {
            let selectedItem = selectedItems!.first!.path
            if FileIO.isDirectory(path: selectedItem) {
                let curDir = selectedItem
                // ADD METHODS FOR OPENING THE FOLDER
                
                // .idea/ exists? Show "Open with IntelliJ IDEA" // TODO: differentiate IDEA/PyCharm/PHPStorm/AppCode/CLion
                if FileIO.exists(path: curDir + "/.idea/") {
                    menu.addItem(ImagedMenuItem(img: iconOfApp(withAppName: "IntelliJ IDEA"), title: "Open with IntelliJ IDEA", action: nil, keyEquivalent: ""))
                }
                
                // .git/ exists? Show "Open on GitHub/BitBucket" if there is such origin
                if FileIO.exists(path: curDir + "/.git/") {
                    // TODO: Detect in the text file .git/description whether there is an remote named origin. Determin GitHub/BitBucket. Use that URL.
                    menu.addItem(ImagedMenuItem(img: NSImage(named: "github.pdf"), title: "Open on GitHub", action: nil, keyEquivalent: ""))
                }
                
                // ADD GROUPS OF OPERATIONS THAT CAN BE DONE ON THE CONTENT OF THIS FOLDER
                if FileIO.exists(path: curDir + "/build.sbt") {
                    let sbtMenuItem = NSMenuItem(title: "SBT", action: nil, keyEquivalent: "")
                    let sbtMenu = NSMenu(title: "SBT Menu")
                    sbtMenu.addItem(NSMenuItem(title: "Publish Signed", action: nil, keyEquivalent: ""))
                    sbtMenu.addItem(NSMenuItem(title: "Assembly", action: nil, keyEquivalent: ""))
                    sbtMenu.addItem(NSMenuItem(title: "Compile", action: nil, keyEquivalent: ""))
                    sbtMenu.addItem(NSMenuItem(title: "Run", action: nil, keyEquivalent: ""))
                    sbtMenu.addItem(NSMenuItem(title: "Clean", action: nil, keyEquivalent: ""))
                    menu.setSubmenu(sbtMenu, for: sbtMenuItem)
                    menu.addItem(sbtMenuItem)
                }
                
                if FileIO.exists(path: curDir + "/.git/") {
                    let gitMenuItem = NSMenuItem(title: "Git", action: nil, keyEquivalent: "")
                    let gitMenu = NSMenu(title: "Git Menu")
                    gitMenu.addItem(NSMenuItem(title: "Commit...", action: nil, keyEquivalent: ""))
                    gitMenu.addItem(NSMenuItem(title: "Push", action: nil, keyEquivalent: ""))
                    menu.setSubmenu(gitMenu, for: gitMenuItem)
                    menu.addItem(gitMenuItem)
                }
                
                if FileIO.exists(path: curDir + "/Package.swift") {
                    let gitMenuItem = NSMenuItem(title: "SwiftPM", action: nil, keyEquivalent: "")
                    let gitMenu = NSMenu(title: "SwiftPM Menu")
                    gitMenu.addItem(NSMenuItem(title: "Build", action: nil, keyEquivalent: ""))
                    gitMenu.addItem(NSMenuItem(title: "Refresh", action: nil, keyEquivalent: ""))
                    gitMenu.addItem(NSMenuItem(title: "Create Xcode Project", action: nil, keyEquivalent: ""))
                    menu.setSubmenu(gitMenu, for: gitMenuItem)
                    menu.addItem(gitMenuItem)
                }

            }
        }
        
        return menu
    }
    
    @IBAction func sampleAction(_ sender: AnyObject?) {
        let target = FIFinderSyncController.default().targetedURL()
        let items = FIFinderSyncController.default().selectedItemURLs()
        
        let item = sender as! NSMenuItem
        NSLog("sampleAction: menu item: %@, target = %@, items = ", item.title as NSString, target!.path as NSString)
        for obj in items! {
            NSLog("    %@", obj.path as NSString)
        }
    }

}

