//
//  MyWeatherViewController.swift
//  Climate-Now
//
//  Created by pradeep reddy kumbam on 06/03/22.
//

import UIKit
import CoreLocation


class MyWeatherViewController: UIViewController {
    
    @IBOutlet weak var conditionImageView: UIImageView!
    
    @IBOutlet weak var tempLabl: UILabel!
    @IBOutlet weak var cityLabel: UILabel!
   
    @IBOutlet weak var searchTextField: UITextField!
    
    var weatherManager = WeatherManager()
    let locationManager = CLLocationManager()
    let loader = UIActivityIndicatorView()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        locationManager.delegate = self
        locationManager.requestWhenInUseAuthorization()
        locationManager.requestLocation()
        
        weatherManager.delegate = self
        searchTextField.delegate = self
        
        loader.center = self.view.center
        loader.style = .large
        self.view.addSubview(loader)
        
    }

}


// MARK: - UITextFieldDelegate

extension MyWeatherViewController: UITextFieldDelegate{
    
    func textFieldShouldEndEditing(_ textField: UITextField) -> Bool {
        if textField.text != "" {
            return true
        }
        else{
            textField.placeholder = "Enter City Name"
            return false
        }
    }
    
    func textFieldDidEndEditing(_ textField: UITextField) {
        
        if let city = searchTextField.text {
            weatherManager.fetchWeather(cityName: city)
            
            loader.startAnimating()
        }
        searchTextField.text = ""
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.endEditing(true)
        return true
    }
    
    
    @IBAction func searchBtnClicked(_ sender: UIButton) {
        searchTextField.endEditing(true)
    }
    
}


// MARK: - WeatherManagerDelegate

extension MyWeatherViewController: WeatherManagerDelegate{

func didUpdateWeather(_ weatherManager: WeatherManager, _ weather: WeatherModel) {
    DispatchQueue.main.async {
        self.loader.stopAnimating()
        self.cityLabel.text = weather.name
        self.tempLabl.text = String(weather.DoubleToOneDecimal)
        self.conditionImageView.image = UIImage(systemName: weather.conditionName)
    }
}

func didFailWithError(error: Error){
    print(error)
}
}


// MARK: - CLLocationManagerDelegate

extension MyWeatherViewController: CLLocationManagerDelegate{


@IBAction func currentLocationBtnClicked(_ sender: UIButton) {
    locationManager.requestLocation()
    loader.startAnimating()
}

func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
    
    if let location = locations.last{
        locationManager.stopUpdatingLocation()
        let lat = location.coordinate.latitude
        let lon = location.coordinate.longitude
        weatherManager.fetchWeatherUsing(lattitude: lat, longitude: lon)
    }
}

func locationManager(_ manager: CLLocationManager, didFailWithError error: Error) {
    print(error)
}
}
