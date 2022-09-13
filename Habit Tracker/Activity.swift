//
//  Activity.swift
//  Habit Tracker
//
//  Created by Nick on 2022-09-11.
//

import Foundation

struct Activity: Codable, Identifiable {
    var id = UUID()
    var name: String
    var description: String
    var type: String
    var customType: String {
        didSet {
            if type != "Other" {
                customType = ""
            }
        }
    }
}
