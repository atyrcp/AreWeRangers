//
//  NetworkManager.swift
//  AreWeRangers
//
//  Created by alien on 2019/8/17.
//  Copyright © 2019 z. All rights reserved.
//

import Foundation

class NetworkManager {
    typealias completion = (_ dataArray: [TypeReferrenceProtocol]?, _ error: Error?) -> Void
    private var session: URLSession
    private let baseURL = "https://us-central1-redso-challenge.cloudfunctions.net"
    private let endPoint = "/catalog"
    
    func getCellDataUsingCodable(from team: Team, in page: Int, completion: @escaping (APIResponse?, Error?) -> Void) {
        
        let queryItems = [URLQueryItem(name: "team", value: team.rawValue), URLQueryItem(name: "page", value: String(page))]
        var urlComponents = URLComponents(string: baseURL + endPoint)!
        urlComponents.queryItems = queryItems
        guard let url = urlComponents.url else {completion(nil, nil); return}
        let request = URLRequest(url: url)
        
        let task = session.dataTask(with: request) { (data, _, error) in
            if error != nil {
                print(error.debugDescription)
                completion(nil, error)
            }
            
            guard let data = data, let result = try? JSONDecoder().decode(APIResponse.self, from: data) else {completion(nil, nil); return}
            completion(result, nil)
        }
        task.resume()
    }
    
    //another approach using JSONSerialization, same results
    func getCellData(from team: Team, in page: Int, completion: @escaping completion) {
        
        let queryItems = [URLQueryItem(name: "team", value: team.rawValue), URLQueryItem(name: "page", value: String(page))]
        var urlComponents = URLComponents(string: baseURL + endPoint)!
        urlComponents.queryItems = queryItems
        guard let url = urlComponents.url else {return}
        let request = URLRequest(url: url)
        
        let task = session.dataTask(with: request) { (data, _, error) in
            if error != nil {
                print(error.debugDescription)
                completion(nil, error)
            }
            
            guard let data = data, let dictionary = try? JSONSerialization.jsonObject(with: data, options: []) as? [String: Any], let results = dictionary["results"] as? [[String: Any]] else {return}
            
            var dataArray = [TypeReferrenceProtocol]()
            for result in results {
                if let type = result["type"] as? String {
                    switch type {
                    case "employee":
                        let id = result["id"] as? String ?? ""
                        let name = result["name"] as? String ?? ""
                        let position = result["position"] as? String ?? ""
                        let expertise = result["expertise"] as? [String] ?? [""]
                        let avatar = result["avatar"] as? String ?? ""
                        
                        let employee = Employee(type: type, id: id, name: name, position: position, expertise: expertise, avatar: avatar)
                        dataArray.append(employee)
                    case "banner":
                        let url = result["url"] as? String ?? ""
                        
                        let banner = Banner(type: type, url: url)
                        dataArray.append(banner)
                    default:
                        break
                    }
                }
            }
            completion(dataArray, nil)
        }
        task.resume()
    }
    
    //for unit tests, to mock a session
    init(session: URLSession = URLSession.shared) {
        self.session = session
    }
}
