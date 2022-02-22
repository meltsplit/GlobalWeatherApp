import UIKit

class WeatherViewController: UIViewController{
    
    @IBOutlet weak var searchTextField: UITextField!
    @IBOutlet weak var cityNameLabel: UILabel!
    @IBOutlet weak var temperatureLabel: UILabel!
    @IBOutlet weak var weatherDisplayBar: UIView!
    
    
    @IBOutlet var weatherImage : Array<UIImageView>!
    @IBOutlet var weatherTemperatureLabel : Array<UILabel>!
    @IBOutlet var timeLabel : Array<UILabel>!
 
    var weatherManager = WeatherManager()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        searchTextField.placeholder = "도시명을 영어로 입력해주세요"
        weatherDisplayBar.layer.cornerRadius = 30
        
        weatherManager.delegate = self
        searchTextField.delegate = self
        
    }
}

//MARK: - UITextFieldDelegate
extension WeatherViewController : UITextFieldDelegate{
    @IBAction func searchBtnPressed(_ sender: UIButton) {
        searchTextField.endEditing(true)
    }
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        searchTextField.endEditing(true)
        return true
    }
    func textFieldShouldEndEditing(_ textField: UITextField) -> Bool {
        if textField.text != ""{
            return true
        } else{
            searchTextField.placeholder = "도시를 입력하세요."
            return false
        }
        
    }
    func textFieldDidEndEditing(_ textField: UITextField) {
        print(searchTextField.text!)
        let cityName = searchTextField.text!
        weatherManager.createUrl(cityName: cityName)
        //도시를 가지고 날씨를 가져오기.
        
    }
    
    
}

//MARK: - WeatherManagerDelegate
extension WeatherViewController: WeatherManagerDelegate{
    func failUpdateWeather(error: Error,_ errCode: Int) {
        print(error)
        DispatchQueue.main.async {
        switch errCode{
        case 0 : print("url task 실패")
        case 1 :
            print("존재하지 않는 도시")
            self.searchTextField.text = "존재하지 않는 도시입니다."
        case 2 : print("해독실패")
        default: return
        }
        }
    }
    
    func didUpdateWeather(_ weatherManager: WeatherManager, weatherModel: WeatherModel) {
        DispatchQueue.main.async {
            self.cityNameLabel.text = weatherModel.cityName
            self.temperatureLabel.text = weatherModel.temperatureString[0]
            
            for i in 0...4{
                self.weatherImage[i].image = UIImage(named: weatherModel.conditionName[i])
                self.weatherTemperatureLabel[i].text = weatherModel.temperatureString[i]
                self.timeLabel[i].text = String(weatherModel.time[i])+"시"
            }
            self.timeLabel[0].text = "지금"
        }
        
    }
}

