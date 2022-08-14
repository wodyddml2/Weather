import UIKit
import CoreLocation

import Kingfisher



class ViewController: UIViewController {
    @IBOutlet weak var headerView: UIView!
    @IBOutlet weak var headerSubView: UIView!
    
    
    @IBOutlet weak var currentDateLabel: UILabel!
    @IBOutlet weak var locationIconImage: UIImageView!
    @IBOutlet weak var currentLocationLabel: UILabel!
    @IBOutlet weak var reloadButton: UIButton!
    
    @IBOutlet weak var weatherTableView: UITableView!
    
    
    let locationManager = CLLocationManager()
    
     
    var weatherInfo: WeatherInfo?
    var weatherList: [String]?
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
      
        weatherTableView.delegate = self
        weatherTableView.dataSource = self
        
        locationManager.delegate = self
        
        headerView.backgroundColor = .clear
        headerSubView.backgroundColor = .clear
        
        currentDate()

        setupUI()
        
    }
    
    func currentDate() {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "MM월 dd일 HH시 mm분"
        
        currentDateLabel.text = dateFormatter.string(from: Date())
        
    }
    
    func setupUI() {
        locationIconImage.image = UIImage(systemName: "location.fill")
        locationIconImage.tintColor = .white
        
        currentDateLabel.textColor = .white
        currentDateLabel.font = .systemFont(ofSize: 14)
        
        currentLocationLabel.textColor = .white
        currentLocationLabel.font = .systemFont(ofSize: 24)
        
        reloadButton.setTitle("", for: .normal)
        reloadButton.setImage(UIImage(systemName: "gobackward"), for: .normal)
        reloadButton.tintColor = .white
        
        weatherTableView.backgroundColor = .clear
         
    }

}

extension ViewController: UITableViewDelegate, UITableViewDataSource {
    func numberOfSections(in tableView: UITableView) -> Int {
        return 2
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        return section == 0 ? weatherList?.count ?? 0 : 1
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let infoCell = tableView.dequeueReusableCell(withIdentifier: WeatherInfoTableViewCell.reuseableIdentifier, for: indexPath) as? WeatherInfoTableViewCell else { return UITableViewCell()
        }
        guard let iconCell = tableView.dequeueReusableCell(withIdentifier: WeatherIconTableViewCell.reuseableIdentifier, for: indexPath) as? WeatherIconTableViewCell else { return UITableViewCell()
        }
        
        if indexPath.section == 0 {
            infoCell.weatherInfoLabel.text = weatherList?[indexPath.row]
            infoCell.backgroundColor = .clear
            return infoCell
        } else {
            iconCell.backgroundColor = .clear
            iconCell.weatherIconImageView.kf.setImage(with: URL(string: "\(EndPoint.openWeatherIconURL)\(weatherInfo?.weatherIcon ?? "10n")@2x.png"))
            iconCell.greetingLabel.text = "오늘도 행복한 하루 보내세요 :)"
            return iconCell
        }
        
    }
    
    
}

extension ViewController {
    func checkUserDeviceLocationAuthorization() {
        let authorization: CLAuthorizationStatus
        
        if #available(iOS 14.0, *) {
            authorization = locationManager.authorizationStatus
        } else {
            authorization = CLLocationManager.authorizationStatus()
        }
        
        if CLLocationManager.locationServicesEnabled() {
            checkUserCurrentLocationAuthorization(authorization)
        } else {
            print("위치 서비스 비활성화임")
        }
    }
    
    func checkUserCurrentLocationAuthorization(_ authorization: CLAuthorizationStatus) {
        switch authorization {
        case .notDetermined:
            locationManager.desiredAccuracy = kCLLocationAccuracyBest
            locationManager.requestWhenInUseAuthorization()
        case .restricted, .denied:
            print("설정")
        case .authorizedWhenInUse:
            locationManager.startUpdatingLocation()
        default: print("default")
        }
    }
}

extension ViewController: CLLocationManagerDelegate {
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        if let coordinate = locations.last?.coordinate {
            RequestWeatherAPI.shared.requestOpenWeather(coordinate.latitude, coordinate.longitude) { weather, list in
                self.weatherInfo = weather
                self.weatherList = list
                DispatchQueue.main.async {
                    self.weatherTableView.reloadData()
                    print(self.weatherInfo)
                    print(self.weatherList)
                }
            }
                    
        }
        locationManager.stopUpdatingLocation()
    }
    
    func locationManagerDidChangeAuthorization(_ manager: CLLocationManager) {
        checkUserDeviceLocationAuthorization()
    }
    func locationManager(_ manager: CLLocationManager, didChangeAuthorization status: CLAuthorizationStatus) {
        
    }
}
