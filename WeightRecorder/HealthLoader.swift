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
  var height: Int?
  
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
    
    height = try await latestValue(for: heightType, unit: .meter())
    let weight = try await latestValue(for: weightType, unit: .gramUnit(with: .kilo))
    let bmi = try await latestValue(for: bmiType, unit: .count())
    
    let defaults = InputData()
    
    return InputData(
      weight: weight ?? defaults.weight,
      bmi: bmi ?? defaults.bmi
    )
  }
  
  private func latestValue(for type: HKQuantityType, unit: HKUnit) async throws -> Int? {
    let query = HKSampleQueryDescriptor(
      predicates: [.quantitySample(type: type)],
      sortDescriptors: [SortDescriptor(\.endDate, order: .reverse)],
      limit: 1
    )
    
    let samples = try await query.result(for: store)
    
    guard let sample = samples.first else {
      return nil
    }
    
    let value = sample.quantity.doubleValue(for: unit)
    
    return Int((value * 10).rounded())
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
