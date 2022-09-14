//
//  ActivityView.swift
//  Habit Tracker
//
//  Created by Nick on 2022-09-13.
//

import SwiftUI

struct LineView: View {
  var dataPoints: [Double]

  var highestPoint: Double {
    let max = dataPoints.max() ?? 1.0
    if max == 0 { return 1.0 }
    return max
  }

  var body: some View {
    GeometryReader { geometry in
      let height = geometry.size.height
      let width = geometry.size.width

      Path { path in
        path.move(to: CGPoint(x: 0, y: height * self.ratio(for: 0)))

        for index in 1..<dataPoints.count {
          path.addLine(to: CGPoint(
            x: CGFloat(index) * width / CGFloat(dataPoints.count - 1),
            y: height * self.ratio(for: index)))
        }
      }
      .stroke(Color.accentColor, style: StrokeStyle(lineWidth: 2, lineJoin: .round))
    }
    .padding(.vertical)
  }

  private func ratio(for index: Int) -> Double {
    1 - (dataPoints[index] / highestPoint)
  }
}

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
                                        Text("#\(1 + activity.completions.firstIndex(of: completion)!)")
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
            }
            .overlay(
                VStack {
                    Spacer()
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
                            activity.completions.append(Date.now)
                            activities.activities[index].completions.append(Date.now)
                        }
                    } label: {
                        ZStack {
                            RoundedRectangle(cornerRadius: 15)
                            Text("Complete")
                                .foregroundColor(.white)
                        }
                    }
                    .frame(maxHeight: 60)
                }
                .padding()
            )
        }
        .navigationBarTitleDisplayMode(.inline)
    }
    
    func delete(at offsets: IndexSet) {
        activity.completions.remove(atOffsets: offsets)
    }
}

struct ActivityView_Previews: PreviewProvider {

    static var previews: some View {
        let activity = Activity(name: "Name", description: "A totaly 100% pure normal test. ", type: "Other", customType: "Type", dateLastUpdated: Date.now)

        ActivityView(activities: Activities(), activity: activity)
    }
}
