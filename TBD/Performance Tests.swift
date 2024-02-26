//
//  Performance Tests.swift
//  CentriFugue_trial
//
//  Created by Graham Nadel on 2/22/24.
//

import Foundation
import UIKit
//import XCTest

class Test: ObservableObject {

    // For when you use too much state in a list:
        // 1. make it so that each list item depends on one Any.type
    //2. Batching updates at regular intervals
    //    alternative to @Published var. Need to look into how to use it
    private var scheduledUpdate = false
    
    var images = [String: UIImage]() {
        willSet {
            if !scheduledUpdate {
                scheduledUpdate = true
                DispatchQueue.main.asyncAfter(deadline: .now() + 1.0) { [weak self] in
                    self?.objectWillChange.send()
                    self?.scheduledUpdate = false
                }
            }
        }
    }
    
//    BECOME FASTER BY NEVER GETTING SLOWER
    
//    func testScrollingAnimationPerformance() throws {
//        app.launch()
//        app.staticTexts["Demo App"].tap()
//        let messageList = app.collectionViews.firstMatch
//        
//        let measureOptions = XCTMeasureOptions()
//        measureOptions.invocationOptions = [.manuallyStop]
//        
//        measure(metrics: [XCTOSSignpostMetric.scrollDecelerationMetric],
//                options: measureOptions) {
//            messageList.swipeUp(velocity: .fast)
//            stopMeasuring()
//            messageList.swipeDown(velocity: .fast)
//        }
//    }
    
}
