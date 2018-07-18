//
//  UITextView.swift
//  BigJoe
//
//  Created by CSPC162 on 31/01/18.
//  Copyright © 2018 CSSOFT. All rights reserved.
//


import  UIKit

extension UITextView {
    
    func setTextViewdBorder(){
        self.layer.borderColor = UIColor.white.cgColor
        self.layer.borderWidth = 0.5
        self.layer.masksToBounds = true
    }
    
}
