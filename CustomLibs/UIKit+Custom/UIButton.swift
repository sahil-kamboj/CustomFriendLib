//
//  UIButton.swift
//
//  Created by Lakhwinder Singh on 01/08/17.
//  Copyright © 2017 lakh. All rights reserved.
//

import UIKit

extension UIButton {
    
    var image: UIImage {
        get {
            return image(for: .normal)!
        }
        set {
            setImage(newValue, for: .normal)
        }
    }
    

    
    func setButtonBorder(){
        self.layer.borderColor = UIColor.white.cgColor
        self.layer.borderWidth = 0.5
        self.layer.masksToBounds = true
    }
}


