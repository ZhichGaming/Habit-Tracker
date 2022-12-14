//
//  ContentView.swift
//  Habit Tracker
//
//  Created by Nick on 2022-09-11.
//

import SwiftUI

struct ContentView: View {
    @StateObject var activities = Activities()
    @State var showingSheet = false
    
    var body: some View {
        NavigationView {
            GeometryReader { geo in
                
                List {
                    if !activities.activities.isEmpty {
                        ForEach(activities.activities) { activity in
                            NavigationLink {
                                ActivityView(activities: activities, activity: activity)
                            } label: {
                                HStack(spacing: 0){
                                    VStack(alignment: .leading) {
                                        Text(activity.name)
                                            .font(.headline)
                                        Text("Last completed: \(activity.formattedDate)")
                                            .foregroundColor(.secondary)
                                    }
                                    Spacer()
                                    Text(activity.type == "Other" ? activity.customType : activity.type)
                                }
                            }
                        }
                    } else {
                        VStack {
                            Image(systemName: "calendar.badge.clock")
                                .resizable()
                                .scaledToFit()
                                .frame(maxWidth: 0.25 * geo.size.width)
                                .symbolRenderingMode(.palette)
                                .foregroundStyle(.black, .blue)
                                .padding()
                            
                            Text("Welcome to Habit Tracker! Add activities with the button on the top right corner to get started.")
                                .multilineTextAlignment(.center)
                                .padding(.bottom)
                        }
                    }
                }
                .navigationTitle("Habit Tracker")
                .sheet(isPresented: $showingSheet) {
                    AddHabitView(activities: activities)
                }
                .toolbar {
                    ToolbarItem {
                        Button() {
                            showingSheet = true
                        } label: {
                            Image(systemName: "plus")
                        }
                    }
                }
            }
        }
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
