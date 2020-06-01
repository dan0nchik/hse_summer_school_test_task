//
//  Observer.swift
//  hse_summer_school_test_task
//
//  Created by Daniel Khromov on 5/30/20.
//  Copyright © 2020 Daniel Khromov. All rights reserved.
//

import Foundation
import Alamofire
import Combine

    public var final =  [String:Any]()
    func getRates(base:String, mode:String) -> [String:Any]
    {
        
        var url:String = ""
        if mode == "show"
        {
            url = "https://api.exchangeratesapi.io/latest"}
        else{
            url = "https://api.exchangeratesapi.io/latest?base=\(base)"
        }
        AF.request(url).responseJSON  {
            (response) in
            switch response.result{
            case let .success(value):
                let json = value as? [String:Any]
                let rates = json?["rates"] as! [String : Any]
                final = rates
                case let .failure(error):
                print(error.localizedDescription)
                
            }
        }
        return final
    }
