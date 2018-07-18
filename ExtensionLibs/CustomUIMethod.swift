//
//  CustomUIMethod.swift
//  Ignite
//
//  Created by Mobile on 26/12/17.
//  Copyright © 2017 Mobile. All rights reserved.
//

import Foundation
import UIKit


var KBHeight = CGFloat()


//MARK:- Extensions For Bottom Borders
extension UITextField {
	
	func bottomBorder(color : UIColor, borderWidth : CGFloat) {
		let border = CALayer()
		border.borderColor = color.cgColor
		border.frame = CGRect(x: CGFloat(0), y: CGFloat(self.frame.size.height - borderWidth), width: CGFloat(self.frame.size.width), height: CGFloat(self.frame.size.height))
		border.borderWidth = borderWidth
		self.layer.addSublayer(border)
		self.layer.masksToBounds = true
	}
}

extension UIButton {
	
	func topBorderLine(color: UIColor) {
		let border = CALayer()
		border.borderColor = color.cgColor
		border.frame = CGRect(x: 0, y: 0, width: self.frame.size.width, height: 1.0)
		border.borderWidth = 1.0
		self.layer.addSublayer(border)
		self.layer.masksToBounds = true
	}
	
}


extension UIView {
	
	func bottomLine() {
		let border = CALayer()
		border.borderColor = UIColor().redShade().cgColor
		border.frame = CGRect(x: CGFloat(0), y: CGFloat(self.frame.size.height - 1.0), width: CGFloat(self.frame.size.width), height: CGFloat(self.frame.size.height))
		border.borderWidth = 1.0
		self.layer.addSublayer(border)
		self.layer.masksToBounds = true
	}
}


//MARK:- Custom Colors
extension UIColor {
	
	func redShade() -> UIColor {
		
		return UIColor.init(red: 255/255.0, green: 0/255.0, blue: 102/255.0, alpha: 1.0)
	}
	
	func lightShade() -> UIColor {
		
		return UIColor.init(red: 173/255.0, green: 180/255.0, blue: 166/255.0, alpha: 1.0)
	}
}


extension UIViewController {
	
	//MARK:- Keyboard Toolbar
	func keyboardToolbar(doneAction : Selector, cancelAction : Selector) -> UIToolbar {
		
		var optionToolbar = UIToolbar()
		let cancel = UIBarButtonItem(barButtonSystemItem: UIBarButtonSystemItem.cancel, target: self, action: cancelAction)
		
		let flexible = UIBarButtonItem(barButtonSystemItem: UIBarButtonSystemItem.flexibleSpace, target: self, action: nil)
		
		let done = UIBarButtonItem(barButtonSystemItem: UIBarButtonSystemItem.done, target: self, action: doneAction)
		
		optionToolbar = UIToolbar.init(frame: CGRect(x: 0, y: 0, width: self.view.frame.size.width, height: 50))
		optionToolbar.sizeToFit()
		optionToolbar.isTranslucent = true
		optionToolbar.tintColor = UIColor.black
		optionToolbar.items = [cancel, flexible, done]
		
		return optionToolbar
	}
	
	
	//MARK:- Alert Function
	func presentAlert(title: String, message : String, move: String, shortTime : Bool)
	{
		let alertController = UIAlertController(title: title, message: message, preferredStyle: .alert)
		
		let OKAction = UIAlertAction(title: "OK", style: .default) {
			
			(action: UIAlertAction) in print("You've pressed OK Button")
			if (move == "") {
				
			}
			else {
				self.performSegue(withIdentifier: move, sender: nil)
			}
		}
		alertController.addAction(OKAction)
		
		self.present(alertController, animated: true) {
			
			if shortTime {
				let when = DispatchTime.now() + 2 // change 2 to desired number of seconds
				DispatchQueue.main.asyncAfter(deadline: when) {
					print("After 2 Seconds")
					self.dismiss(animated: true, completion: {
						
					})
				}
			}
			else {
				
			}
		}
	}
	
	
	func presentAlertWithCompletion(title: String, message : String, move: String, shortTime : Bool, completion: @escaping (Bool) -> ())
	{
		let alertController = UIAlertController(title: title, message: message, preferredStyle: .alert)
		
		let OKAction = UIAlertAction(title: "OK", style: .default) {
			
			(action: UIAlertAction) in print("You've pressed OK Button")
			if (move == "") {
				completion(true)
			}
			else {
				self.performSegue(withIdentifier: move, sender: nil)
			}
		}
		alertController.addAction(OKAction)
		
		self.present(alertController, animated: true) {
			
			if shortTime {
				let when = DispatchTime.now() + 2 // change 2 to desired number of seconds
				DispatchQueue.main.asyncAfter(deadline: when) {
					print("After 2 Seconds")
					self.dismiss(animated: true, completion: {
//						completion(true)
					})
				}
			}
			else {
//				completion(true)
			}
//			completion(true)
		}
	}
	
	
	func presentAlertWithCancel(title: String, message : String, move: String, shortTime : Bool, completion: @escaping (Bool) -> ())
	{
		let alertController = UIAlertController(title: title, message: message, preferredStyle: .alert)
		
		let OKAction = UIAlertAction(title: "OK", style: .default) {
			
			(action: UIAlertAction) in print("You've pressed OK Button")
			completion(true)
			
		}
		alertController.addAction(OKAction)
		
		if move == "cancel" {
			
		}
		else {
			let CancelAction = UIAlertAction(title: "Cancel", style: .default) {
				
				(action: UIAlertAction) in print("You've pressed Cancel Button")
				completion(false)
			}
			alertController.addAction(CancelAction)
		}
		
		self.present(alertController, animated: true) {
			
		}
	}
	
	
	//MARK:- Move Screen For TextField
	func setViewMovedUp(_ movedUp: Bool, moveByFull full: Bool, kbHeight : CGFloat) {
		
		UIView.beginAnimations(nil, context: nil)
		UIView.setAnimationDuration(0.5)
		
		let KBHeight = kbHeight
		
		var rect: CGRect = self.view.frame
		print("Keyboad : \(KBHeight)")
		
		if movedUp {
			
			if full {
				rect.origin.y -= KBHeight
			}
			else {
				rect.origin.y -= 120//KBHeight * 0.55
			}
		}
		else {
			
			if full {
				rect.origin.y += KBHeight
			}
			else {
				rect.origin.y += 120//KBHeight * 0.55
			}
		}
		self.view.frame = rect
		
		UIView.commitAnimations()
	}
	
	
	@objc func keyboardWillShow(sender: NSNotification) {
		if self.view.frame.origin.y > 0 {
			
		}
//		else if self.view.frame.origin.y < 0 {
//			self.setViewMovedUp(false, moveByFull: false, kbHeight: KBHeight)
//		}
		else if self.view.frame.origin.y == 0 {
			let when = DispatchTime.now() + 0.2
			DispatchQueue.main.asyncAfter(deadline: when) {
				self.setViewMovedUp(true, moveByFull: false, kbHeight: KBHeight)
			}
		}
	}
	
	
	@objc func keyboardPasswordWillShow(sender: NSNotification) {
		print("Keyboard Will Show")
		if self.view.frame.origin.y > 0 {
			
		}
		else if self.view.frame.origin.y == 0 {
			let when = DispatchTime.now() + 0.2
			DispatchQueue.main.asyncAfter(deadline: when) {
				self.setViewMovedUp(true, moveByFull: false, kbHeight: KBHeight)
			}
		}
	}
	
	@objc func keyboardWillHide(sender: NSNotification) {
		print("Keyboard Will Hide")
		if self.view.frame.origin.y == 0 {
			
			//			self.setViewMovedUp(false, moveByFull: false, kbHeight: KBHeight)
		}
		else if self.view.frame.origin.y < 0 {
			
			self.setViewMovedUp(false, moveByFull: false, kbHeight: KBHeight)
		}
		else {
			
		}
	}
	
	@objc func keyboardWillChangeFrame(_ notification: NSNotification) {
		print("Keyboard Will Change Frame")
		let keyboardFrame = (notification.userInfo?[UIKeyboardFrameEndUserInfoKey] as? NSValue)?.cgRectValue
		
		let keyboardHeight = keyboardFrame?.size.height
//		print("Keyboard Height: \(String(describing: keyboardHeight))")
		KBHeight = keyboardHeight! as CGFloat
		
	}
	
	//MARK:- Custom Font Spacing
	func customLabelFont (string: String, onLabel label: UILabel) {
		
		let attributedString = NSMutableAttributedString(string: string)
		attributedString.addAttribute(NSAttributedStringKey.kern, value: CGFloat(2.0), range: NSRange(location: 0, length: attributedString.length))
		label.attributedText = attributedString
	}
	
	func customTFFont (string : String, onTextField textField : UITextField) {
		
		let attributedString = NSMutableAttributedString(string: string)
		attributedString.addAttribute(NSAttributedStringKey.kern, value: CGFloat(2.0), range: NSRange(location: 0, length: attributedString.length))
		textField.attributedText = attributedString
	}
	
	func customPlaceholderFont (text : String, textField : UITextField) {
		let attributedString = NSMutableAttributedString(string: text)
		attributedString.addAttribute(NSAttributedStringKey.kern, value: 2, range: NSMakeRange(0, (textField.placeholder?.count)!))
		textField.attributedPlaceholder = attributedString
	}
	
	func customButtonTitle (title : String, button : UIButton) {
		let attributedString = NSMutableAttributedString(string: title)
		attributedString.addAttribute(NSAttributedStringKey.kern, value: 2, range: NSMakeRange(0, (button.titleLabel?.text?.count)!))
		button.setAttributedTitle(attributedString, for: .normal)
	}
	
	
	func superScriptFont (text : String, label: UILabel) {
		let font:UIFont? = UIFont(name: "GillSans", size:15)
		let fontSuper:UIFont? = UIFont(name: "GillSans", size:8)
		let attString:NSMutableAttributedString = NSMutableAttributedString(string: text, attributes: [NSAttributedStringKey.font:font!])
		attString.setAttributes([NSAttributedStringKey.font:fontSuper!,NSAttributedStringKey.baselineOffset:7], range: NSRange(location:11,length:2))
		attString.setAttributes([NSAttributedStringKey.font:fontSuper!,NSAttributedStringKey.baselineOffset:7], range: NSRange(location:31,length:2))
		label.attributedText = attString;
	}
}

