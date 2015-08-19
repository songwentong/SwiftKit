//
//  WTRequestCenter.swift
//  SwiftKit
//
//  Created by SongWentong on 8/16/15.
//  Copyright (c) 2015 QuantGroup. All rights reserved.
//

import UIKit


public class WTRequestCenter: NSObject {
    
    public static let sharedInstance: WTRequestCenter = {
        return WTRequestCenter()
        }()
    
    
    
    public func requestwithMethod(
        method: Method,
        URLString: URLStringConvertible,
        parameters: [String: AnyObject]? = nil,
        completionHandler: ((NSData!, NSURLResponse!, NSError!) -> Void)?)
    {
        self.requestwithMethod(method, URLString: URLString, parameters: parameters, headers: nil) { (data, response, error) -> Void in
            completionHandler!(data,response,error)
        }
    }
    /*
        func dataTaskWithRequest(request: NSURLRequest, completionHandler: ((NSData!, NSURLResponse!, NSError!) -> Void)?) -> NSURLSessionDataTask
    */
    public func requestwithMethod(
        method: Method,
        URLString: URLStringConvertible,
        parameters: [String: AnyObject]? = nil,
        headers: [String: String]? = nil,
        completionHandler: ((NSData!, NSURLResponse!, NSError!) -> Void)?)
    {
        let mutableURLRequest = URLRequest(method, URLString: URLString, headers: headers)
        let encodedURLRequest = encode(mutableURLRequest, parameters: parameters).0
        let task = NSURLSession.sharedSession().dataTaskWithRequest(encodedURLRequest, completionHandler: { (data, response, error) -> Void in
            completionHandler!(data,response,error)
        })
        task.resume()
    }
    
    
    
    
    
    
    public func encode(URLRequest: URLRequestConvertible, parameters: [String: AnyObject]?) -> (NSMutableURLRequest, NSError?) {
        
        var mutableURLRequest: NSMutableURLRequest = URLRequest.URLRequest.mutableCopy() as! NSMutableURLRequest
        
        if parameters == nil {
            return (mutableURLRequest, nil)
        }
        
        var error: NSError? = nil
        
        func query(parameters: [String: AnyObject]) -> String {
            var components: [(String, String)] = []
            for key in Array(parameters.keys).sort(<) {
                let value: AnyObject! = parameters[key]
                components += queryComponents(key, value)
            }
            
            return "&".join(components.map { "\($0)=\($1)" } as [String])
        }
        
        func encodesParametersInURL(method: Method) -> Bool {
            switch method {
            case .GET, .HEAD, .DELETE:
                return true
            default:
                return false
            }
        }
        
        if let method = Method(rawValue: mutableURLRequest.HTTPMethod) where encodesParametersInURL(method) {
            if let URLComponents = NSURLComponents(URL: mutableURLRequest.URL!, resolvingAgainstBaseURL: false) {
                URLComponents.percentEncodedQuery = (URLComponents.percentEncodedQuery.map { $0 + "&" } ?? "") + query(parameters!)
                mutableURLRequest.URL = URLComponents.URL
            }
        } else {
            if mutableURLRequest.valueForHTTPHeaderField("Content-Type") == nil {
                mutableURLRequest.setValue("application/x-www-form-urlencoded", forHTTPHeaderField: "Content-Type")
            }
            
            mutableURLRequest.HTTPBody = query(parameters!).dataUsingEncoding(NSUTF8StringEncoding, allowLossyConversion: false)
        }
        
        
        return (mutableURLRequest, error)
        
    }
    func escape(string: String) -> String {
        let generalDelimiters = ":#[]@" // does not include "?" or "/" due to RFC 3986 - Section 3.4
        let subDelimiters = "!$&'()*+,;="
        
        let legalURLCharactersToBeEscaped: CFStringRef = generalDelimiters + subDelimiters
        
        return CFURLCreateStringByAddingPercentEscapes(nil, string, nil, legalURLCharactersToBeEscaped, CFStringBuiltInEncodings.UTF8.rawValue) as String
    }
    
    func queryComponents(key: String,_ value: AnyObject) -> [(String, String)] {
        var components: [(String, String)] = []
        if let dictionary = value as? [String: AnyObject] {
            for (nestedKey, value) in dictionary {
                components += queryComponents("\(key)[\(nestedKey)]", value)
            }
        } else if let array = value as? [AnyObject] {
            for value in array {
                components += queryComponents("\(key)[]", value)
            }
        } else {
            components.append((escape(key), escape("\(value)")))
        }
        
        return components
    }
    
    
}
















