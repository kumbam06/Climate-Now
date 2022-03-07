//
//  WeatherManager.swift
//  weather
//
//  Created by pradeep reddy kumbam on 03/03/22.
//

import UIKit

let weatherkey = "ba3b00ab9fd280556f8096d95869ccaa"
let unitType = "metric"

protocol WeatherManagerDelegate {
    func didUpdateWeather(_ weatherManager: WeatherManager ,_ weather: WeatherModel)
    func didFailWithError(error: Error)
}

struct WeatherManager {
    
    var delegate: WeatherManagerDelegate?
    
    let weatherURL = "https://api.openweathermap.org/data/2.5/weather?appid=\(weatherkey)&units=\(unitType)"
    
    func fetchWeather(cityName: String) {
        
        let urlString = "\(weatherURL)&q=\(cityName)"
        performRequest(with: urlString)
    }
    
    func fetchWeatherUsing(lattitude: Double, longitude: Double){
        
        let urlStr = "\(weatherURL)&lat=\(lattitude)&lon=\(longitude)"
        performRequest(with: urlStr)
    }
    
    func performRequest(with urlString: String){
        //1. Create a URL
        if let url = URL(string: urlString){
           
            //2. Create a URL Session
            let session = URLSession(configuration: .default)
            
            //3. Give the session a task
            let task = session.dataTask(with: url) { (data, response, error) in
                
                if error != nil{
                    self.delegate?.didFailWithError(error: error!)
                    return
                }

                if let safeData = data {
                    if let weather = self.parseJSON(using: safeData) {
                        self.delegate?.didUpdateWeather(self, weather)
                    }
                }
            }
            //4. Start the task
            task.resume()
        }
    }
    
    func parseJSON(using weatherData: Data) -> WeatherModel? {
        
        let decoder = JSONDecoder()
        
        do{
            let decodable = try decoder.decode(WeatherData.self, from: weatherData)
            print(decodable.weather.description)
            
            let name = decodable.name
            let temp = decodable.main.temp
            let id = decodable.weather[0].id
            
            let weather = WeatherModel(name: name, temp: temp, conditionid: id)
            
            return weather
            
        }catch{
            self.delegate?.didFailWithError(error: error)
            return nil
        }
        
    }
    
}
