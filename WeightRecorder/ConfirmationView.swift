//
//  ConfirmationView.swift
//  WeightRecorder
//
//  Created by Sergii Sukhanov on 11.11.26.
//

import SwiftUI

struct ConfirmationView: View {
  let inputData: InputData
  
  @State private var isSaving = false
  @State private var errorMessage: String?
  @State private var showsError = false
  @State private var isDone = false

  @State private var healthStore = HealthStore()

  var body: some View {
    confirmationForm
      .navigationBarBackButtonHidden(isDone)
      .alert("Couldn't save weight", isPresented: $showsError) {
        Button("OK", role: .cancel) {}
      } message: {
        Text(errorMessage ?? "Please try again.")
      }
  }
  
  private var confirmationForm: some View {
    VStack(spacing: 24) {
      Spacer()
      
      Image(systemName: "checkmark.circle.fill")
        .font(.system(size: 64))
        .foregroundStyle(.green)
      
      if isSaving {
        ProgressView("Saving to Apple Health...")
      }
      
      Text("Saved to Apple Health (really?)")
        .font(.title2.bold())
      
      Button("Done") {
        Task {
          await saveWeight()
          isDone = true
        }
        // after pressing this button navigation stack should not be able to go back
      }
      .buttonStyle(.borderedProminent)
      .controlSize(.large)
      .frame(maxWidth: .infinity)
      // .disabled(isDone)
      
      Spacer()
    }
    .disabled(isSaving)
  }

  @MainActor
  private func saveWeight() async {
    isSaving = true
    defer { isSaving = false }
    
    do {
      try await healthStore.save(inputData: inputData)
    } catch {
      errorMessage = error.localizedDescription
      showsError = true
    }
  }
}

#Preview {
  ConfirmationView(inputData: InputData())
}
