//
//  InputLeanBodyMassView.swift
//  WeightRecorder
//
//  Created by Sergii Sukhanov on 15.11.26.
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
      .padding(24)
  }
  
  private var inputLeanBodyMassForm: some View {
    VStack(spacing: 24) {
      Spacer()
      Spacer()
      
      Text("Lean Body Mass:")
        .font(.largeTitle.bold())
      
      Picker("Lean Body Mass", selection: $leanBodyMass) {
        ForEach(leanBodyMassRange, id: \.self) { value in
          Text("\(Double(value) / 10, format: .number.precision(.fractionLength(1))) \("kg")")
            .tag(value)
        }
      }
      .pickerStyle(.wheel)
      .frame(height: 220)
      
      Spacer()
      
      PrimaryButton("Next") {
        inputData.leanBodyMassInKilos = Double(leanBodyMass) / 10
        onNext()
      }
      
      Spacer()
      Spacer()
    }
  }
}

#Preview {
  InputLeanBodyMassView(inputData: InputData()) {}
}
