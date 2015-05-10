//
//  DetailEntryController.swift
//  GoogleAd
//
//  Created by Du Limin on 4/19/15.
//  Copyright (c) 2015 GoldenFire.Do. All rights reserved.
//

import WatchKit
import Foundation


class DetailEntryController: WKInterfaceController {
    
    @IBOutlet weak var nameLabel: WKInterfaceLabel!
    @IBOutlet weak var descLabel: WKInterfaceLabel!
    @IBOutlet weak var selectedSwitch: WKInterfaceSwitch!
    
    let defaults = NSUserDefaults.standardUserDefaults()
    let selectedEntryKey = "selectedEntry"
    var data:Entry?
    
    override func awakeWithContext(context: AnyObject?) {
        super.awakeWithContext(context)
        
        // Configure interface objects here.
        data = context as? Entry
    }

    override func willActivate() {
        // This method is called when watch view controller is about to be visible to user
        super.willActivate()
        
        nameLabel.setText(data?.name)
        descLabel.setText(data?.description)
        
        if let selectedEntry = defaults.stringForKey(selectedEntryKey) {
            selectedSwitch.setOn(selectedEntry == data?.name)
        }
    }

    override func didDeactivate() {
        // This method is called when watch view controller is no longer visible
        super.didDeactivate()
    }

    @IBAction func back() {
        popController()
    }
    
    @IBAction func delete() {
        if data != nil {
            var dal = EntryDAL()
            dal.deleteEntry(data!)
            
            var userInfo = ["command" : "Refresh"]
            WKInterfaceController.openParentApplication(userInfo, reply: { (data, error) in
                if let error = error {
                    println(error)
                }
                if let data = data {
                    println(data)
                }
            })
        }
        
        popController()
    }
    
    @IBAction func selectedSwitchValueChanged(value: Bool) {
        if let data = data {
            defaults.removeObjectForKey(selectedEntryKey)
#if !(TARGET_IPHONE_SIMULATOR)
            if !value {
                defaults.setObject(data.name, forKey: selectedEntryKey)
            }
#else
            if value {
                defaults.setObject(data.name, forKey: selectedEntryKey)
            }
#endif
            defaults.synchronize()
        }
    }
}