//
//  WeatherData.swift
//  weather
//
//  Created by pradeep reddy kumbam on 03/03/22.
//

import Foundation

struct WeatherData: Codable {
    let name : String
    let main : Main
    let weather : [Weather]
    
}

struct Main: Codable {
    let temp : Double
}

struct Weather: Codable {
    let description : String
    let id : Int
    
}
