//
//  ContentView.swift
//  WeightRecorder
//
//  Created by Sergii Sukhanov on 08.11.26.
//

import SwiftUI

struct ContentView: View {
  @State private var weight = 521
  
  @State private var isSaving = false
  @State private var errorMessage: String?
  @State private var showsError = false
  
  @State private var healthStore = HealthStore()
  
  var body: some View {
    NavigationStack {
      inputWeightForm
        .padding(24)
        .navigationTitle("WeightRecorder")
        .alert("Couldn't save weight", isPresented: $showsError) {
          Button("OK", role: .cancel) {}
        } message: {
          Text(errorMessage ?? "Please try again.")
        }
    }
  }
  
  private var inputWeightForm: some View {
    VStack(spacing: 24) {
      Spacer()
      Spacer()
      
      Text("Input your weight:")
      
      Picker("Weight", selection: $weight) {
        ForEach(500...1000, id: \.self) { value in
          Text("\(Double(value) / 10, format: .number.precision(.fractionLength(1))) \("kg")")
            .tag(value)
        }
      }
      .pickerStyle(.wheel)
      .frame(height: 220)
      
      Spacer()
      
      if isSaving {
        ProgressView("Saving to Apple Health...")
      }
      
      Button("Done") {
        Task {
          await saveWeight()
        }
      }
      .buttonStyle(.borderedProminent)
      .controlSize(.large)
      .frame(maxWidth: .infinity)
      
      Spacer()
      Spacer()
    }
    .disabled(isSaving)
  }

  @MainActor
  private func saveWeight() async {
    // TODO: - prepare data and call healthStore.save(...) here
  }
}

#Preview {
  ContentView()
}
