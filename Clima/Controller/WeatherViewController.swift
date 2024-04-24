
import UIKit
import CoreLocation

class WeatherViewController: UIViewController{
    
    @IBOutlet weak var conditionImageView: UIImageView!
    @IBOutlet weak var temperatureLabel: UILabel!
    @IBOutlet weak var cityLabel: UILabel!
    @IBOutlet weak var searchText: UITextField!
    
    var weather = WeatherManger()
    let locatoion = CLLocationManager()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        locatoion.delegate = self
        locatoion.requestWhenInUseAuthorization()
        locatoion.requestLocation()
        weather.delegate = self
        searchText.delegate = self
    }
    
    @IBAction func locationPressed(_ sender: UIButton) {
        locatoion.requestLocation()
    }
    
}

extension WeatherViewController : UITextFieldDelegate {
    @IBAction func searchPressed(_ sender: UIButton) {
        searchText.endEditing(true)
        print(searchText.text!)
    }
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        searchText.endEditing(true)
        print(searchText.text!)
        return true
    }
    func textFieldShouldEndEditing(_ textField: UITextField) -> Bool {
        if searchText.text != "" {
            return true
        }else {
            searchText.placeholder = "Type Your City"
            return false
        }
    }
    func textFieldDidEndEditing(_ textField: UITextField) {
        if let city = searchText.text {
            weather.fetchWeather(cityName: city)
        }
        searchText.text = ""
    }
}

extension WeatherViewController : WeatherMangerDelegate {
    
    func didUpdataWeather(weather : WeatherModel){
        DispatchQueue.main.async {
            self.temperatureLabel.text = weather.tempString
            self.cityLabel.text = weather.cityName
            self.conditionImageView.image = UIImage(systemName: weather.conditionName)
        }
    }
    func didfailWeather(error: Error) {
        print(error)
    }
}

extension WeatherViewController : CLLocationManagerDelegate {
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        if let location = locations.last {
            locatoion.stopUpdatingLocation()
            let lat = location.coordinate.latitude
            let lon = location.coordinate.longitude
            weather.fetchWeather(latitude : lat , longitude: lon)
        }
    }
    func locationManager(_ manager: CLLocationManager, didFailWithError error: Error) {
        print(error)
    }
}

