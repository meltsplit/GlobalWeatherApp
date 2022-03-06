import Foundation

struct DataTranslator{
    func hourCalculator(tz_offset: Int) -> [String]{
        var timeArray = [String](repeating: "0", count: 24)
        let date = DateFormatter()
        date.timeZone = TimeZone(secondsFromGMT: tz_offset)
        date.dateFormat = "HH"
        var currentTime = Int(date.string(from: Date())) ?? 0
        for i in 0...23{
            timeArray[i] = String(currentTime)+"시"
            currentTime = (currentTime + 1) % 24
        }
        timeArray[0] = "지금"
        return timeArray
    }

    func dayCaluculater(tz_offset: Int)-> [String]{
        var dayWeek = ["월","화","수","목","금","토","일"]
        let date = DateFormatter()
        date.locale = Locale(identifier: "ko_KR")
        date.timeZone = TimeZone(secondsFromGMT: tz_offset)
        date.dateFormat = "E"
        let today = date.string(from: Date())

        let preNum = dayWeek.firstIndex(of: today)!
        let preDay = dayWeek.prefix(preNum)
        dayWeek.removeFirst(preNum)
        dayWeek.append(contentsOf: preDay)
        dayWeek[0] = "오늘"
        
        return dayWeek
    }
    
    func idTranslator(_ hourlyStruct: [Hourly] ) -> [String] {
        var weatherIdArray:[String]=[]
        for i in 0...23{
            let id = hourlyStruct[i].weather[0].id
                switch id{
                case 200...232: weatherIdArray.append("Rain")
                case 300...321: weatherIdArray.append("Rain")
                case 500...532: weatherIdArray.append("Rain")
                case 600...622: weatherIdArray.append("Snow")
                case 701...781: weatherIdArray.append("Wind")
                case 800: weatherIdArray.append("Sun")
                case 801...804: weatherIdArray.append("Cloud")
                default: weatherIdArray.append("xmark")
                }
            }
            return weatherIdArray
        }
    
    func idTranslator(_ dailyStruct: [Daily] ) -> [String] {
        var weatherIdArray:[String]=[]
        for i in 0...6{
            let id = dailyStruct[i].weather[0].id
                switch id{
                case 200...232: weatherIdArray.append("Rain")
                case 300...321: weatherIdArray.append("Rain")
                case 500...532: weatherIdArray.append("Rain")
                case 600...622: weatherIdArray.append("Snow")
                case 701...781: weatherIdArray.append("Wind")
                case 800: weatherIdArray.append("Sun")
                case 801...804: weatherIdArray.append("Cloud")
                default: weatherIdArray.append("xmark")
                }
            }
            return weatherIdArray
        }
        
    func temperatureTranslator(_ hourlyStruct: [Hourly]) -> [String]{
        var temperatureArray:[String] = []
        for i in 0...23{
            temperatureArray.append(String(format: "%.0f°", hourlyStruct[i].temp))
        }
        return temperatureArray
    }
    
    func temperatureTranslator(_ dailyStruct: [Daily]) -> [String]{
        var temperatureArray:[String] = []
        for i in 0...6{
            temperatureArray.append(String(format: "%.0f~%.0f°", dailyStruct[i].temp.min,dailyStruct[i].temp.max))
           
        }
        return temperatureArray
    }
    
    }

    

