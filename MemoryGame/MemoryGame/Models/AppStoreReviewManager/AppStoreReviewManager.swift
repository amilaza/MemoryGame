//
//  AppStoreReviewManager.swift
//  MemoryGame
//
//  Created by Nguyen Ba Linh on 4/21/19.
//  Copyright © 2019 Nguyen Ba Linh. All rights reserved.
//

import Foundation
import StoreKit

enum AppStoreReviewManager {
    static let minimumReviewWorthyActionCount = 3
    
    static func requestReviewIfAppropriate() {
//        let defaults = UserDefaults.standard
        let bundle = Bundle.main
//
//        var actionCount = UserDefaults.standard.integer(forKey: "reviewWorthyActionCount")
//        actionCount += 1
//        defaults.set(actionCount, forKey: "reviewWorthyActionCount")
//        
//        guard actionCount >= minimumReviewWorthyActionCount else {
//            return
//        }
//        
        let bundleVersionKey = kCFBundleVersionKey as String
        let currentVersion = bundle.object(forInfoDictionaryKey: bundleVersionKey) as? String
        let lastVersion = UserDefaults.standard.string(forKey: "lastReviewRequestAppVersion")
        
        guard lastVersion == nil || lastVersion != currentVersion else {
            return
        }
        
        SKStoreReviewController.requestReview()
        
        UserDefaults.standard.set(0, forKey: "reviewWorthyActionCount")
        UserDefaults.standard.set(currentVersion, forKey: "lastReviewRequestAppVersion")
    }
}
