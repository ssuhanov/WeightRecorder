//
//  RootView.swift
//  WeightRecorder
//
//  Created by Sergii Sukhanov on 11.11.26.
//

import SwiftUI

enum Route: Hashable {
  case bmi
  case confirmation
}

final class InputData {
  var heightInCentimeters: Double?
  var weightInKilos: Double
  var bmi: Double
  
  init(heightInCentimeters: Double? = nil, weightInKilos: Double = 73.1, bmi: Double = 23.4) {
    self.heightInCentimeters = heightInCentimeters
    self.weightInKilos = weightInKilos
    self.bmi = bmi
  }
}

struct RootView: View {
  @State private var path: [Route] = []
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
            .navigationDestination(for: Route.self) { route in
              switch route {
              case .bmi: InputBmiView(inputData: inputData) { path.append(.confirmation) }
              case .confirmation: ConfirmationView(inputData: inputData)
              }
            }
        }
      } else {
        ProgressView("Reading prvious measurements...")
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
