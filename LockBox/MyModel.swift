import Foundation
import FamilyControls
import ManagedSettings
import UIKit
import ManagedSettingsUI

private let _MyModel = MyModel()

class MyModel: ObservableObject {
    let store = ManagedSettingsStore()
    
    @Published var selectionToDiscourage: FamilyActivitySelection
    @Published var selectionToEncourage: FamilyActivitySelection
    @Published var remainingTime: TimeInterval = 0 // Added for timer functionality
    var timer: Timer? // Added for timer functionality
    
    init() {
        selectionToDiscourage = FamilyActivitySelection()
        selectionToEncourage = FamilyActivitySelection()
    }
    
    class var shared: MyModel {
        return _MyModel
    }
    
    func setShieldRestrictions() {
        store.shield.applications = selectionToDiscourage.applicationTokens.isEmpty ? nil : selectionToDiscourage.applicationTokens
        store.shield.applicationCategories = selectionToDiscourage.categoryTokens.isEmpty ? nil : ShieldSettings.ActivityCategoryPolicy.specific(selectionToDiscourage.categoryTokens)
        
        // Apply the application configuration as needed
    }
    
    // Function to start the timer with a given duration
    func startLimitationTimer(duration: TimeInterval) {
        remainingTime = duration
        timer = Timer.scheduledTimer(withTimeInterval: 1, repeats: true) { _ in
            if self.remainingTime > 0 {
                self.remainingTime -= 1
            } else {
                self.timer?.invalidate() // Invalidate the timer when time is up
                self.resetDiscouragedItems()
            }
        }
    }
    
    // Function to stop the timer
    func stopTimer() {
        timer?.invalidate()
    }
    
    func resetDiscouragedItems() {
            selectionToDiscourage = FamilyActivitySelection()
            setShieldRestrictions() // Apply the changes immediately
        }
}

