//
//  InputBodyFatPercentageView.swift
//  WeightRecorder
//
//  Created by Sergii Sukhanov on 14.11.26.
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
      .padding(24)
  }
  
  private var inputBodyFatPercentageForm: some View {
    VStack(spacing: 24) {
      Spacer()
      Spacer()
      
      Text("Body Fat:")
        .font(.largeTitle.bold())
      
      InputDataPicker(title: "Body Fat", unit: "%", range: bodyFatPercentageRange, selection: $bodyFatPercentage)
      
      Spacer()
      
      PrimaryButton("Next") {
        inputData.bodyFatPercentage = Double(bodyFatPercentage) / 1000
        inputData.leanBodyMassInKilos = inputData.weightInKilos * (1 - inputData.bodyFatPercentage)
        onNext()
      }
      
      Spacer()
      Spacer()
    }
  }
}

#Preview {
  InputBodyFatPercentageView(inputData: InputData()) {}
}
