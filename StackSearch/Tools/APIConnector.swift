//
//  APIConnector.swift
//  StackSearch
//
//  Created by Kyle Carlos Fernandez on 2018/11/24.
//  Copyright © 2018 KyleApps. All rights reserved.
//

import Foundation
import UIKit

class APIConnector
{
    // api delegate setup
    var delegate: APIDelegate?
    init(delegate: APIDelegate?)
    {
        self.delegate = delegate
    }
    
    // method to connect to stackoverflow rest api "GET"
    func getMethod(pageSize: String, tag: String) {
        
        // Set up the URL request
        let URLString: String = "https://api.stackexchange.com/2.2/questions?pagesize=" + pageSize  + "&order=desc&sort=activity&tagged=" + tag + "&site=stackoverflow&filter=withbody"

        // URL components to encode the string because it contains special characters.
        let components = transformURLString(URLString)
        
        
        guard let url = components?.url else {
            print("Error: cannot create URL")
            return
        }
        let urlRequest = URLRequest(url: url)
        
        // set up the session
        let config = URLSessionConfiguration.default
        let session = URLSession(configuration: config)
        
        // make the request
        let task = session.dataTask(with: urlRequest) {
            (data, response, error) in
            // check for any errors
            guard error == nil else {
                print("error calling GET")
                print(error!)
                return
            }
            // make sure we have data
            guard let responseData = data else {
                print("Error: did not receive data")
                return
            }
            // parse the result as JSON
            do {
                guard let parsed = try JSONSerialization.jsonObject(with: responseData, options: [])
                    as? [String: Any] else {
                        print("error trying to convert data to JSON")
                        return
                }
                self.delegate?.onPostExecute(parsed as NSDictionary)
                
            } catch  {
                print("error trying to convert data to JSON")
                return
            }
        }
        task.resume()
    }
    
    // encode url, because it contains special characters swift is unable to create the URL
    func transformURLString(_ string: String) -> URLComponents? {
        guard let urlPath = string.components(separatedBy: "?").first else {
            return nil
        }
        var components = URLComponents(string: urlPath)
        if let queryString = string.components(separatedBy: "?").last {
            components?.queryItems = []
            let queryItems = queryString.components(separatedBy: "&")
            for queryItem in queryItems {
                guard let itemName = queryItem.components(separatedBy: "=").first,
                    let itemValue = queryItem.components(separatedBy: "=").last else {
                        continue
                }
                components?.queryItems?.append(URLQueryItem(name: itemName, value: itemValue))
            }
        }
        return components!
    }
}
