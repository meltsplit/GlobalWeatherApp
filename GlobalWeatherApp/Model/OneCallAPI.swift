import Foundation
struct OneCallAPI : Codable {
    let hourly: [Hourly]
    let daily: [Daily]
}

struct Hourly : Codable {
    let temp : Double
    let weather: [Weather]
}

struct Daily : Codable {
    let temp: DailyTemp
    let weather: [Weather]
}


struct Weather : Codable {
    let id : Int
}

struct DailyTemp : Codable{
    let min: Double
    let max : Double
}
