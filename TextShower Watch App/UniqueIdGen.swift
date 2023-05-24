//
//  UniqueIdGen.swift
//  TextShower Watch App
//
//  Created by Gal Podlipnik on 24/05/2023.
//

import WatchKit
import Foundation

func getDeviceIdentifier() -> String {
    if let identifier = WKInterfaceDevice.current().identifierForVendor {
        let deviceIdentifier = identifier.uuidString
        let cleanedIdentifier = deviceIdentifier.replacingOccurrences(of: "-", with: "")
        return cleanedIdentifier
    }
    fatalError("Device identifier is unavailable.")
}

