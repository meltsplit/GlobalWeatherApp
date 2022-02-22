import Foundation


func timeCalculator(tz_offset: Int) -> [Int]{
    var timeArray : [Int] = [0,0,0,0,0]
    let date = DateFormatter()
    date.timeZone = TimeZone(secondsFromGMT: tz_offset)
    date.dateFormat = "HH"
    var currentTime = Int(date.string(from: Date())) ?? 0
    for i in 0...4{
        timeArray[i] = currentTime
        currentTime = (currentTime + 1) % 24
    }
    return timeArray
}
