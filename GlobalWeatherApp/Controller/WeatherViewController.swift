import UIKit

class WeatherViewController: UIViewController{
    
    @IBOutlet weak var searchTextField: UITextField!
    @IBOutlet weak var cityNameLabel: UILabel!
    @IBOutlet weak var temperatureLabel: UILabel!
    @IBOutlet weak var weatherDisplayBar: UIView!
    
    @IBOutlet weak var weatherImage_0: UIImageView!
    @IBOutlet weak var weatherImage_1: UIImageView!
    @IBOutlet weak var weatherImage_2: UIImageView!
    @IBOutlet weak var weatherImage_3: UIImageView!
    @IBOutlet weak var weatherImage_4: UIImageView!
    
    @IBOutlet weak var weatherTempLabel_0: UILabel!
    @IBOutlet weak var weatherTempLabel_1: UILabel!
    @IBOutlet weak var weatherTempLabel_2: UILabel!
    @IBOutlet weak var weatherTempLabel_3: UILabel!
    @IBOutlet weak var weatherTempLabel_4: UILabel!
    
    
    var weatherManager = WeatherManager()
    
    override func viewDidLoad() {
        super.viewDidLoad()
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
    func failUpdateWeather(error: Error) {
        print(error)
    }
    
    func didUpdateWeather(_ weatherManager: WeatherManager, weatherModel: WeatherModel) {
        DispatchQueue.main.async {
            self.cityNameLabel.text = weatherModel.cityName
            self.temperatureLabel.text = weatherModel.temperatureString[0]
            self.weatherImage_0.image = UIImage(named: weatherModel.conditionName[0])
            self.weatherImage_1.image = UIImage(named: weatherModel.conditionName[1])
            self.weatherImage_2.image = UIImage(named: weatherModel.conditionName[2])
            self.weatherImage_3.image = UIImage(named: weatherModel.conditionName[3])
            self.weatherImage_4.image = UIImage(named: weatherModel.conditionName[4])
            
            self.weatherTempLabel_0.text = weatherModel.temperatureString[0]
            self.weatherTempLabel_1.text = weatherModel.temperatureString[1]
            self.weatherTempLabel_2.text = weatherModel.temperatureString[2]
            self.weatherTempLabel_3.text = weatherModel.temperatureString[3]
            self.weatherTempLabel_4.text = weatherModel.temperatureString[4]
        }
        
    }
}
