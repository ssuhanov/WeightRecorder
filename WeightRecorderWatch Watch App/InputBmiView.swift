//
//  InputBmiView.swift
//  WeightRecorderWatch Watch App
//
//  Created by Sergii Sukhanov on 17.11.26.
//

import SwiftUI

struct InputBmiView: View {
  private let inputData: InputData
  private let onNext: () -> Void
  private let bmiRange: ClosedRange<Int>
  @State private var bmi: Int
  
  init(inputData: InputData, onNext: @escaping () -> Void) {
    self.inputData = inputData
    self.onNext = onNext
    
    let initialBmi = Int((inputData.bmi * 10).rounded())
    self.bmiRange = min(100, initialBmi)...max(1000, initialBmi)
    self.bmi = initialBmi
  }
  
  var body: some View {
    inputBmiForm
      .padding(.horizontal, 8)
      .navigationTitle("BMI:")
  }
  
  private var inputBmiForm: some View {
    VStack(spacing: 8) {
      Picker("BMI", selection: $bmi) {
        ForEach(bmiRange, id: \.self) { value in
          Text("\(Double(value) / 10, format: .number.precision(.fractionLength(1)))")
            .tag(value)
        }
      }
      .pickerStyle(.wheel)
      .labelsHidden()
      .frame(maxHeight: .infinity)
      
      PrimaryButton("Next") {
        inputData.bmi = Double(bmi) / 10
        onNext()
      }
    }
  }
}

#Preview {
  InputBmiView(inputData: InputData()) {}
}
