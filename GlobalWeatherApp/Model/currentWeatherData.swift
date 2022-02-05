import Foundation

struct CurrentWeatherData : Codable{
    let name:String
    let coord: Coord
}
struct Coord : Codable{
    let lon: Double
    let lat: Double
}
