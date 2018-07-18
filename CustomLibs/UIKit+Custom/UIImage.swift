//
//  UIImage.swift
//
//  Created by Lakhwinder Singh on 12/04/17.
//  Copyright © 2017 lakh. All rights reserved.
//

import UIKit

extension UIImage {
    
    convenience init(_ view: UIView) {
        UIGraphicsBeginImageContext(view.frame.size)
        view.layer.render(in: UIGraphicsGetCurrentContext()!)
        let image = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        self.init(cgImage: (image?.cgImage)!)
    }

}


