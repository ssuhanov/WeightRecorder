//
//  PrimaryButton.swift
//  WeightRecorder
//
//  Created by Sergii Sukhanov on 22.11.26.
//

import SwiftUI

private struct LargeControlSize: ViewModifier {
  func body(content: Content) -> some View {
#if os(watchOS)
    return content
#else
    return content.controlSize(.large)
#endif
  }
}

private extension View {
  func largeControlSize() -> some View {
    modifier(LargeControlSize())
  }
}

struct PrimaryButton: View {
  private let title: String
  private let action: () -> Void
  
  init(_ title: String, action: @escaping () -> Void) {
    self.title = title
    self.action = action
  }
  
  var body: some View {
    Button(title, action: action)
      .buttonStyle(.glassProminent)
      .largeControlSize()
      .frame(maxWidth: .infinity)
  }
}

#Preview {
  PrimaryButton("Next") {}
}
