//
//  RootView.swift
//  WeightRecorder
//
//  Created by Sergii Sukhanov on 11.11.26.
//

import SwiftUI

struct RootView: View {
  @State private var path: [NavigationRoute] = []
  @State private var inputData = InputData()
  @State private var healthLoader = HealthLoader()
  
  @State private var isReady = false
  @State private var errorMessage = ""
  @State private var showsError = false
  
  var body: some View {
    Group {
      if isReady {
        NavigationStack(path: $path) {
          InputWeightView(inputData: inputData) { path.append(.bmi) }
            .navigationTitle("WeightRecorder")
            .navigationDestination(for: NavigationRoute.self) { route in
              switch route {
              case .bmi: InputBmiView(inputData: inputData) { path.append(.bodyFatPercentage) }
              case .bodyFatPercentage: InputBodyFatPercentageView(inputData: inputData) { path.append(.leanBodyMass) }
              case .leanBodyMass: InputLeanBodyMassView(inputData: inputData) { path.append(.confirmation) }
              case .confirmation: ConfirmationView(inputData: inputData)
              }
            }
        }
      } else {
        ProgressView("Reading previous measurements...")
      }
    }
    .task {
      await loadInitialData()
    }
    .alert("Couldn't read previous measurements", isPresented: $showsError) {
      Button("OK", role: .cancel) {}
    } message: {
      Text(errorMessage)
    }
  }
  
  @MainActor
  private func loadInitialData() async {
    guard !isReady else {
      return
    }
    
    do {
      let loadedData = try await healthLoader.loadInitialData()
      try Task.checkCancellation()
      inputData = loadedData
      isReady = true
    } catch is CancellationError {
      // Leave loading unfinished if the view's task was cancelled.
    } catch {
      errorMessage = error.localizedDescription
      showsError = true
      isReady = true
    }
  }
}

#Preview {
  RootView()
}
