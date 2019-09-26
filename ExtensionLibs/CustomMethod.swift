//
//  CustomMethod.swift
//  ForthComing
//
//  Created by Mobile on 13/10/17.
//  Copyright © 2017 Mobile. All rights reserved.
//

import Foundation
import UIKit
import MapKit
import SwiftSpinner
import QuartzCore


//MARK:- Custom Navigational Controller
class CustomNavigationController: UINavigationController {
	
	override var shouldAutorotate: Bool {
		return false
	}
}

//MARK:- Simulator Check
extension UIDevice {
	var isSimulator: Bool {
		//#if (arch(i386) || arch(x86_64)) && os(iOS)
		#if targetEnvironment(simulator)
			return true
		#else
			return false
		#endif
	}
}


//MARK:- String Formatting
extension String {
	
	// formatting text for currency textField
	func currencyInputFormatting() -> String {
		
		var number: NSNumber!
		let formatter = NumberFormatter()
		formatter.numberStyle = .decimal
//		formatter.currencySymbol = ""
		formatter.maximumFractionDigits = 0
		formatter.minimumFractionDigits = 0
		
		var amountWithPrefix = self
		
		// remove from String: "$", ".", ","
		let regex = try! NSRegularExpression(pattern: "[^0-9]", options: .caseInsensitive)
		amountWithPrefix = regex.stringByReplacingMatches(in: amountWithPrefix, options: NSRegularExpression.MatchingOptions(rawValue: 0), range: NSMakeRange(0, self.characters.count), withTemplate: "")
		
		let double = (amountWithPrefix as NSString).integerValue
		number = NSNumber(value: (double))
		
		// if first number is 0 or all numbers were deleted
		guard number != 0 as NSNumber else {
			return ""
		}
		
		return formatter.string(from: number)!
	}
}



//MARK:- Array in Order
extension Array {
	
	func sortArray(inputArray : NSMutableArray) -> Array<String>{
		return inputArray.sorted { ($0 as! String).localizedCaseInsensitiveCompare($1 as! String) == ComparisonResult.orderedAscending } as! [String]
	}
}



extension UIViewController {
	
	//MARK:- Alternate Navigation Controller Animation Control
	func CustomViewTransition (from: UIViewController, toViewId: String, transitionType: CATransitionType, subType: CATransitionSubtype) {
		
		let transition = CATransition()
		transition.duration = (0.5 as CFTimeInterval)
		transition.timingFunction = CAMediaTimingFunction(name: CAMediaTimingFunctionName.easeInEaseOut)
		transition.type = transitionType
		transition.subtype = subType
		from.navigationController?.view.layer.add(transition, forKey: nil)
		if toViewId == "" {
			from.navigationController?.popViewController(animated: false)
		}
		else {
			from.navigationController?.pushViewController(from.storyboard?.instantiateViewController(withIdentifier: toViewId) ?? UIViewController(), animated: false)
		}
	}
	
	
	func LandscapeOrientation() {
		
		let value = UIInterfaceOrientation.landscapeRight.rawValue
		UIDevice.current.setValue(value, forKey: "orientation")
	}
	
	func PortraitOrientation() {
		
		let value = UIInterfaceOrientation.portrait.rawValue
		UIDevice.current.setValue(value, forKey: "orientation")
	}
	
	//MARK:- Data from DataBase
	func getDataFromDB() -> Array<Any> {

		dbFiles.sharedDatabase()
		dbFiles.createEditableCopyOfDatabaseIfNeeded()

		return dbFiles.sharedDatabase().getAllSuburbs("query") as! [Any]
	}
	
	
	//MARK:- Email Check Function
	func isValidEmail(testStr:String) -> Bool {
		let emailRegEx = "[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,64}"
		
		let emailTest = NSPredicate(format:"SELF MATCHES %@", emailRegEx)
		return emailTest.evaluate(with: testStr)
	}
	
	//MARK:- Array Values Shortening
	func shortStringArray (string : String) -> String {
		var getData = Array<Any>()
		
		print("Short String : \(string.components(separatedBy: " "))")
		getData = string.components(separatedBy: " ")
		if getData.count < 2 {
			
		}
		else {
			
			getData.removeLast()
		}
		
		print(getData)
		var str = ""
		for i in 0...getData.count-1 {
			str.append(getData[i] as! String + "")
		}
		print("str : \(str)")
		return str
	}
	
	
	
	//MARK:- Phone Number Functions
	func formatNumber(textField : UITextField) -> String {
		var mobileNumber = textField.text
		
		mobileNumber = mobileNumber?.replacingOccurrences(of: "(", with: "")
		mobileNumber = mobileNumber?.replacingOccurrences(of: ")", with: "")
		mobileNumber = mobileNumber?.replacingOccurrences(of: " ", with: "")
		mobileNumber = mobileNumber?.replacingOccurrences(of: "-", with: "")
		mobileNumber = mobileNumber?.replacingOccurrences(of: "+", with: "")
		
		let length = Int((mobileNumber?.characters.count)!)
		if length > 10 {
//			mobileNumber = mobileNumber?.substring(from: (mobileNumber?.index((mobileNumber?.startIndex)!, offsetBy: length - 10))!)
			textField.text = "\(mobileNumber![(mobileNumber?.index((mobileNumber?.startIndex)!, offsetBy: -10))!])"
		}
		return mobileNumber!
	}
	
	func getLength(textField : UITextField) -> Int {
		var mobileNumber = textField.text
		
		mobileNumber = mobileNumber?.replacingOccurrences(of: "(", with: "")
		mobileNumber = mobileNumber?.replacingOccurrences(of: ")", with: "")
		mobileNumber = mobileNumber?.replacingOccurrences(of: " ", with: "")
		mobileNumber = mobileNumber?.replacingOccurrences(of: "-", with: "")
		mobileNumber = mobileNumber?.replacingOccurrences(of: "+", with: "")
		let length = Int((mobileNumber?.characters.count)!)
		return length
	}
	
	func checkEnglishPhoneNumberFormat(string: String?, str: String?, txtFld : UITextField) -> Bool{
		
		if string == ""{ //BackSpace
			
			return true
			
		}
		else if str!.characters.count < 3{
			
//			if str!.characters.count == 1{
//
//				txtFld.text = "("
//			}
			
		}
		else if str!.characters.count == 5 {
			
			txtFld.text = txtFld.text! + " "
			
		}
		else if str!.characters.count == 9 {
			
			txtFld.text = txtFld.text! + " "
			
		}
		else if str!.characters.count > 12 {
			
			return false
		}
		
		return true
	}
    
    func formatPhoneNumber (string : String) -> String {
        
        var newStr = String()
        
        for i in 0..<string.count {
            let index = string.index(string.startIndex, offsetBy: i)
            print("Int : \(i)  Str : \(string[index])")
            
            if i == 4 {
                newStr.append(" ")
                newStr.append(string[index])
            }
            else if i == 7 {
                newStr.append(" ")
                newStr.append(string[index])
            }
                //            else if i == 9 {
                //                newStr.append(" ")
                //                newStr.append(string[index])
                //            }
            else {
                newStr.append(string[index])
            }
            
        }
        print("New String : \(newStr)")
        return newStr
    }
	
	//MARK:- Geo Location For Address
	
	func showAddressLocation(address: String, mapView: MKMapView) {
		
		let geoCoder = CLGeocoder()
		geoCoder.geocodeAddressString(address) { (placemarks, error) in
			print("Location : ",placemarks!)
			guard
				let placemarks = placemarks,
				let location = placemarks.first?.location
				else {
					// handle no location found
					return
			}
			
			let center = CLLocationCoordinate2D(latitude: location.coordinate.latitude, longitude: location.coordinate.longitude)
			let region = MKCoordinateRegion(center: center, span: MKCoordinateSpan(latitudeDelta: 0.01, longitudeDelta: 0.01))
			
			print("Center : \(center)    Region : \(region)")
			mapView.setRegion(region, animated: true)
			// Use your location
			let myAnnotation: MKPointAnnotation = MKPointAnnotation()
			myAnnotation.coordinate = CLLocationCoordinate2DMake(location.coordinate.latitude, location.coordinate.longitude);
			myAnnotation.title = address
			mapView.addAnnotation(myAnnotation)
		}
		
	}
	
	
	func sendCoordinates(address: String) -> CLLocationCoordinate2D {
		
		var loc = CLLocationCoordinate2D()
		
		let geoCoder = CLGeocoder()
		geoCoder.geocodeAddressString(address) { (placemarks, error) in
			guard
				let placemarks = placemarks,
				let location = placemarks.first?.location
				else {
					// handle no location found
					return
			}
			loc = CLLocationCoordinate2D(latitude: location.coordinate.latitude, longitude: location.coordinate.longitude)
			print("Give Location : \(location.coordinate.latitude) \(location.coordinate.longitude)")
		}
		
		return loc
	}
	
	
	func sendCoord(address: String, completion: @escaping (CLLocationCoordinate2D) -> ())  {
		
		var loc = CLLocationCoordinate2D()
		
		let geoCoder = CLGeocoder()
		geoCoder.geocodeAddressString(address) { (placemarks, error) in
			guard
				let placemarks = placemarks,
				let location = placemarks.first?.location
				else {
					// handle no location found
					return
			}
			loc = CLLocationCoordinate2D(latitude: location.coordinate.latitude, longitude: location.coordinate.longitude)
			print("Give Location : \(location.coordinate.latitude) \(location.coordinate.longitude)")
			
			completion(loc)
		}
	}
	
}


extension NSLayoutConstraint {
	/**
	Change multiplier constraint
	
	- parameter multiplier: CGFloat
	- returns: NSLayoutConstraint
	*/
	func setMultiplier(multiplier:CGFloat) -> NSLayoutConstraint {
		
		NSLayoutConstraint.deactivate([self])
		
		let newConstraint = NSLayoutConstraint(
			item: firstItem!,
			attribute: firstAttribute,
			relatedBy: relation,
			toItem: secondItem,
			attribute: secondAttribute,
			multiplier: multiplier,
			constant: constant)
		
		newConstraint.priority = priority
		newConstraint.shouldBeArchived = self.shouldBeArchived
		newConstraint.identifier = self.identifier
		
		NSLayoutConstraint.activate([newConstraint])
		return newConstraint
	}
}

