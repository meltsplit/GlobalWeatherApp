import Foundation
import UIKit
protocol WeatherManagerDelegate{
    func didUpdateWeather(_ weatherManager : WeatherManager, weatherModel : WeatherModel)
    func failUpdateWeather(error: Error)
}
struct WeatherManager{
    var url_draft = "https://api.openweathermap.org/data/2.5/weather?&appid=6a999aead6e6daee2426499aab2e37e3&units=metric&q="
    var cityName_S : String = ""
    var delegate : WeatherManagerDelegate?
    
    
    mutating func createUrl(cityName: String){
        cityName_S = cityName
        let cityUrl = url_draft + cityName
        urltasking(cityUrl,1)
    }
    func creatUrl(lat: Double,lon:Double){
        let oneCallUrl_draft = "https://api.openweathermap.org/data/2.5/onecall?exclude=minutely&appid=6a999aead6e6daee2426499aab2e37e3&units=metric"
        let oneCallUrl = String(oneCallUrl_draft+"&lat=\(lat)&lon=\(lon)")
        urltasking(oneCallUrl,2)
    }
    
    func urltasking(_ inputUrl: String,_ check: Int){
        if let url = URL(string: inputUrl){
            
            let session = URLSession(configuration: .default)
            
            let task = session.dataTask(with: url) { data, response, error in
                if error != nil{
                    self.delegate?.failUpdateWeather(error: error!)
                    return
                }
                if let realdata = data{
                    if check == 1 {parselatlon(realdata)}
                    else if check == 2 {
                        if let weather = self.parseForModel(realdata){
                            self.delegate?.didUpdateWeather(self, weatherModel: weather)
                        }
                    }
                    
                }
            }
            task.resume()
        }
    }
    func parselatlon(_ weatherData: Data) {
        let decoder = JSONDecoder()
        do{
            let decodelatlon = try decoder.decode(CurrentWeatherData.self,from: weatherData)
            let lat = decodelatlon.coord.lat
            let lon = decodelatlon.coord.lon
            creatUrl(lat: lat, lon: lon)
        }catch{
            self.delegate?.failUpdateWeather(error: error)
        }
    }
    func parseForModel(_ weatherData: Data) -> WeatherModel?{
        let decoder = JSONDecoder()
        do{
            let decodedData = try decoder.decode(OneCallAPI.self,from: weatherData)
            var weatherId : [Int] = [0,0,0,0,0]
            var weatherTemp : [Double] = [0,0,0,0,0]
            for i in 0...4{
                weatherId[i] = decodedData.hourly[i].weather[0].id
                weatherTemp[i] = decodedData.hourly[i].temp
            }
            let weather = WeatherModel(cityName: cityName_S, conditionId: weatherId, temperature: weatherTemp)
            return weather
        }catch{
            self.delegate?.failUpdateWeather(error: error)
            return nil
        }
    }
    
}
