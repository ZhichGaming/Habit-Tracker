//
//  ActivityView.swift
//  Habit Tracker
//
//  Created by Nick on 2022-09-13.
//

import SwiftUI


struct ActivityView: View {
    @ObservedObject var activities: Activities
    @State var activity: Activity

    var body: some View {
        GeometryReader { geo in
            VStack(alignment: .leading) {
                Group {
                    HStack(alignment: .bottom) {
                        VStack(alignment: .leading) {
                            Text(activity.name)
                                .font(.largeTitle)
                            Text(activity.type == "Other" ? activity.customType : activity.type)
                                .font(.headline)
                        }
                        Spacer()
                        VStack(alignment: .trailing) {
                            Text("Last completed")
                            Text(activity.formattedDate)
                        }
                        .font(.caption)
                    }
                    Text(activity.description)
                }
                .padding([.horizontal, .top])
                Divider()
                
                ZStack {
                    if !activity.completions.isEmpty {
                        List {
                            Section {
                                ForEach(activity.completions, id: \.self) { completion in
                                    HStack {
                                        Text("\(completion.formatted(date: .abbreviated, time: .shortened))")
                                        Spacer()
                                        Text("#\(activity.completions.count - activity.completions.firstIndex(of: completion)!)")
                                            .foregroundColor(.secondary)
                                    }
                                }
                                .onDelete(perform: delete)
                            } header: {
                                Text("Completions")
                            }
                        }
                    } else {
                        List {
                            VStack {
                                Image(systemName: "clock.badge.checkmark")
                                    .resizable()
                                    .scaledToFit()
                                    .frame(maxWidth: 0.25 * geo.size.width)
                                    .symbolRenderingMode(.palette)
                                    .foregroundStyle(.black, .blue)
                                    .padding()
                                
                                Text("Press the complete button to mark a task as completed once. Delete completed occurances by swiping them from the right. ")
                                    .multilineTextAlignment(.center)
                                    .padding(.bottom)
                            }
                        }
                    }
                }
                .animation(.default, value: activity.completions.isEmpty)
                VStack {
                    Spacer()
                    ZStack {
                        Rectangle()
                            .foregroundColor(.white)

                        Button() {
                            var index: Int {
                                for i in 0..<activities.activities.count {
                                    if activities.activities[i] == activity {
                                        return i
                                    }
                                }
                                return 0
                            }
                            
                            withAnimation {
                                activity.completions.insert(Date.now, at: 0)
                                activities.activities[index].completions.insert(Date.now, at: 0)
                            }
                        } label: {
                            ZStack {
                                RoundedRectangle(cornerRadius: 15)
                                Text("Complete")
                                    .foregroundColor(.white)
                            }
                        }
                        .frame(maxHeight: 60)
                        .padding()
                    }
                }
                .ignoresSafeArea()
                .frame(maxHeight: 100)
            }
        }
        .navigationBarTitleDisplayMode(.inline)
    }
    
    func delete(at offsets: IndexSet) {
        activity.completions.remove(atOffsets: offsets)
    }
}

struct ActivityView_Previews: PreviewProvider {

    static var previews: some View {
        let activity = Activity(name: "Name", description: "A totaly 100% pure normal test. ", type: "Other", customType: "Type")
        let activities = Activities()

        ActivityView(activities: activities, activity: activity)
    }
}
