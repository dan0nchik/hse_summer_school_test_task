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

    public var Json =  [String:Any]()
    func getRates(base:String) -> [String:Any]
    {
        var url = URL(string: "https://api.exchangeratesapi.io/latest")!
        if base != ""
        {
            url = URL(string: "https://api.exchangeratesapi.io/latest?base=\(base)")!
        }
        URLSession.shared.dataTask(with: url){
            (data, response, error) in
            guard let data = data else { return }
            Json = try! JSONSerialization.jsonObject(with: data, options: []) as! [String : Any]
        }.resume()
        return Json
    }
