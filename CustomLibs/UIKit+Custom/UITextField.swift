//
//  UITextField.swift
//
//  Created by Lakhwinder Singh on 02/08/17.
//  Copyright © 2017 lakh. All rights reserved.
//

import UIKit

@IBDesignable
class DesignableUITextField: UITextField {
    
    // Provides left padding for images
    override func leftViewRect(forBounds bounds: CGRect) -> CGRect {
        var textRect = super.leftViewRect(forBounds: bounds)
        textRect.origin.x += leftPadding
        return textRect
    }
    
    @IBInspectable var leftImage: UIImage? {
        didSet {
            updateView()
        }
    }
    
    @IBInspectable var leftPadding: CGFloat = 0
    
    @IBInspectable var color: UIColor = UIColor.lightGray {
        didSet {
            updateView()
        }
    }
    
    func updateView() {
        if let image = leftImage {
            leftViewMode = UITextFieldViewMode.always
            let imageView = UIImageView(frame: CGRect(x: 0, y: 0, width: 20, height: 20))
            imageView.contentMode = .scaleAspectFit
            imageView.image = image
            // Note: In order for your image to use the tint color, you have to select the image in the Assets.xcassets and change the "Render As" property to "Template Image".
            imageView.tintColor = color
            leftView = imageView
        } else {
            leftViewMode = UITextFieldViewMode.never
            leftView = nil
        }
        
        // Placeholder text color
        attributedPlaceholder = NSAttributedString(string: placeholder != nil ?  placeholder! : "", attributes:[NSAttributedStringKey.foregroundColor: color])
    }
}

extension UITextField {
    
    func addLeftImage(_ image: UIImage) {
        let margin: CGFloat = 10.0
        leftViewMode = .always
        var width: CGFloat!
        if UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiom.pad {
            width = 50.0
        }else{
            width = 30.0
        }
        
       // width += margin
        
        let view = UIView(frame: CGRect(x: 0, y: 0, width: width+margin, height: bounds.size.height))
        let imageView = UIImageView(frame: CGRect(x: margin, y: 0, width: width-margin, height: bounds.size.height))
        imageView.contentMode = .center
        imageView.clipsToBounds = true
        imageView.image = image
        view.addSubview(imageView)
        leftView = view
    }
    
    func addRightImage(_ leftImage: UIImage) {
        rightViewMode = .always
        var size: CGSize = leftImage.size
        size.width += 10
         let view = UIView(frame: CGRect(x: width-size.width, y: 0, width: size.width, height: bounds.size.height))
        let imgView = UIImageView(frame: CGRect(x: 0, y: 0, width: size.width, height: CGFloat(bounds.size.height)))
        imgView.image = leftImage
        imgView.contentMode = .center
        imgView.isUserInteractionEnabled = false
        view.isUserInteractionEnabled = false
        view.addSubview(imgView)
        rightView = view
    }

    
    func addBottomLabel(_ color: UIColor) {
        let lbl1 = UILabel()
        lbl1.backgroundColor = color
        addSubview(lbl1)
        addVisualConstraints(["H:|[label]|", "V:[label(1)]|"], subviews: ["label": lbl1])
    }
    
    func changePlaceholderColor(_ color: UIColor) {
        attributedPlaceholder = NSAttributedString(string: placeholder!,
                                                   attributes:[NSAttributedStringKey.foregroundColor: color])
    }

    func setTextFieldBorder(){
        self.layer.borderColor = UIColor.white.cgColor
        self.layer.borderWidth = 0.5
        self.layer.masksToBounds = true
    }
    
    func setBlackTextFieldBorder(){
        self.layer.borderColor = UIColor.init(red: 206.0/255.0, green: 206.0/255.0, blue: 206.0/255.0, alpha: 1.0).cgColor
        self.layer.borderWidth = 1.0
        self.layer.masksToBounds = true
    }
    
    func setLeftPaddingPoints(_ amount:CGFloat){
        let paddingView = UIView(frame: CGRect(x: 0, y: 0, width: amount, height: self.frame.size.height))
        self.leftView = paddingView
        self.leftViewMode = .always
    }
    
    //MARK: Email validation variable
    
    var isValidEmail: Bool {
        let emailRegEx = "[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,}"
        let emailTest = NSPredicate(format:"SELF MATCHES %@", emailRegEx)
        return emailTest.evaluate(with: text)
    }
    
    func addDoneCancelToolbar(onDone: (target: Any, action: Selector)? = nil, onCancel: (target: Any, action: Selector)? = nil) {
        let onCancel = onCancel ?? (target: self, action: #selector(cancelButtonTapped))
        let onDone = onDone ?? (target: self, action: #selector(doneButtonTapped))
        
        let toolbar: UIToolbar = UIToolbar()
        toolbar.barStyle = .default
        toolbar.items = [
            UIBarButtonItem(title: "Cancel", style: .plain, target: onCancel.target, action: onCancel.action),
            UIBarButtonItem(barButtonSystemItem: .flexibleSpace, target: self, action: nil),
            UIBarButtonItem(title: "Done", style: .done, target: onDone.target, action: onDone.action)
        ]
        toolbar.sizeToFit()
        
        self.inputAccessoryView = toolbar
    }
    
    // Default actions:
    @objc func doneButtonTapped() { self.resignFirstResponder() }
    @objc func cancelButtonTapped() { self.resignFirstResponder() }
    
}


