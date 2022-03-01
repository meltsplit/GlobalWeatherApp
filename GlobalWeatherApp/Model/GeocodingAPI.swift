import Foundation

struct GeocodingAPI : Codable{
    let name : String
    let local_names : LocalNames
    let lon : Double
    let lat : Double
}
struct LocalNames: Codable{
    let ko : String
}
