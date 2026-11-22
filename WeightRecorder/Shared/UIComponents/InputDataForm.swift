//
//  InputDataForm.swift
//  WeightRecorder
//
//  Created by Sergii Sukhanov on 22.11.26.
//

import SwiftUI

struct InputDataForm: View {
  private let title: String
  private let unit: String?
  private let range: ClosedRange<Int>
  @Binding private var selection: Int
  private let buttonTitle: String
  private let buttonAction: () -> Void

  init(
    title: String,
    unit: String? = nil,
    range: ClosedRange<Int>,
    selection: Binding<Int>,
    buttonTitle: String,
    buttonAction: @escaping () -> Void
  ) {
    self.title = title
    self.unit = unit
    self.range = range
    self._selection = selection
    self.buttonTitle = buttonTitle
    self.buttonAction = buttonAction
  }

  var body: some View {
    VStack(spacing: 24) {
      Spacer()
      Spacer()
      
      Text("\(title):")
        .font(.largeTitle.bold())
      
      InputDataPicker(title: title, unit: unit, range: range, selection: $selection)
      
      Spacer()
      
      PrimaryButton(buttonTitle, action: buttonAction)
      
      Spacer()
      Spacer()
    }
  }
}

#Preview {
  @Previewable @State var selection = 756
  InputDataForm(
    title: "Weight",
    unit: "kg",
    range: 500...1000,
    selection: $selection,
    buttonTitle: "Next") {}
}
