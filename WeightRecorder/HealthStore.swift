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
  
  func save(weight: Double) async throws {
    guard HKHealthStore.isHealthDataAvailable() else {
      throw SaveError.unavailable
    }
    
    let types: Set<HKSampleType> = [weightType]
    try await store.requestAuthorization(toShare: types, read: [])
    
    guard store.authorizationStatus(for: weightType) == .sharingAuthorized else {
      throw SaveError.permissionDenied
    }
    
    let date: Date = .now
    
    let sample = HKQuantitySample(
      type: weightType,
      quantity: HKQuantity(unit: .gramUnit(with: .kilo), doubleValue: weight),
      start: date,
      end: date
    )
    
    try await store.save(sample)
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
      return "Allow WeightRecorder to write Weight in the Health app's permissions."
    }
  }
}
