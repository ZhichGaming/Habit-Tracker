//
//  Activities.swift
//  Habit Tracker
//
//  Created by Nick on 2022-09-11.
//

import Foundation

class Activities: ObservableObject {
    @Published var activities = [Activity]() {
        didSet {
            let encoder = JSONEncoder()
            
            if let encoded = try? encoder.encode(activities) {
                UserDefaults.standard.set(encoded, forKey: "Activities")
            }
        }
    }
    
    init() {
        if let savedItems = UserDefaults.standard.data(forKey: "Activities") {
            if let decodedItems = try? JSONDecoder().decode([Activity].self, from: savedItems) {
                activities = decodedItems
                return
            }
        }
        
        activities = []
    }
}
