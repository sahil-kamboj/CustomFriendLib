//
//  UIActivityIndicatorView.swift
//
//  Created by Lakhwinder Singh on 23/02/17.
//  Copyright © 2017 paige. All rights reserved.
//

import UIKit

extension UIActivityIndicatorView {

    var setAnimating: Bool {
        get {
            return self.isAnimating
        }
        set {
            if newValue {
                self.startAnimating()
            } else {
                self.stopAnimating()
            }
        }
    }
    
}


