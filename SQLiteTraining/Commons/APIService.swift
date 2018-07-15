//
//  APIService.swift
//  SQLiteTraining
//
//  Created by Isaías on 7/14/18.
//  Copyright © 2018 IsaiasMac. All rights reserved.
//

import Foundation
import Alamofire
import SwiftyJSON


class APIService {
    
    static let sharedInstance = APIService()
    let headers = ["Accept": "mobilev2"]
    
    private init(){ }
    
    // Employees
    func getEmployees(completion: @escaping (Bool, [JSON]?) -> ()) {
        let url = "http://localhost:8000/api.php"
        
        Alamofire.request(url, method: .get, headers: headers).responseJSON { response in
            if let value = response.result.value {
                DispatchQueue.global(qos: .background).async {
                    let json = JSON(value)
                    completion(true, json.arrayValue)
                }
            }
            else{
                completion(false, nil)
            }
        }
    }
    
    func get_Employees(page: Int = 1, completion: @escaping (Bool, Data?) -> ()) {
        let url = "http://localhost:8000/api.php?page=\(page)"
        
        let queue = DispatchQueue(label: "cl.isaiasmac.SQLiteTraining", qos: .background, attributes: [.concurrent])
        Alamofire.request(url, method: .get, headers: headers)
            .response(
                queue: queue,
                responseSerializer: DataRequest.jsonResponseSerializer(),
                completionHandler: { response in
                    
                    if let data = response.data {
                        completion(true, data)
                    }
                    else{
                        completion(false, nil)
                    }
            }
        )
    }
    
    func getEmployeesTwo(completion: @escaping (Bool, [JSON]?) -> ()) {
        let url = "http://localhost:8000/api.php"
        Alamofire.request(url, method: .get, headers: headers).responseJSON { response in
            if let value = response.result.value {
                let json = JSON(value)
                completion(true, json.arrayValue)
            }
            else{
                completion(false, nil)
            }
        }
    }
    
    func getCategories(completion: @escaping (Bool, Data?) -> ()) {
        let url = "http://localhost:8000/api.php?endpoint=categories"
        Alamofire.request(url, method: .get, headers: headers).responseJSON { response in
            if let data = response.data {
                completion(true, data)
            }
            else{
                completion(false, nil)
            }
        }
    }
    
    func getCustomers(completion: @escaping (Bool, Data?) -> ()) {
        let url = "http://localhost:8000/api2.php"
        let queue = DispatchQueue(label: "cl.isaiasmac.SQLiteTraining", qos: .background, attributes: [.concurrent])
        Alamofire.request(url, method: .get, headers: headers)
            .response(
                queue: queue,
                responseSerializer: DataRequest.jsonResponseSerializer(),
                completionHandler: { response in
                    
                    autoreleasepool{
                        if let data = response.data {
                            completion(true, data)
                        }
                        else{
                            completion(false, nil)
                        }
                    }
            }
        )
    }
    
    func getCustomersClassic(completion: @escaping (Bool, [CustomerEntity]?) -> ()) {
        let url: URL = URL(string: "http://localhost:8000/api2.php")!
        var request = URLRequest(url: url)
        request.httpMethod = "GET"
        request.timeoutInterval = 10.0
        
        let session = URLSession(configuration: .default, delegate: nil, delegateQueue: nil)
        let task = session.dataTask(with: request) { (data, response, error) in
            if let _error = error {
                print("Error => \(_error.localizedDescription)")
            }
            
            if let httResponse = response as? HTTPURLResponse {
                print("Status code: \(httResponse.statusCode)")
                
                if httResponse.statusCode != 200 {
                    completion(false, nil)
                    return
                }
            }
            
            guard let content = data else {
                fatalError("Error return")
            }
            
            do {
                let decoder = JSONDecoder()
                let customers = try decoder.decode([CustomerEntity].self, from: content)
                completion(true, customers)
            }
            catch {
                print("Error => \(error.localizedDescription)")
                completion(false, nil)
            }
            
        }
        task.resume()
    }
}

