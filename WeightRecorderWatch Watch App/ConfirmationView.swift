//
//  ConfirmationView.swift
//  WeightRecorderWatch Watch App
//
//  Created by Sergii Sukhanov on 17.11.26.
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
    if isDone {
      successForm
        .navigationBarBackButtonHidden()
    } else {
      confirmationForm
        .navigationTitle("Review")
        .navigationBarBackButtonHidden(isSaving)
        .alert("Couldn't save measurements", isPresented: $showsError) {
          Button("OK", role: .cancel) {}
        } message: {
          Text(errorMessage ?? "Please try again.")
        }
    }
  }
  
  private var confirmationForm: some View {
    ScrollView {
      VStack(spacing: 12) {
        VStack(alignment: .leading, spacing: 8) {
          Text("Weight: \(inputData.weightInKilos, format: .number.precision(.fractionLength(1))) kg")
          Text("BMI: \(inputData.bmi, format: .number.precision(.fractionLength(1)))")
          Text("Body Fat: \(inputData.bodyFatPercentage, format: .percent.precision(.fractionLength(1)))")
          Text("Lean Body Mass: \(inputData.leanBodyMassInKilos, format: .number.precision(.fractionLength(1))) kg")
        }
        .font(.caption)
        
        if isSaving {
          ProgressView("Saving...")
        }
        
        Button("Save to Health") {
          Task {
            await saveMeasurements()
          }
        }
        .buttonStyle(.borderedProminent)
        .frame(maxWidth: .infinity)
      }
      .padding(.horizontal, 8)
      .disabled(isSaving)
    }
  }
  
  private var successForm: some View {
    ScrollView {
      VStack(spacing: 12) {
        Text("Saved to Health")
        
        Image(systemName: "checkmark.circle.fill")
          .font(.largeTitle)
          .foregroundStyle(.green)
        
        VStack(alignment: .leading, spacing: 8) {
          Text("Weight: \(inputData.weightInKilos, format: .number.precision(.fractionLength(1))) kg")
          Text("BMI: \(inputData.bmi, format: .number.precision(.fractionLength(1)))")
          Text("Body Fat: \(inputData.bodyFatPercentage, format: .percent.precision(.fractionLength(1)))")
          Text("Lean Body Mass: \(inputData.leanBodyMassInKilos, format: .number.precision(.fractionLength(1))) kg")
        }
        .font(.caption)
      }
      .padding(.horizontal, 8)
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
  ConfirmationView(inputData: InputData(weightInKilos: 87.3, bmi: 31.4))
}
