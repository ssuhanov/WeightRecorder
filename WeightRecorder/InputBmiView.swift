//
//  InputBmiView.swift
//  WeightRecorder
//
//  Created by Sergii Sukhanov on 11.11.26.
//

import SwiftUI

struct InputBmiView: View {
  var inputData: InputData
  let onNext: () -> Void
  
  var body: some View {
    Text("BMI Input will be here")
    
    Button("Next") {
      inputData.bmi = 123
      onNext()
    }
    .buttonStyle(.borderedProminent)
    .controlSize(.large)
    .frame(maxWidth: .infinity)
  }
}

#Preview {
  InputBmiView(inputData: InputData()) {}
}
