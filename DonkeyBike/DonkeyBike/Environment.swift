//
//  Environment.swift
//  DonkeyBike
//
//  Created by Aleksander Maj on 30/12/2022.
//

import Foundation

var Current = Environment()

struct Environment {
    var baseURLComponents = URLComponents(string: "https://staging.donkey.bike")!
    
    var jsonDecoder: JSONDecoder = {
        let decoder = JSONDecoder()
        decoder.keyDecodingStrategy = .convertFromSnakeCase
        return decoder
    }()
}
