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
      
      if let weight = inputData.weight {
        Text("Weight: \(Double(weight) / 10, format: .number.precision(.fractionLength(1))) \("kg")")
          .font(.largeTitle.bold())
      }
      
      if let bmi = inputData.bmi {
        Text("BMI: \(Double(bmi) / 10, format: .number.precision(.fractionLength(1)))")
          .font(.largeTitle.bold())
      }
      
      if isSaving {
        ProgressView("Saving to Apple Health...")
      }
      
      Button("Save to Health") {
        Task {
          await saveWeight()
          isDone = true
        }
      }
      .buttonStyle(.borderedProminent)
      .controlSize(.large)
      .frame(maxWidth: .infinity)
      .disabled(isDone)
      
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
  ConfirmationView(inputData: InputData(weight: 754, bmi: 234))
}
