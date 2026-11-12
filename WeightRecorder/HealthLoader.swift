//
//  HealthLoader.swift
//  WeightRecorder
//
//  Created by Sergii Sukhanov on 12.11.26.
//

import Foundation
import HealthKit

@MainActor
final class HealthLoader {
  private let store = HKHealthStore()
  
  private let heightType = HKQuantityType(.height)
  private let weightType = HKQuantityType(.bodyMass)
  private let bmiType = HKQuantityType(.bodyMassIndex)
  
  func loadInitialData() async throws -> InputData {
    guard HKHealthStore.isHealthDataAvailable() else {
      throw LoadError.unavailable
    }
    
    let readTypes: Set<HKObjectType> = [heightType, weightType, bmiType]
    
    try await store.requestAuthorization(toShare: [], read: readTypes)
    
    let heightInCentimeters = try await latestValue(for: heightType, unit: .meterUnit(with: .centi))
    let weightInKilos = try await latestValue(for: weightType, unit: .gramUnit(with: .kilo))
    let bmi = try await latestValue(for: bmiType, unit: .count())
    
    let defaults = InputData()
    
    return InputData(
      heightInCentimeters: heightInCentimeters,
      weightInKilos: weightInKilos ?? defaults.weightInKilos,
      bmi: bmi ?? defaults.bmi
    )
  }
  
  private func latestValue(for type: HKQuantityType, unit: HKUnit) async throws -> Double? {
    let query = HKSampleQueryDescriptor(
      predicates: [.quantitySample(type: type)],
      sortDescriptors: [SortDescriptor(\.endDate, order: .reverse)],
      limit: 1
    )
    
    let samples = try await query.result(for: store)
    
    guard let sample = samples.first else {
      return nil
    }
    
    return sample.quantity.doubleValue(for: unit)
  }
}

private enum LoadError: LocalizedError {
  case unavailable
  
  var errorDescription: String? {
    switch self {
    case .unavailable:
      return "Health data is unavailable on this device."
    }
  }
}
