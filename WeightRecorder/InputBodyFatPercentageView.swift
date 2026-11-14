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
      
      Picker("Body Fat", selection: $bodyFatPercentage) {
        ForEach(bodyFatPercentageRange, id: \.self) { value in
          Text("\(Double(value) / 10, format: .number.precision(.fractionLength(1))) \("%")")
            .tag(value)
        }
      }
      .pickerStyle(.wheel)
      .frame(height: 220)
      
      Spacer()
      
      Button("Next") {
        inputData.bodyFatPercentage = Double(bodyFatPercentage) / 1000
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
  InputBodyFatPercentageView(inputData: InputData()) {}
}
