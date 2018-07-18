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


var SearchList = NSMutableArray()

var StoreParameters = Dictionary<String, Any>()
var AddPropertyParam = Dictionary<String, Any>()
var EditPropertyParam = Dictionary<String, Any>()

var ViewListingValues = Dictionary<String, Any>()

var SearchParam = Dictionary<String, Any>()


var propertyEdit: Bool = false

var searchPropertyPreview: Bool = false

var searchPropertyEdit: Bool = false

var NewPropertyEdit: Bool = false

var editSecurityPass: Bool = false

var storeImage = Array<Any>()
var showImageIndex = Int()
var propertyID: String = ""
var TaggedID: String = ""

var PropertyType: String = ""
var SuburbIDStr: String = ""
var SuburbTFStr: String = ""


var ServicePropertyID = ""

var MessageAgentName = ""
var MessageAgencyName = ""
var MessageAddress = ""

var latitudeArray = Array<Any>()
var longitudeArray = Array<Any>()




//MARK:- Custom Navigational Controller
class CustomNavigationController: UINavigationController {
	
	override var shouldAutorotate: Bool {
		return false
	}
}

//MARK:- Simulator Check
extension UIDevice {
	var isSimulator: Bool {
		#if (arch(i386) || arch(x86_64)) && os(iOS)
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
	
	func ShowSpinner(title: String) {
		SwiftSpinner.show(title)
	}
	
	func HideSpinner() {
		SwiftSpinner.hide()
	}
	
	//MARK:- Custom Screen Movements
	
	func ViewGoesMyWay(_ screen: UIViewController, viewId: String, direction: String, animate: Bool) {
		let transition = CATransition()
		transition.duration = (0.5 as CFTimeInterval)
		transition.timingFunction = CAMediaTimingFunction(name: kCAMediaTimingFunctionEaseInEaseOut)
		transition.type = kCATransitionFade
		//kCATransitionMoveIn; //, kCATransitionPush, kCATransitionReveal, kCATransitionFade
		if direction == "Left" {
			transition.subtype = kCATransitionFromLeft
		}
		else if direction == "Right" {
			transition.subtype = kCATransitionFromRight
		}
		//kCATransitionFromLeft, kCATransitionFromRight, kCATransitionFromTop, kCATransitionFromBottom
		screen.navigationController?.view.layer.add(transition, forKey: nil)
		if viewId == "" {
			screen.navigationController?.popViewController(animated: false)
		}
		else {
			screen.navigationController?.pushViewController(screen.storyboard?.instantiateViewController(withIdentifier: viewId) ?? UIViewController(), animated: false)
		}
		
	}
	
	func ViewGoesForward(_ screen: UIViewController, viewId: String) {
		let transition = CATransition()
		transition.duration = (0.5 as CFTimeInterval)
		transition.timingFunction = CAMediaTimingFunction(name: kCAMediaTimingFunctionEaseInEaseOut)
		transition.type = kCATransitionMoveIn
		//kCATransitionMoveIn; //, kCATransitionPush, kCATransitionReveal, kCATransitionFade
		transition.subtype = kCATransitionFromLeft
		//kCATransitionFromLeft, kCATransitionFromRight, kCATransitionFromTop, kCATransitionFromBottom
		screen.navigationController?.view.layer.add(transition, forKey: nil)
		screen.navigationController?.pushViewController(screen.storyboard?.instantiateViewController(withIdentifier: viewId) ?? UIViewController(), animated: false)
	}
	
	func ViewGoesBack(_ screen: UIViewController) {
		let transition = CATransition()
		transition.duration = (0.5 as CFTimeInterval)
		transition.timingFunction = CAMediaTimingFunction(name: kCAMediaTimingFunctionEaseInEaseOut)
		transition.type = kCATransitionMoveIn
		//kCATransitionMoveIn; //, kCATransitionPush, kCATransitionReveal, kCATransitionFade
		transition.subtype = kCATransitionFromRight
		//kCATransitionFromLeft, kCATransitionFromRight, kCATransitionFromTop, kCATransitionFromBottom
		screen.navigationController?.view.layer.add(transition, forKey: nil)
		screen.navigationController?.popViewController(animated: false)
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

		return dbFiles.sharedDatabase().getAllSuburbs("select * from tbSuburbsName") as! [Any]
//		print(suburbArray)
	}
	
	func getSuburbNamesFromServer() {//-> Array<Any> 
		
		Webservice.shared.RequestDataWithGet(apiURL: suburbListURL, param: ["":""]) { (response) in
			
//			print("Suburb Name List : \(response)")
			let st = response.result.value as! NSDictionary
//			print("St : \(st["response"]!)")
			
			let st1 = st["response"]! as! NSArray
//			print("St 1 : \(st1)")
			
			let serverSuburbName = NSMutableArray()
			let serverSuburbId = NSMutableArray()
			let serverSuburbSurrounding = NSMutableArray()
			
			for i in (0..<st1.count) {
				
				let a1 = st1.object(at: i) as! NSDictionary
//				arr2.add(a1["data"]!)
//				print("Name Suburb : \(a1["name"]!)")
				serverSuburbId.add(a1["id"]!)
				serverSuburbName.add(a1["name"]!)
				serverSuburbSurrounding.add(a1["surrounding"]!)
			}
			
			UserDefaults.standard.set(serverSuburbId, forKey: "serverSuburbId")
			UserDefaults.standard.set(serverSuburbName, forKey: "serverSuburbName")
			UserDefaults.standard.set(serverSuburbSurrounding, forKey: "serverSuburbSurrounding")
		}
	}
	
	
	func getAgencyListFromServer() {
		
		Webservice.shared.RequestDataWithGet(apiURL: agencyListURL, param: ["":""]) { (response) in
			
			//			print("Suburb Name List : \(response)")
			let st = response.result.value as! NSDictionary
			//			print("St : \(st["response"]!)")
			
			let st1 = st["response"]! as! NSArray
			//			print("St 1 : \(st1)")
			
			let agencyName = NSMutableArray()
			let agencyId = NSMutableArray()
			
			for i in (0..<st1.count) {
				
				let a1 = st1.object(at: i) as! NSDictionary
				//				arr2.add(a1["data"]!)
				//				print("Name Suburb : \(a1["name"]!)")
				agencyId.add(a1["id"]!)
				agencyName.add(a1["name"]!)
			}
			
			UserDefaults.standard.set(agencyId, forKey: "serverAgencyId")
			UserDefaults.standard.set(agencyName, forKey: "serverAgencyName")
		}
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
	
	
	//MARK:- Button Actions
	
//	@IBAction func backBtnClicked(_ sender: Any) {
//
//		if propertyEdit {
//			self.ViewGoesForward(self, viewId: "PreviewProperty")
//		}
//		else {
//			self.navigationController?.popViewController(animated: true)
//		}
//
//	}
	
	//MARK:- Tagged List Web Service
	
	func FetchTaggedList(completion: @escaping (Bool) -> ()) {
		if UserDefaults.standard.value(forKey: "AgentId") as? String == nil || UserDefaults.standard.value(forKey: "Agency_Id") as? String == nil {
			self.presentAlert(title: "Alert!", message: "User id not present. Please login to continue", move: "", shortTime: false)
		}
		else if Webservice.isReachable {
			self.ShowSpinner(title: "Opening Tagged Properties")
			
			print("Show Tagged Properties")
			var param = Dictionary<String, Any>()
			param = ["agentId":UserDefaults.standard.object(forKey: "AgentId") as! String]
			//		param = ["agentId":"5"]
			
			Webservice.shared.RequestDataWithPost(apiURL: getTaggedProperty, param: param, completion: { (response) in
				
				self.HideSpinner()
				//				print("Tagged Properties : \(response.result.value)")
				
				let arr = response.result.value as! NSDictionary
				
				if ((arr["response"] as? NSArray)?.count == 0 ) {
					print("Reponse Not")
					completion(false)
					
				}
				else {
					let arr1 = arr["response"]! as! NSArray
					//					print("Arr 1 : \(arr1)")
					
					let arr2 = NSMutableArray()
					
					for i in (0..<arr1.count) {
						
						let a1 = arr1.object(at: i)
						arr2.add(a1)
					}
					
					SearchList.removeAllObjects()
					SearchList = arr2
					
					print("Search List : \(SearchList)")
					completion(true)
//					self.performSegue(withIdentifier: "ViewListingToTagged", sender: nil)
				}
				
			})
		}
		else {
			self.presentAlert(title: "Alert!", message: "Network connection not found", move: "", shortTime: false)
		}
	}
	
	
	func SearchPropertyList(completion: @escaping (Bool) -> ()) {
		
		if Webservice.isReachable {
			self.ShowSpinner(title: "Requesting...")
			Webservice.shared.RequestDataWithPost(apiURL: SearchPropertyURL, param: SearchParam, completion: { (response) in
				
				self.HideSpinner()
				
				//				print(" Response : \(response)")
				let arr = response.result.value as! NSDictionary
				//				print("Arr : \(arr["response"]!)")
				let arr1 = arr["response"]! as! NSArray
				print("Arr 1 : \(arr1)")
				
				if arr1.count == 0 {
//					self.presentAlert(title: "Alert!", message: "No data found", move: "", shortTime: false)
					completion(false)
				}
				else {
					let arr2 = NSMutableArray()
					
					for i in (0..<arr1.count) {
						
						//					print("Arr 2 : \(arr1.object(at: i))")
						let a1 = arr1.object(at: i) as! NSDictionary
						//					print("Arr 2 Object Data : \(a1["data"]!) ")
						arr2.add(a1)
						//					print("Arr 2 Array : \(arr2)")
					}
					SearchList.removeAllObjects()
					SearchList = arr2
					
					let a3 = arr2.object(at: 0) as! NSDictionary
					
					if a3.object(forKey: "id") as! String == "1" {
						print("Move On")
						//					self.performSegue(withIdentifier: "ViewListingToListData", sender: nil)
						completion(true)
					}
					else {
						completion(false)
						//					self.presentAlert(title: "Alert!", message: "No data found", move: "", shortTime: false)
					}
				}
				
			})
		}
		else {
			self.presentAlert(title: "Alert!", message: "Network connection not found", move: "", shortTime: false)
		}
		
	}
	
	
	
	func sendIgnitionNotification(propertyId: String, propertyType : String, suburbId : String, suburb : String, notiType : String, completion: @escaping (Bool) -> ()) {
		
		var param = [String : Any]()
		param["propertyId"] = propertyId
		param["propertyType"] = propertyType
		param["suburbId"] = suburbId
		param["address"] = suburb
		param["notiType"] = notiType
		
		//notiType(1 for add | 2 for edit)
		if Webservice.isReachable {
			Webservice.shared.RequestDataWithPost(apiURL: SendNotificationURL, param: param, completion: { (response) in
				
				print("Notification Response : \(response.result.value)")
				completion(true)
			})
		}
		else {
			self.presentAlert(title: "Alert!", message: "Network connection not found", move: "", shortTime: false)
		}
		
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
			//UserDefaults.standard.object(forKey: "Latitude") as! CLLocationDegrees
			//UserDefaults.standard.object(forKey: "Longitude") as! CLLocationDegrees
//			NewListingLatitude = location.coordinate.latitude
//			NewListingLongitude = location.coordinate.longitude
			
			let center = CLLocationCoordinate2D(latitude: location.coordinate.latitude, longitude: location.coordinate.longitude)
			let region = MKCoordinateRegion(center: center, span: MKCoordinateSpan(latitudeDelta: 0.01, longitudeDelta: 0.01))
			
			print("Center : \(center)    Region : \(region)")
//			self.propertyMapView.setRegion(region, animated: true)
			mapView.setRegion(region, animated: true)
			// Use your location
			let myAnnotation: MKPointAnnotation = MKPointAnnotation()
			myAnnotation.coordinate = CLLocationCoordinate2DMake(location.coordinate.latitude, location.coordinate.longitude);
			myAnnotation.title = address
//			self.propertyMapView.addAnnotation(myAnnotation)
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
		
//		return loc
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

