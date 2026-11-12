//
//  ContentView.swift
//  WeightRecorder
//
//  Created by Sergii Sukhanov on 08.11.26.
//

import SwiftUI

struct InputWeightView: View {
  private let inputData: InputData
  private let onNext: () -> Void
  
  @State private var weight: Int
  
  init(inputData: InputData, onNext: @escaping () -> Void) {
    self.inputData = inputData
    self.onNext = onNext
    self.weight = inputData.weight ?? 731
  }
  
  var body: some View {
    inputWeightForm
      .padding(24)
  }
  
  private var inputWeightForm: some View {
    VStack(spacing: 24) {
      Spacer()
      Spacer()
      
      Text("Weight:")
        .font(.largeTitle.bold())
      
      Picker("Weight", selection: $weight) {
        ForEach(500...1000, id: \.self) { value in
          Text("\(Double(value) / 10, format: .number.precision(.fractionLength(1))) \("kg")")
            .tag(value)
        }
      }
      .pickerStyle(.wheel)
      .frame(height: 220)
      
      Spacer()
      
      Button("Next") {
        inputData.weight = weight
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
  InputWeightView(inputData: InputData()) {}
}
