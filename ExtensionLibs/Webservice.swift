//
//  Webservice.swift
//  Ignite
//
//  Created by Mobile on 29/11/17.
//  Copyright © 2017 Mobile. All rights reserved.
//

import UIKit
import Alamofire

class Webservice: NSObject {
	
	class var isReachable: Bool {
		return NetworkReachabilityManager()!.isReachable
	}
	
	class var shared: Webservice {
		struct Static {
			static let instance: Webservice = Webservice()
		}
		return Static.instance
	}
	
	func RequestDataWithGet (apiURL : String, param : Parameters, completion:@escaping (_ : DataResponse<Any>) ->Void) {
		
		Alamofire.request(URL(string: apiURL)!, method: .get, parameters: param).validate().responseJSON { (response)  in
				
				if (response.result.isSuccess) {
					
//					print("Response : \(response)")
					completion(response)
//					self.getValidDict(result: response.result, completion: {(dict, error) in
////						SVProgressHUD.dismiss()
//						if (dict != nil) {
//							print(response.result)
//							completion(response.result)//true, "success", dict
//						}
//						else {
//							completion()//false, "fail", nil
//						}
//			};)
				}
			
					
//				else {
////					SVProgressHUD.dismiss()
//					completion(false, "fail", nil)
//				}
		}
	}
	
	
	func RequestDataWithPost (apiURL : String, param : Parameters, completion:@escaping (_ : DataResponse<Any>) ->Void) {
		
		Alamofire.request(URL(string: apiURL)!, method: .post, parameters: param).validate().responseJSON { (response)  in
			
			if (response.result.isSuccess) {
				
//				print("Response : \(response)")
				completion(response)
				
			}
			
		}
	}
	
	
	func saveDataToServer (apiURL : String, param : Parameters, completion:@escaping (_ : DataResponse<Any>) ->Void) {
		
		Alamofire.request(URL(string: apiURL)!, method: .post, parameters: param).validate().responseJSON { (response)  in
			
			if (response.result.isSuccess) {
				
				//					print("Response : \(response)")
				completion(response)

			}
			
		}
	}
	
	
	func saveDataWithImages (apiURL : String, param : Parameters, imageArray: Array<Any>, completion: @escaping (_ : DataResponse<Any>) ->Void) {
		// image: UIImage!,
		
		
		
		Alamofire.upload(multipartFormData: { (multipartFormData) in
			for (index, image) in imageArray.enumerated() {
				print("Image index : \(index) , multimg\(index)")
//				multipartFormData.append(UIImagePNGRepresentation(image as! UIImage)!, withName: "multimg\(index)", fileName: "image\(index).png", mimeType: "image/png")
				multipartFormData.append(UIImageJPEGRepresentation((image as! UIImage), 0.5)!, withName: "multimg\(index)", fileName: "image\(index).jpeg", mimeType: "image/jpeg")
			}
			
			for (key, value) in param {
				multipartFormData.append((value as AnyObject).data(using: String.Encoding.utf8.rawValue)!, withName: key)
			}
			print("Multi Form Data : \(multipartFormData.contentType)")
		}, to: apiURL)
		{ (result) in
			switch result {
			case .success(let upload, _, _):
				
				upload.uploadProgress(closure: { (progress) in
					//Print progress
				})
				
				upload.responseJSON { response in
					//print response.result
//					self.getValidDict(result: response.result, completion: {(dict, error) in
						completion(response)//dict?["message"] as! String
						print("Response : \(response)")
						
//					})
				}
				
			case .failure(let encodingError): break
			
			completion (encodingError as! DataResponse<Any>)
				//print encodingError.description
			}
		}

		
	}
	
	
	
	func POSTMethodForImages (apiURL : String, param : Parameters, imageArray: Array<Any>, agentProfileImage: Data?, coagentProfileImage: UIImage, completion:@escaping (_ : DataResponse<Any>) ->Void) {
		// image: UIImage!,
		print("POST Method For Images")
		Alamofire.upload(multipartFormData: { (multipartFormData) in
			for (index, image) in imageArray.enumerated() {
				print("Image index : \(index) , multimg\(index)")
				//				multipartFormData.append(UIImagePNGRepresentation(image as! UIImage)!, withName: "multimg\(index)", fileName: "image\(index).png", mimeType: "image/png")
				multipartFormData.append(UIImageJPEGRepresentation((image as! UIImage), 0.5)!, withName: "multimg\(index)", fileName: "image\(index).jpeg", mimeType: "image/jpeg")
			}
			if agentProfileImage?.count == nil {
				print("Web service -> Agent Image Nil")
			}
			else {
				multipartFormData.append(agentProfileImage!, withName: "firstAgentImage", fileName: "firstAgentImage.jpeg", mimeType: "image/jpeg")
				print("Web service -> Agent Image Not Nil")
			}
			
//			multipartFormData.append(UIImageJPEGRepresentation(coagentProfileImage, 0.5)!, withName: "secondAgentImage", fileName: "secondAgentImage.jpeg", mimeType: "image/jpeg")
			for (key, value) in param {
				multipartFormData.append((value as AnyObject).data(using: String.Encoding.utf8.rawValue)!, withName: key)
			}
			print("Multi Form Data : \(multipartFormData.contentType)")
		}, to: apiURL)
		{ (result) in
			switch result {
			case .success(let upload, _, _):
				
				upload.uploadProgress(closure: { (progress) in
					//Print progress
				})
				
				upload.responseJSON { response in
					//print response.result
					//					self.getValidDict(result: response.result, completion: {(dict, error) in
					completion(response)//dict?["message"] as! String
					print("Response : \(response)")
					
					//					})
				}
				
			case .failure(let encodingError): break
			
			completion (encodingError as! DataResponse<Any>)
				//print encodingError.description
			}
		}
	}
	
	/*
	func requestToResturnAllPosts(withUserId:String!,Type:String,CollegeId:String,completion:@escaping(_:BaseClassReturnAllPosts?)  -> Void) {
	
	let  params:Parameters = [ALL_POSTS_USERID:withUserId,ALL_POSTS_TYPE:Type,ALL_POSTS_COLLEGEID:CollegeId]
	
	print(API_RETURNALL_POSTS)
	
	Alamofire.request(API_RETURNALL_POSTS, method: .get, parameters: params).responseJSON { response in
	
	print(response as Any)
	
	if response.result.value != nil{
	
	let dict: NSDictionary! = response.result.value as! NSDictionary
	self.ReturnAllPosts = BaseClassReturnAllPosts.init(object: dict!)
	
	completion(self.ReturnAllPosts)
	}
	}
	}
	*/
	
	// MARK: - Validate Dictionary Response
	func getValidDict(result: Result<Any>, completion: @escaping (_ : NSDictionary?, _ : NSError?) -> Void) {
		var dict: NSDictionary!
		let errorNew = result.error as NSError?
		if let json = result.value {
			print(json)
			dict = (json as AnyObject).value(forKey: "response") as! NSDictionary
		}
		completion (dict, errorNew)
	}

	
}
