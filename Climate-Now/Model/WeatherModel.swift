//
//  WeatherModel.swift
//  Climate-Now
//
//  Created by pradeep reddy kumbam on 03/03/22.
//

import Foundation

struct WeatherModel {
    
    let name : String
    let temp : Double
    let conditionid : Int
    
    var DoubleToOneDecimal : String{
        return String(format: "%.f", temp)
    }
    
    var conditionName : String {
        
        switch conditionid {
        case 200...232:
            return "cloud.bolt"
        case 300...321:
            return "cloud.drizzle"
        case 500...531:
            return "cloud.rain"
        case 600...622:
            return "cloud.snow"
        case 701...781:
            return "cloud.fog"
        case 800:
            return "sun.max"
        case 801...804:
            return "cloud.bolt"
        default:
            return "cloud"
        }
    }
    

}
