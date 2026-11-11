//
//  RootView.swift
//  WeightRecorder
//
//  Created by Sergii Sukhanov on 11.11.26.
//

import SwiftUI

enum Route: Hashable {
  case weight
  case confirmation
}

struct RootView: View {
  @State private var path: [Route] = []
  
  var body: some View {
    NavigationStack(path: $path) {
      InputWeightView(onNext: { path.append(.confirmation)})
        .navigationTitle("WeightRecorder")
        .navigationDestination(for: Route.self) { route in
          switch route {
          case .weight: InputWeightView(onNext: { path.append(.confirmation) })
          case .confirmation: ConfirmationView()
          }
        }
    }
  }
}

#Preview {
  RootView()
}
