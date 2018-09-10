//
//  TestHelpers.swift
//  RMessage
//
//  Created by Adonis Peralta on 9/9/18.
//  Copyright © 2018 None. All rights reserved.
//

import Foundation

// Returns true or false if the floats are equal to each other after truncating all numbers
// after the scale decimal places
func validateFloatsToScale(_ f1: Float, _ f2: Float, scale: Int) -> Bool {
  let truncFactor = powf(10.0, Float(scale))
  let tFloat1 = truncf(f1 * truncFactor) / truncFactor
  let tFloat2 = truncf(f2 * truncFactor) / truncFactor
  return tFloat1 == tFloat2
}

func springAnimationPadding(forHeight height: Float) -> Float {
  return ceilf(height / 120) * -5.0
}
