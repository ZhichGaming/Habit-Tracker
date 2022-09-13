//
//  AddHabitView.swift
//  Habit Tracker
//
//  Created by Nick on 2022-09-11.
//

import SwiftUI

struct AddHabitView: View {
    @ObservedObject var activities: Activities
    @Environment(\.dismiss) var dismiss

    let types = ["Learning", "Exercising", "Music", "Other"]
    @State var type = "Learning"
    @State var name = ""
    @State var description = ""
    @State var customType = ""

    var body: some View {
        NavigationView {
            List {
                Section {
                    TextField("Activity name", text: $name)
                    TextField("Description", text: $description)
                } header: {
                    Text("Activity details")
                }
                
                Section {
                    Picker("Activity type", selection: $type) {
                        ForEach(types, id: \.self) {
                            Text("\($0)")
                        }
                    }
                    if type == "Other" {
                        TextField("Custom activity type", text: $customType)
                    }
                } header: {
                    Text("Activity type")
                }
                
            }
            .navigationTitle("Add activity")
            .toolbar {
                Button("Add activity") {
                    let activity = Activity(name: name, description: description, type: type, customType: customType)
                    activities.activities.append(activity)
                    dismiss()
                }
            }
        }
    }
}

struct AddHabitView_Previews: PreviewProvider {
    static var previews: some View {
        AddHabitView(activities: Activities())
    }
}
