//
//  WeatherData.swift
//  Clima
//
//  Created by Moamen on 27/01/2024.
//  Copyright © 2024 App Brewery. All rights reserved.
//

import Foundation

struct WeatherData: Codable {
    let name: String
    let weather : [weather]
    let main : data
    
}
struct data : Codable {
    let temp : Double
}

struct weather : Codable {
    let description : String
    let id : Int
}
