import Foundation
import CoreLocation

protocol WeatherMangerDelegate {
    func didUpdataWeather(weather : WeatherModel)
    func didfailWeather(error : Error)
}


struct WeatherManger {
    let weatherURL = "https://api.openweathermap.org/data/2.5/weather?appid=ef67d9bee51c2d32d7c360c89406d763&units=metric"
    var delegate : WeatherMangerDelegate?

    
    func fetchWeather(cityName: String) {
        let urlString = "\(weatherURL)&q=\(cityName)"
        performUrl(urlString: urlString)
    }
    
    func fetchWeather(latitude:CLLocationDegrees , longitude : CLLocationDegrees){
        let urlSring = "\(weatherURL)&lat=\(latitude)&lon=\(longitude)"
        performUrl(urlString: urlSring)
    }
    
    

    func performUrl(urlString: String){
        if let url = URL(string: urlString){
            let session = URLSession(configuration: .default)
            let task = session.dataTask(with: url) { data, response , error in
                if error != nil {
                    self.delegate?.didfailWeather(error: error!)
                    return
                }
                if let safeData = data {
                    if let weather = self.parseJSON(weatherData: safeData) {
                        self.delegate?.didUpdataWeather(weather: weather)
                    }
                }
            }
            task.resume()
        }
    }
    
    func parseJSON(weatherData: Data) -> WeatherModel? {
        let decoder = JSONDecoder()
        do{
            let decoderData = try decoder.decode(WeatherData.self , from: weatherData)
            let id = decoderData.weather[0].id
            let name = decoderData.name
            let temp = decoderData.main.temp
            
            let weather = WeatherModel(cityName: name, conditionId: id, temperature: temp)
            return weather
        } catch {
            delegate?.didfailWeather(error: error)
            return nil
        }
    }
   
    
}

