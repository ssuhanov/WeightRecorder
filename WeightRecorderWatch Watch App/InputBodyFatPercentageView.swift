//
//  InputBodyFatPercentageView.swift
//  WeightRecorderWatch Watch App
//
//  Created by Sergii Sukhanov on 17.11.26.
//

import SwiftUI

struct InputBodyFatPercentageView: View {
  private let inputData: InputData
  private let onNext: () -> Void
  private let bodyFatPercentageRange: ClosedRange<Int>
  @State private var bodyFatPercentage: Int
  
  init(inputData: InputData, onNext: @escaping () -> Void) {
    self.inputData = inputData
    self.onNext = onNext
    
    let initialBodyFatPercentage = Int((inputData.bodyFatPercentage * 1000).rounded())
    self.bodyFatPercentageRange = min(10, initialBodyFatPercentage)...max(750, initialBodyFatPercentage)
    self.bodyFatPercentage = initialBodyFatPercentage
  }
  
  var body: some View {
    inputBodyFatPercentageForm
      .padding(.horizontal, 8)
      .navigationTitle("Body Fat:")
  }
  
  private var inputBodyFatPercentageForm: some View {
    VStack(spacing: 8) {
      Picker("Body Fat", selection: $bodyFatPercentage) {
        ForEach(bodyFatPercentageRange, id: \.self) { value in
          Text("\(Double(value) / 10, format: .number.precision(.fractionLength(1))) \("%")")
            .tag(value)
        }
      }
      .pickerStyle(.wheel)
      .labelsHidden()
      .frame(maxHeight: .infinity)
      
      PrimaryButton("Next") {
        inputData.bodyFatPercentage = Double(bodyFatPercentage) / 1000
        inputData.leanBodyMassInKilos = inputData.weightInKilos * (1 - inputData.bodyFatPercentage)
        onNext()
      }
    }
  }
}

#Preview {
  InputBodyFatPercentageView(inputData: InputData()) {}
}
