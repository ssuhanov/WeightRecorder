//
//  InputData.swift
//  WeightRecorder
//
//  Created by Sergii Sukhanov on 17.11.26.
//

import Foundation

final class InputData {
  var heightInCentimeters: Double?
  var weightInKilos: Double
  var bmi: Double
  var bodyFatPercentage: Double
  var leanBodyMassInKilos: Double
  
  init(
    heightInCentimeters: Double? = nil,
    weightInKilos: Double = 73.1,
    bmi: Double = 23.4,
    bodyFatPercentage: Double = 0.162,
    leanBodyMassInKilos: Double = 62.7
  ) {
    self.heightInCentimeters = heightInCentimeters
    self.weightInKilos = weightInKilos
    self.bmi = bmi
    self.bodyFatPercentage = bodyFatPercentage
    self.leanBodyMassInKilos = leanBodyMassInKilos
  }
}
