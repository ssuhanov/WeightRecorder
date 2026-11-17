//
//  InputLeanBodyMassView.swift
//  WeightRecorderWatch Watch App
//
//  Created by Sergii Sukhanov on 17.11.26.
//

import SwiftUI

struct InputLeanBodyMassView: View {
  private let inputData: InputData
  private let onNext: () -> Void
  private let leanBodyMassRange: ClosedRange<Int>
  @State private var leanBodyMass: Int
  
  init(inputData: InputData, onNext: @escaping () -> Void) {
    self.inputData = inputData
    self.onNext = onNext
    
    let initialLeanBodyMass = Int((inputData.leanBodyMassInKilos * 10).rounded())
    self.leanBodyMassRange = min(450, initialLeanBodyMass)...max(900, initialLeanBodyMass)
    self.leanBodyMass = initialLeanBodyMass
  }
  
  var body: some View {
    inputLeanBodyMassForm
      .padding(.horizontal, 8)
      .navigationTitle("Lean Body Mass:")
  }
  
  private var inputLeanBodyMassForm: some View {
    VStack(spacing: 8) {
      Picker("Lean Body Mass", selection: $leanBodyMass) {
        ForEach(leanBodyMassRange, id: \.self) { value in
          Text("\(Double(value) / 10, format: .number.precision(.fractionLength(1))) \("kg")")
            .tag(value)
        }
      }
      .pickerStyle(.wheel)
      .labelsHidden()
      .frame(maxHeight: .infinity)
      
      Button("Next") {
        inputData.leanBodyMassInKilos = Double(leanBodyMass) / 10
        onNext()
      }
      .buttonStyle(.borderedProminent)
      .frame(maxWidth: .infinity)
    }
  }
}

#Preview {
  InputLeanBodyMassView(inputData: InputData()) {}
}
