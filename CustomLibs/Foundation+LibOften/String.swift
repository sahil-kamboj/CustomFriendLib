//
//  String.swift
//  Dropneed
//
//  Created by Lakhwinder Singh on 19/04/17.
//  Copyright © 2017 lakh. All rights reserved.
//

import UIKit

extension String {
    
    
    var local: String {
        return NSLocalizedString(self, comment: "")
    }
    
    var isEmpty: Bool {
        return count == 0 && trimmingCharacters(in: .whitespaces).count == 0
    }
    
    var float: Float {
        return Float(self)!
    }
    
    var int: Int {
        return Int(self)!
    }
    
    var length: Int {
        return count
    }
    
    var htmlToString: String {
        let string = replacingOccurrences(of: "</div>", with: "\n")
        let linesString = string.replacingOccurrences(of: "<[^>]+>", with: "", options: .regularExpression, range: nil)
        var linesArray: [String] = []
        linesString.enumerateLines { line, _ in linesArray.append(line) }
        return linesArray.filter{!$0.isEmpty}.joined(separator: "\n")
    }

    
    func extractURLs() -> [URL] {
        var urls : [URL] = []
        do {
            let detector = try NSDataDetector(types: NSTextCheckingResult.CheckingType.link.rawValue)
            detector.enumerateMatches(in: self, options: [], range: NSMakeRange(0, self.count), using: { (result, _, _) in
                if let match = result, let url = match.url {
                        urls.append(url)
                }
                })
            } catch let error as NSError {
                print(error.localizedDescription)
            }
        
         var refinedUrls : [URL] = []
            for i in 0..<urls.count {
                if i % 5 ==  0 {
                    refinedUrls.append(urls[(i/5)*5+1])
                }
            }
            return refinedUrls
    }
        
    
    func condensingWhitespace() -> String {
        return self.components(separatedBy: .whitespacesAndNewlines)
            .filter { !$0.isEmpty }
            .joined(separator: " ")
    }
}


