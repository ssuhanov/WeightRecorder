//
//  ContentView.swift
//  WeightRecorder
//
//  Created by Sergii Sukhanov on 08.11.26.
//

import SwiftUI

struct InputWeightView: View {
  private let inputData: InputData
  private let onNext: () -> Void
  private let weightRange: ClosedRange<Int>
  @State private var weight: Int
  
  init(inputData: InputData, onNext: @escaping () -> Void) {
    self.inputData = inputData
    self.onNext = onNext
    
    let initialWeight = Int((inputData.weightInKilos * 10).rounded())
    self.weightRange = min(500, initialWeight)...max(1000, initialWeight)
    self.weight = initialWeight
  }
  
  var body: some View {
    inputWeightForm
      .padding(24)
  }
  
  private var inputWeightForm: some View {
    InputDataForm(
      title: "Weight",
      unit: "kg",
      range: weightRange,
      selection: $weight,
      buttonTitle: "Next"
    ) {
      inputData.weightInKilos = Double(weight) / 10
      if let heightInCentimeters = inputData.heightInCentimeters, heightInCentimeters > 0.0 {
        let heightInMeters = heightInCentimeters / 100
        inputData.bmi = inputData.weightInKilos / (heightInMeters * heightInMeters)
      }
      onNext()
    }
  }
}

#Preview {
  InputWeightView(inputData: InputData()) {}
}
