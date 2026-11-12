//
//  HealthStore.swift
//  WeightRecorder
//
//  Created by Sergii Sukhanov on 08.11.26.
//

import Foundation
import HealthKit

@MainActor
final class HealthStore {
  private let store = HKHealthStore()
  
  private let weightType = HKQuantityType(.bodyMass)
  private let bmiType = HKQuantityType(.bodyMassIndex)
  
  func save(inputData: InputData) async throws {
    guard HKHealthStore.isHealthDataAvailable() else {
      throw SaveError.unavailable
    }
    
    let types: Set<HKSampleType> = {
      var result: Set<HKSampleType> = []
      
      if inputData.weight != nil {
        result.insert(weightType)
      }
      
      if inputData.bmi != nil {
        result.insert(bmiType)
      }
      
      return result
    }()
    
    guard !types.isEmpty else {
      throw SaveError.noMeasurements
    }
    
    try await store.requestAuthorization(toShare: types, read: [])
    
    guard types.allSatisfy({
      store.authorizationStatus(for: $0) == .sharingAuthorized
    }) else {
      throw SaveError.permissionDenied
    }
    
    
    let date: Date = .now
    
    
    let samples: [HKObject] = {
      var result: [HKObject] = []
      
      if let weight = inputData.weight {
        result.append(
          HKQuantitySample(
            type: weightType,
            quantity: HKQuantity(
              unit: .gramUnit(with: .kilo),
              doubleValue: Double(weight) / 10
            ),
            start: date,
            end: date
          )
        )
      }
      
      if let bmi = inputData.bmi {
        result.append(
          HKQuantitySample(
            type: bmiType,
            quantity: HKQuantity(
              unit: .count(),
              doubleValue: Double(bmi) / 10
            ),
            start: date,
            end: date
          )
        )
      }
      
      return result
    }()
    
    try await store.save(samples)
  }
}

private enum SaveError: LocalizedError {
  case unavailable
  case permissionDenied
  case noMeasurements
  
  var errorDescription: String? {
    switch self {
    case .unavailable:
      return "Health data is unavailable on this device."
    case .permissionDenied:
      return "Allow WeightRecorder to write Weight and BMI in the Health app's permissions."
    case .noMeasurements:
      return "No data to save."
    }
  }
}
