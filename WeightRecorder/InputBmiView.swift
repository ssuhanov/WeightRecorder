//
//  InputBmiView.swift
//  WeightRecorder
//
//  Created by Sergii Sukhanov on 11.11.26.
//

import SwiftUI

struct InputBmiView: View {
  private let inputData: InputData
  private let onNext: () -> Void
  
  @State private var bmi: Int
  
  init(inputData: InputData, onNext: @escaping () -> Void) {
    self.inputData = inputData
    self.onNext = onNext
    if let heightInCentimeters = inputData.heightInCentimeters {
      let heightInMeters = heightInCentimeters / 100
      let bmi = inputData.weightInKilos / (heightInMeters * heightInMeters)
      self.bmi = Int((bmi * 10).rounded())
    } else {
      self.bmi = Int((inputData.bmi * 10).rounded())
    }
  }
  
  var body: some View {
    inputBmiForm
      .padding(24)
  }
  
  private var inputBmiForm: some View {
    VStack(spacing: 24) {
      Spacer()
      Spacer()
      
      Text("BMI:")
        .font(.largeTitle.bold())
      
      Picker("BMI", selection: $bmi) {
        ForEach(100...1000, id: \.self) { value in
          Text("\(Double(value) / 10, format: .number.precision(.fractionLength(1)))")
            .tag(value)
        }
      }
      .pickerStyle(.wheel)
      .frame(height: 220)
      
      Spacer()
      
      Button("Next") {
        inputData.bmi = Double(bmi) / 10
        onNext()
      }
      .buttonStyle(.borderedProminent)
      .controlSize(.large)
      .frame(maxWidth: .infinity)
      
      Spacer()
      Spacer()
    }
  }
}

#Preview {
  InputBmiView(inputData: InputData()) {}
}
