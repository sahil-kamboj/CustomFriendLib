//
//  UIPinchGestureRecognizer.swift
//
//  Created by Lakhwinder Singh on 20/07/17.
//  Copyright © 2017 lakh. All rights reserved.
//

import UIKit

extension UIPinchGestureRecognizer {
    
    func scale(view: UIView) -> (x: CGFloat, y: CGFloat) {
        if numberOfTouches > 1 {
            let touch1 = self.location(ofTouch: 0, in: view)
            let touch2 = self.location(ofTouch: 1, in: view)
            let deltaX = abs(touch1.x - touch2.x)
            let deltaY = abs(touch1.y - touch2.y)
            let sum = deltaX + deltaY
            if sum > 0 {
                let scale = self.scale
                return (1.0 + (scale - 1.0) * (deltaX / sum), 1.0 + (scale - 1.0) * (deltaY / sum))
            }
        }
        return (1, 1)
    }
}

