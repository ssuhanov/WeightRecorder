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

class InputData {
  var weight: Int?
  var bmi: Int?
}

struct RootView: View {
  @State private var path: [Route] = []
  private var inputData = InputData()
  
  var body: some View {
    NavigationStack(path: $path) {
      InputWeightView(inputData: inputData) { path.append(.bmi)}
        .navigationTitle("WeightRecorder")
        .navigationDestination(for: Route.self) { route in
          switch route {
          case .bmi: InputBmiView(inputData: inputData) { path.append(.confirmation) }
          case .confirmation: ConfirmationView(inputData: inputData)
          }
        }
    }
  }
}

#Preview {
  RootView()
}
