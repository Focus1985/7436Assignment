//
//  NetworkingService.swift
//  HelpByDrone
//
//  Created by Focus on 21/10/19.
//  Copyright © 2019 Focus. All rights reserved.
//

import Foundation

class NetworkingService {
    
    let baseUrl = "https://kiloloco.herokuapp.com/api"
    func request(endpoint: String, parameters: [String: Any], completion: @escaping (_ success:Bool) -> Void) {
        guard let url = URL(string: baseUrl + endpoint) else {
            return
        }
        
        var request = URLRequest(url: url)
        var components = URLComponents()
        var queryItems = [URLQueryItem]()
        for (key, value) in parameters {
            let queryItem = URLQueryItem(name: key, value: String(describing: value))
            queryItems.append(queryItem)
        }
        components.queryItems = queryItems
        let queryItemData = components.query?.data(using: .utf8)
        request.httpBody = queryItemData
        request.httpMethod = "POST"
        request.addValue("application/x-www-form-urlencoded", forHTTPHeaderField: "Content-Type")
        let session = URLSession.shared
        let task = session.dataTask(with: request) {(data, response, error) in
            DispatchQueue.main.async {
                guard let unwrappedResponse = response as? HTTPURLResponse else {
                    
                    return
                }
                switch unwrappedResponse.statusCode {
                case 200 ..< 300:
                    completion(true)
                    print("success")
                default:
                    completion(false)
                    print("connection failure")
                }
            }
        }
        task.resume()
    }
}
