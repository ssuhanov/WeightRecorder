//
//  DataPicker.swift
//  WeightRecorder
//
//  Created by Sergii Sukhanov on 22.11.26.
//

import SwiftUI

struct InputDataPicker: View {
  private let title: String
  private let unit: String?
  private let unitText: String
  private let range: ClosedRange<Int>
  @Binding private var selection: Int
  
  init(title: String, unit: String? = nil, range: ClosedRange<Int>, selection: Binding<Int>) {
    self.title = title
    self.unit = unit
    self.range = range
    self._selection = selection

    if let unit, !unit.isEmpty {
      self.unitText = " \(unit)"
    } else {
      self.unitText = ""
    }
  }
    
  var body: some View {
    Picker(title, selection: $selection) {
      ForEach(range, id: \.self) { value in
        Text("\(Double(value) / 10, format: .number.precision(.fractionLength(1)))\(unitText)")
          .tag(value)
      }
    }
    .pickerStyle(.wheel)
    .frame(height: 220)
  }
}

#Preview {
  @Previewable @State var selection = 734
  InputDataPicker(title: "Weight", unit: "kg", range: 500...1000, selection: $selection)
}
