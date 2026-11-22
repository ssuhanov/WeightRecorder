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

struct PrimaryButton<Content: View>: View {
  private let content: Content
  private let action: () -> Void
  
  init(action: @escaping () -> Void, @ViewBuilder content: () -> Content) {
    self.content = content()
    self.action = action
  }
  
  var body: some View {
    Button<Content>(action: action, label: { content })
      .buttonStyle(.glassProminent)
      .largeControlSize()
      .frame(maxWidth: .infinity)
  }
}

extension PrimaryButton where Content == Text {
  init(_ title: String, action: @escaping () -> Void) {
    self.init(action: action, content: { Text(title) })
  }
}

#Preview {
  PrimaryButton("Next") {}
}
