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
    self.bmi = inputData.bmi
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
        inputData.bmi = bmi
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
