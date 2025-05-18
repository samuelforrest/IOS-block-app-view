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
        ZStack {
            LinearGradient(gradient: Gradient(colors: [Color.blue.opacity(0.3), Color.purple.opacity(0.3)]), startPoint: .topLeading, endPoint: .bottomTrailing)
                .ignoresSafeArea()
            VStack {
                Button("Select Apps to Discourage") {
                    isDiscouragedPresented = true
                }
                .familyActivityPicker(isPresented: $isDiscouragedPresented, selection: $model.selectionToDiscourage)
                .onChange(of: model.selectionToDiscourage) { newSelection in
                    isTimerSettingPresented = true // Open timer setting interface after selecting apps
                }
                .padding()
                .background(Color.blue)
                .foregroundColor(.white)
                .cornerRadius(10)
                .font(.headline)

                Text("Blocked App Categories:")
                    .font(.headline)
                    .padding(.top)

                ScrollView(.horizontal, showsIndicators: false) {
                    HStack {
                        }
                    }
                    .padding(.horizontal)
                }

                // Timer Setting Interface
                if isTimerSettingPresented {
                    TimerSettingView(isPresented: $isTimerSettingPresented)
                        .environmentObject(model)
                }
            }
            .padding()
        }
    }


struct TimerSettingView: View {
    @Binding var isPresented: Bool
    @State private var selectedHours: Int = 0
    @State private var selectedMinutes: Int = 0
    @State private var isTimerRunning = false
    @State private var startTime: Date? = nil
    
    @EnvironmentObject var model: MyModel
    
    var elapsedTime: TimeInterval {
        if let start = startTime {
            return Date().timeIntervalSince(start)
        }
        return 0
    }
    
    var body: some View {
        ZStack {
            RoundedRectangle(cornerRadius: 20)
                .fill(Color.white)
                .shadow(radius: 10)
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
                    .background(Color.gray.opacity(0.1))
                    .cornerRadius(10)

                    Picker("Minutes", selection: $selectedMinutes) {
                        ForEach(0..<60) {
                            Text("\($0) min").tag($0)
                        }
                    }
                    .pickerStyle(WheelPickerStyle())
                    .frame(width: 100, height: 150)
                    .clipped()
                    .background(Color.gray.opacity(0.1))
                    .cornerRadius(10)
                }

                Button("Start Block") {
                    let totalSeconds = selectedHours * 3600 + selectedMinutes * 60
                    model.startLimitationTimer(duration: TimeInterval(totalSeconds))
                    MyModel.shared.setShieldRestrictions()
                    isTimerRunning = true // Start the timer
                    startTime = Date()
                }
                .padding()
                .background(Color.red)
                .foregroundColor(.white)
                .cornerRadius(10)
                .font(.headline)
                
                Text("Remaining Time: \(formattedTime(from: model.remainingTime))")
                    .font(.title)
                    .bold()
                    .padding()
                
                Text("Elapsed Time: \(formattedTime(from: elapsedTime))")
                    .font(.title2)
                    .foregroundColor(.secondary)
            }
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
