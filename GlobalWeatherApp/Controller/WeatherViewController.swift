import UIKit

class WeatherViewController: UIViewController{
    
    @IBOutlet weak var searchTextField: UITextField!
    @IBOutlet weak var cityNameLabel: UILabel!
    @IBOutlet weak var temperatureLabel: UILabel!
 
    @IBOutlet weak var todayBtn: UIButton!
    @IBOutlet weak var weekBtn: UIButton!
    
    @IBOutlet weak var weatherCollectionView: UICollectionView!
    
    var todayOrWeek : Bool = true
    static var cityName: String = "City"
    
    @IBAction func todayBtnPressed(_ sender: UIButton) {
        todayOrWeek = true
        weatherCollectionView.reloadData()
        todayBtn.backgroundColor = UIColor(named: "ungray")
        weekBtn.backgroundColor = UIColor(named: "gray")
    }
    
    @IBAction func WeekBtnPressed(_ sender: UIButton) {
        todayOrWeek = false
        weatherCollectionView.reloadData()
        todayBtn.backgroundColor = UIColor(named: "gray")
        weekBtn.backgroundColor = UIColor(named: "ungray")
    }
    
    var weatherManager = WeatherManager()
    var weatherModel = WeatherModel()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        searchTextField.placeholder = "도시명을 입력해주세요"
        
        weatherManager.delegate = self
        searchTextField.delegate = self
        
        todayBtn.layer.cornerRadius = 20
        todayBtn.layer.maskedCorners = [.layerMinXMinYCorner,.layerMaxXMinYCorner]
        weekBtn.layer.cornerRadius = 20
        weekBtn.layer.maskedCorners = [.layerMinXMinYCorner,.layerMaxXMinYCorner]
        
        weatherManager.createUrl(cityName: "Seoul")
        
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
            print("decoding실패")
            self.searchTextField.text = "존재하지 않는 도시입니다."
        case 2 : print("해독실패")
        default: break
        }
        }
    }
    
    func didUpdateWeather(_ weatherManager: WeatherManager, weatherModel weatherModel_: WeatherModel) {
        DispatchQueue.main.async {
            self.weatherModel = weatherModel_
            self.cityNameLabel.text = WeatherViewController.cityName
            self.temperatureLabel.text = weatherModel_.hourlyTemperature[0]
            self.weatherCollectionView.reloadData()
        }
        
    }
}

extension WeatherViewController: UICollectionViewDataSource{
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        if todayOrWeek == true{
            return weatherModel.hourWeatherId.count
        }
        else{
            return weatherModel.dailyWeatherId.count
        }
       
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = weatherCollectionView.dequeueReusableCell(withReuseIdentifier: "cell", for: indexPath) as! WeatherCollectionViewCell
        
        if todayOrWeek == true{
            cell.temperatureLabel.text = weatherModel.hourlyTemperature[indexPath.row]
            cell.timeLabel.text = weatherModel.todayTime[indexPath.row]
            cell.weatherImg.image = UIImage(named: weatherModel.hourWeatherId[indexPath.row])
        }
        else {
            cell.temperatureLabel.text = weatherModel.dailyTemperature[indexPath.row]
            cell.timeLabel.text = weatherModel.dayWeek[indexPath.row]
            cell.weatherImg.image = UIImage(named: weatherModel.dailyWeatherId[indexPath.row])
        }
        
        
        return cell
    }
    
    
}

