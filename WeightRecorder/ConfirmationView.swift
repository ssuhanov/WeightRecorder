//
//  ConfirmationView.swift
//  WeightRecorder
//
//  Created by Sergii Sukhanov on 11.11.26.
//

import SwiftUI

struct ConfirmationView: View {
  @State private var isDone = false
  
  var body: some View {
    VStack(spacing: 24) {
      Spacer()
      
      Image(systemName: "checkmark.circle.fill")
        .font(.system(size: 64))
        .foregroundStyle(.green)
      
      Text("Saved to Apple Health")
        .font(.title2.bold())
      
      Button("Done") {
        isDone = true
        // after pressing this button navigation stack should not be able to go back
      }
      .buttonStyle(.borderedProminent)
      .controlSize(.large)
      .frame(maxWidth: .infinity)
      .disabled(isDone)
      
      Spacer()
    }
  }
}

#Preview {
  ConfirmationView()
}
