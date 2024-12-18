//
//  ContentView.swift
//  LockBox
//
//  Created by Brett Nguyen  on 3/14/24.
//

import SwiftUI
import Combine

struct ContentView: View {
    @State private var isDiscouragedPresented = false
    @State private var isTimerSettingPresented = false

    
    @EnvironmentObject var model: MyModel

    var body: some View {
        VStack {
            Button("Select Apps to Discourage") {
                isDiscouragedPresented = true
            }
            .familyActivityPicker(isPresented: $isDiscouragedPresented, selection: $model.selectionToDiscourage)
            .onChange(of: model.selectionToDiscourage) { newSelection in
                isTimerSettingPresented = true // Open timer setting interface after selecting apps
            }

            // Timer Setting Interface
            if isTimerSettingPresented {
                TimerSettingView(isPresented: $isTimerSettingPresented)
                    .environmentObject(model)
            }
        }
    }
}

struct TimerSettingView: View {
    @Binding var isPresented: Bool
    @State private var selectedHours: Int = 0
    @State private var selectedMinutes: Int = 0
    @State private var isTimerRunning = false
    
    @EnvironmentObject var model: MyModel
    
    var body: some View {
        VStack {
            HStack {
                Picker("Hours", selection: $selectedHours) {
                    ForEach(0..<24) {
                        Text("\($0) hr").tag($0)
                    }
                }
                .pickerStyle(WheelPickerStyle())
                .frame(width: 100, height: 150)
                .clipped()

                Picker("Minutes", selection: $selectedMinutes) {
                    ForEach(0..<60) {
                        Text("\($0) min").tag($0)
                    }
                }
                .pickerStyle(WheelPickerStyle())
                .frame(width: 100, height: 150)
                .clipped()
            }

            Button("Start Block") {
                let totalSeconds = selectedHours * 3600 + selectedMinutes * 60
                model.startLimitationTimer(duration: TimeInterval(totalSeconds))
                MyModel.shared.setShieldRestrictions()
                isTimerRunning = true // Start the timer
            }
            
            Text("Remaining Time: \(formattedTime(from: model.remainingTime))")
                .padding()
        }
        .onReceive(model.$remainingTime) { newRemainingTime in
            // Update isTimerRunning based on remaining time
            isTimerRunning = newRemainingTime > 0
        }
    }
    
    // Function to format remaining time as HH:MM:SS
    private func formattedTime(from timeInterval: TimeInterval) -> String {
        let hours = Int(timeInterval) / 3600
        let minutes = Int(timeInterval) / 60 % 60
        let seconds = Int(timeInterval) % 60
        return String(format: "%02d:%02d:%02d", hours, minutes, seconds)
    }
}





struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
            .environmentObject(MyModel())
    }
}
