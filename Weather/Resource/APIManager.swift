import UIKit

import Alamofire
import SwiftyJSON

class RequestWeatherAPI {
    static let shared = RequestWeatherAPI()
    
    private init() { }
    
    func requestOpenWeather(_ lat: Double,_ lon: Double, _ completionHandler: @escaping (WeatherInfo, [String]) -> ()) {
        let url = "\(EndPoint.openWeatherURL)lat=\(lat)&lon=\(lon)&appid=\(APIKey.openWeather)"
        
        AF.request(url, method: .get).validate(statusCode: 200...400).responseData(queue: .global()) { response in
            switch response.result {
            case .success(let value):
                let json = JSON(value)
                print("JSON: \(json)")
                
                let weatherInfo = WeatherInfo(
                    weatherIcon: json["weather"][0]["icon"].stringValue,
                    weatherTemp: (json["main"]["temp"].doubleValue - 273.15),
                    weatherHumidity: json["main"]["humidity"].intValue,
                    weatherWindSpeed: json["wind"]["speed"].doubleValue
                )
                let list = [
                    "지금은 \(String(format: "%.1f", weatherInfo.weatherTemp))°C",
                    "\(String(describing: weatherInfo.weatherHumidity))%만큼 습해요",
                    "\(String(format: "%.1f", weatherInfo.weatherWindSpeed))m/s의 바람이 불어요"
                ]
                completionHandler(weatherInfo, list)
                
            case .failure(let error):
                print(error)
            }
        }
    }
}
