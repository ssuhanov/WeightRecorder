//
//  ConfirmationView.swift
//  WeightRecorder
//
//  Created by Sergii Sukhanov on 11.11.26.
//

import SwiftUI

struct ConfirmationView: View {
  private let inputData: InputData
  
  @State private var isSaving = false
  @State private var errorMessage: String?
  @State private var showsError = false
  @State private var isDone = false
  
  @State private var healthStore = HealthStore()
  
  init(inputData: InputData) {
    self.inputData = inputData
  }
  
  var body: some View {
    ZStack {
      if isDone {
        successForm
          .navigationBarBackButtonHidden()
          .transition(.blurReplace)
      } else {
        confirmationForm
          .navigationBarBackButtonHidden(isSaving)
          .alert("Couldn't save measurements", isPresented: $showsError) {
            Button("OK", role: .cancel) {}
          } message: {
            Text(errorMessage ?? "Please try again.")
          }
          .transition(.blurReplace)
      }
    }
  }
  
  private var confirmationForm: some View {
    VStack(spacing: 24) {
      inputDataRepresentation
        .font(.title.bold())
      
      if isSaving {
        ProgressView("Saving to Apple Health...")
      }
      
      PrimaryButton("Save to Health") {
        Task {
          await saveMeasurements()
        }
      }
    }
    .disabled(isSaving)
  }
  
  private var successForm: some View {
    VStack(spacing: 24) {
      Text("Data saved to Apple Health")
        .font(.title2.bold())
      
      inputDataRepresentation
        .font(.body)
      
      Image(systemName: "checkmark.circle.fill")
        .font(.system(size: 64))
        .foregroundStyle(.green)
    }
  }
  
  private var inputDataRepresentation: some View {
    VStack(spacing: 12) {
      Text("Weight: \(inputData.weightInKilos, format: .number.precision(.fractionLength(1))) kg")
      Text("BMI: \(inputData.bmi, format: .number.precision(.fractionLength(1)))")
      Text("Body Fat: \(inputData.bodyFatPercentage, format: .percent.precision(.fractionLength(1)))")
      Text("Lean Body Mass: \(inputData.leanBodyMassInKilos, format: .number.precision(.fractionLength(1))) kg")
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
  ConfirmationView(inputData: InputData(weightInKilos: 75.4, bmi: 23.4))
}
