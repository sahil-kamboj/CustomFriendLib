//
//  Float.swift
//
//  Created by Lakhwinder Singh on 11/05/17.
//  Copyright © 2017 lakh. All rights reserved.
//

import UIKit

extension Float {
    
    var string: String {
        return NSString(format: "%.2f", self) as String
    }
    
    
    /// Returns a random floating point number between 0.0 and 1.0, inclusive.
    public static var random: Float {
        return Float(arc4random()) / 0xFFFFFFFF
    }
    
    /// Random float between 0 and n-1.
    ///
    /// - Parameter n:  Interval max
    /// - Returns:      Returns a random float point number between 0 and n max
    public static func random(min: Float, max: Float) -> Float {
        return Float.random * (max - min) + min
    }
    
    public static func getRandomNumber(_ min: Float, _ max: Float) -> Float {
        let number = Float.random(min: 0.1, max: 0.4)
        let check = arc4random_uniform(3 - 1) + 1
        return "\(check == 2 ? "+":"-")\(number)".float
    }
    
}

extension Int {
    
    var string: String {
        return NSString(format: "%i", self) as String
    }
    
}

