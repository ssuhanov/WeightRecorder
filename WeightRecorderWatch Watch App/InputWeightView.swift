//
//  ContentView.swift
//  WeightRecorderWatch Watch App
//
//  Created by Sergii Sukhanov on 17.11.26.
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
      .padding(.horizontal, 8)
      .navigationTitle("Weight:")
  }
  
  private var inputWeightForm: some View {
    VStack(spacing: 8) {
      Picker("Weight", selection: $weight) {
        ForEach(weightRange, id: \.self) { value in
          Text("\(Double(value) / 10, format: .number.precision(.fractionLength(1))) \("kg")")
            .tag(value)
        }
      }
      .pickerStyle(.wheel)
      .labelsHidden()
      .frame(maxHeight: .infinity)
      
      Button("Next") {
        inputData.weightInKilos = Double(weight) / 10
        if let heightInCentimeters = inputData.heightInCentimeters, heightInCentimeters > 0.0 {
          let heightInMeters = heightInCentimeters / 100
          inputData.bmi = inputData.weightInKilos / (heightInMeters * heightInMeters)
        }
        onNext()
      }
      .buttonStyle(.borderedProminent)
      .frame(maxWidth: .infinity)
    }
  }
}

#Preview {
  InputWeightView(inputData: InputData()) {}
}
