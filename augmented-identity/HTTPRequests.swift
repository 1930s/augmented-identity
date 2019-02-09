//
//  HTTPRequests.swift
//  augmented-identity
//
//  Created by Edward on 2/9/19.
//  Copyright © 2019 Edward. All rights reserved.
//

import Foundation
import Alamofire

func getRequestWithAlamofire(params : Dictionary<String, String>, url : String){
    Alamofire.request(url, method: .post, parameters: params, encoding: JSONEncoding.default)
        .responseJSON { response in
            print(response)
            //to get status code
            if let status = response.response?.statusCode {
                switch(status){
                case 201:
                    print("example success")
                default:
                    print("error with response status: \(status)")
                }
            }
            //to get JSON return value
            if let result = response.result.value {
                let JSON = result as! NSDictionary
                print(JSON)
            }
    }
}
