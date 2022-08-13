import UIKit

import Alamofire
import SwiftyJSON

class RequestWeatherAPI {
    static let shared = RequestWeatherAPI()
    
    private init() { }
    
    func requestOpenWeather(_ lat: Double,_ lon: Double) {
        let url = "\(EndPoint.openWeatherURL)lat=\(lat)&lon=\(lon)&appid=\(APIKey.openWeather)"
        
        AF.request(url, method: .get).validate(statusCode: 200...400).responseData { response in
            switch response.result {
            case .success(let value):
                let json = JSON(value)
                //                print("JSON: \(json)")
                
            case .failure(let error):
                print(error)
            }
        }
    }
}
