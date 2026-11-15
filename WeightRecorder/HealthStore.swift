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
  private let bodyFatPercentageType = HKQuantityType(.bodyFatPercentage)
  private let leanBodyMassType = HKQuantityType(.leanBodyMass)
  
  func save(inputData: InputData) async throws {
    guard HKHealthStore.isHealthDataAvailable() else {
      throw SaveError.unavailable
    }
    
    let types: Set<HKSampleType> = [weightType, bmiType, bodyFatPercentageType, leanBodyMassType]
    
    try await store.requestAuthorization(toShare: types, read: types)
    
    guard types.allSatisfy({
      store.authorizationStatus(for: $0) == .sharingAuthorized
    }) else {
      throw SaveError.permissionDenied
    }
    
    let date: Date = .now
    
    let samples: [HKObject] = [
      HKQuantitySample(
        type: weightType,
        quantity: HKQuantity(
          unit: .gramUnit(with: .kilo),
          doubleValue: inputData.weightInKilos
        ),
        start: date,
        end: date
      ),
      HKQuantitySample(
        type: bmiType,
        quantity: HKQuantity(
          unit: .count(),
          doubleValue: inputData.bmi
        ),
        start: date,
        end: date
      ),
      HKQuantitySample(
        type: bodyFatPercentageType,
        quantity: HKQuantity(
          unit: .percent(),
          doubleValue: inputData.bodyFatPercentage
        ),
        start: date,
        end: date
      ),
      HKQuantitySample(
        type: leanBodyMassType,
        quantity: HKQuantity(
          unit: .gramUnit(with: .kilo),
          doubleValue: inputData.leanBodyMassInKilos
        ),
        start: date,
        end: date
      )
    ]
    
    try await store.save(samples)
  }
}

private enum SaveError: LocalizedError {
  case unavailable
  case permissionDenied
  
  var errorDescription: String? {
    switch self {
    case .unavailable:
      return "Health data is unavailable on this device."
    case .permissionDenied:
      return "Allow WeightRecorder to write Weight and BMI in the Health app's permissions."
    }
  }
}
