//
//  ViewController.swift
//  weatherApplication
//
//  Created by Ika Javakhishvili on 05/1/17.
//  Copyright © 2017 Ika Javakhishvili. All rights reserved.
//

import UIKit
import TRON
import SwiftyJSON

class ViewController: UIViewController, UICollectionViewDelegate, UICollectionViewDataSource {
    @IBOutlet weak var collectionView: UICollectionView!

    var weatherArray = [Weather]()
    
    @IBOutlet weak var cityNameLabel: UILabel!
    
    @IBOutlet weak var cityWeatherLabel: UILabel!
    @IBOutlet weak var cityTemperatureLabel: UILabel!
    
    let APIKey = "12fca3f2467c2bbe2ca2727d3c4f4d95"
    let cityName = "Tbilisi"
    let tron = TRON(baseURL: "http://api.openweathermap.org/data/2.5/")

    
    class JSONSuccess: JSONDecodable {
        let a: City
        required init(json: JSON) throws {
            let city = City()
            if let jsonItem = json["city"].dictionary {
                if let cityName = jsonItem["name"] {
                    city.cityName = cityName.string
                }
            }
           
            if let jsonItem = json["list"].array {
               
                for item in jsonItem {
                    let weather = Weather()
                    let date = Date(timeIntervalSince1970: item["dt"].double!)
                    let timeFormatter = DateFormatter()
                    timeFormatter.setLocalizedDateFormatFromTemplate("EEEE dd-mm-yyyy hh:mm")
                    timeFormatter.locale = Locale(identifier: "ka_GE")
  //                  let convertedDate =  timeFormatter.string(from: date)
                    weather.date = date
                    
                    let main = item["main"]
                    weather.temperature = main["temp"].int
                    let weatherName = item["weather"].array
                    for something in weatherName! {
                        weather.weather = something["main"].string
                        weather.weatherIcon = something["icon"].string
                    }
                    
//                    weather.weather = weatherName?["main"]?.string
//                    print(weatherName?["description"])
//                    weather.weatherIcon = weatherName?["icon"]?.string
                    city.arrayOfWeather.append(weather)
                }
                
            }
            a = city
           //print(city.arrayOfWeather.count)
        }
       
       
    }
    
    class JSONError: JSONDecodable {
        required init(json: JSON) throws {
           print("Error")
        }
    }
    
//    https://goo.gl/4z0qiy
//    
//    http://api.openweathermap.org/data/2.5/forecast?q=Tbilisi&appid=12fca3f2467c2bbe2ca2727d3c4f4d95
    
    
    public func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return weatherArray.count
    }
    
    
    // The cell that is returned must be retrieved from a call to -dequeueReusableCellWithReuseIdentifier:forIndexPath:
    
    public func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "cell", for: indexPath) as! weatherCollectionViewCell
        
        cell.temperature.text = ("\(weatherArray[indexPath.row].temperature  - 273) ºC")
        
        return cell
        
    }
    

    override func viewDidLoad() {
        super.viewDidLoad()
        
        collectionView.delegate = self
        collectionView.dataSource = self
        
        let request: APIRequest<JSONSuccess, JSONError> = tron.request("forecast")
        request.parameters = ["q":cityName, "appid" : APIKey]
   
        request.perform(withSuccess: { (JSONSuccess) in
            self.weatherArray = JSONSuccess.a.arrayOfWeather
            
            self.cityNameLabel.text = JSONSuccess.a.cityName
            self.cityWeatherLabel.text = JSONSuccess.a.arrayOfWeather.first?.weather
            self.cityTemperatureLabel.text = ("\((JSONSuccess.a.arrayOfWeather.first?.temperature)! - 273) ºC")
            
            self.collectionView.reloadData()
        
        }) { (JSONError) in
            print(JSONError)
        }

    }

    @IBOutlet weak var jsonReload: UIButton!

    @IBAction func jsonLoad(_ sender: Any) {
        collectionView.reloadData()
    }


}

