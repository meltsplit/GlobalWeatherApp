import Foundation

struct WeatherModel{
    let h2 : Int
    let conditionId : [Int]
    let temperature : [Double]
    let time : [Int]
    
    
    var temperatureString: [String]{
        var array:[String] = []
        for i in temperature{
            array.append(String(format: "%.0f°", i))
        }
        return array
    }
    
    var conditionName: [String] {
        var array:[String]=[]
        for i in conditionId{
            switch i{
            case 200...232: array.append("Rain")
            case 300...321: array.append("Rain")
            case 500...532: array.append("Rain")
            case 600...622: array.append("Snow")
            case 701...781: array.append("Wind")
            case 800: array.append("Sun")
            case 801...804: array.append("Cloud")
            default: array.append("xmark")
            }
        }
        return array
    }

    
}


