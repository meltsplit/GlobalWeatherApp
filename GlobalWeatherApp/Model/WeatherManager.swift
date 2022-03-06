import Foundation
import UIKit
protocol WeatherManagerDelegate{
    func didUpdateWeather(_ weatherManager : WeatherManager, weatherModel : WeatherModel)
    func failUpdateWeather(error: Error,_ errCode: Int)
}
struct WeatherManager{
    var delegate : WeatherManagerDelegate?
    
    
    func createUrl(cityName: String){
        let cityUrl = "https://api.openweathermap.org/geo/1.0/direct?q=\(cityName)&limit=1&appid=6a999aead6e6daee2426499aab2e37e3"
        if let encodedUrl = cityUrl.addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed)
        {urltasking(encodedUrl,1)}
    }
    func creatUrl(lat: Double,lon:Double){
        let oneCallUrl = "https://api.openweathermap.org/data/2.5/onecall?exclude=minutely&appid=6a999aead6e6daee2426499aab2e37e3&units=metric&lat=\(lat)&lon=\(lon)"
        print("날씨 계산 url주소:" + oneCallUrl)
        urltasking(oneCallUrl,2)
    }
    
    func urltasking(_ inputUrl: String,_ check: Int){
        
        if let url = URL(string: inputUrl){
            let session = URLSession(configuration: .default)
            
            let task = session.dataTask(with: url) { data, response, error in
                if error != nil{
                    self.delegate?.failUpdateWeather(error: error!, 0)
                    return
                }
                if let realdata = data{
                    switch check{
                    case 1:
                        parselatlon(realdata)
                    case 2:
                        if let weather = self.parseForModel(realdata){
                            self.delegate?.didUpdateWeather(self, weatherModel: weather)
                        }
                    default : break  
                    }
                }
            }
            task.resume()
        }
    }
    func parselatlon(_ weatherData: Data) {
        let decoder = JSONDecoder()
        do{
            let decodelatlon = try decoder.decode(Array<GeocodingAPI>.self,from: weatherData)
            let lat = decodelatlon[0].lat
            let lon = decodelatlon[0].lon
            let ko_CityName = decodelatlon[0].local_names.ko
            print(ko_CityName)
            WeatherViewController.cityName = ko_CityName
            creatUrl(lat: lat, lon: lon)
        }catch{
            self.delegate?.failUpdateWeather(error: error, 1)
        }
    }
    func parseForModel(_ weatherData: Data) -> WeatherModel?{
        var weatherModel = WeatherModel()
        let dataTranslator = DataTranslator()
        let decoder = JSONDecoder()
        do{
            
            let decodedData = try decoder.decode(OneCallAPI.self,from: weatherData)
            
            weatherModel.todayTime = dataTranslator.hourCalculator(tz_offset: decodedData.timezone_offset)
            weatherModel.dayWeek = dataTranslator.dayCaluculater(tz_offset: decodedData.timezone_offset)
            
            weatherModel.hourWeatherId = dataTranslator.idTranslator(decodedData.hourly)
            weatherModel.hourlyTemperature = dataTranslator.temperatureTranslator(decodedData.hourly)
            
            weatherModel.dailyWeatherId = dataTranslator.idTranslator(decodedData.daily)
            weatherModel.dailyTemperature = dataTranslator.temperatureTranslator(decodedData.daily)
            
            return weatherModel
            
        }catch{
            self.delegate?.failUpdateWeather(error: error,2)
            return nil
        }
    }
    
}
