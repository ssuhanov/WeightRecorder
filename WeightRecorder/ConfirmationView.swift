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
    if isDone {
      successForm
        .navigationBarBackButtonHidden()
    } else {
      confirmationForm
        .navigationBarBackButtonHidden(isSaving)
        .alert("Couldn't save weight", isPresented: $showsError) {
          Button("OK", role: .cancel) {}
        } message: {
          Text(errorMessage ?? "Please try again.")
        }
    }
  }
  
  private var confirmationForm: some View {
    VStack(spacing: 24) {
      VStack(spacing: 12) {
        if let weight = inputData.weight {
          Text("Weight: \(Double(weight) / 10, format: .number.precision(.fractionLength(1))) \("kg")")
            .font(.title.bold())
        }
        
        if let bmi = inputData.bmi {
          Text("BMI: \(Double(bmi) / 10, format: .number.precision(.fractionLength(1)))")
            .font(.title.bold())
        }
      }
      
      if isSaving {
        ProgressView("Saving to Apple Health...")
      }
      
      Button("Save to Health") {
        Task {
          await saveMeasurements()
        }
      }
      .buttonStyle(.borderedProminent)
      .controlSize(.large)
      .frame(maxWidth: .infinity)
    }
    .disabled(isSaving)
  }
  
  private var successForm: some View {
    VStack(spacing: 24) {
      Text("Data saved to Apple Health")
        .font(.title2.bold())
      
      VStack(spacing: 12) {
        if let weight = inputData.weight {
          Text("Weight: \(Double(weight) / 10, format: .number.precision(.fractionLength(1))) \("kg")")
            .font(.body)
        }
        
        if let bmi = inputData.bmi {
          Text("BMI: \(Double(bmi) / 10, format: .number.precision(.fractionLength(1)))")
            .font(.body)
        }
      }
      
      Image(systemName: "checkmark.circle.fill")
        .font(.system(size: 64))
        .foregroundStyle(.green)
    }
  }
  
  @MainActor
  private func saveMeasurements() async {
    isSaving = true
    defer { isSaving = false }
    
    do {
      try await healthStore.save(inputData: inputData)
      isDone = true
    } catch {
      errorMessage = error.localizedDescription
      showsError = true
    }
  }
}

#Preview {
  ConfirmationView(inputData: InputData(weight: 754, bmi: 234))
}
