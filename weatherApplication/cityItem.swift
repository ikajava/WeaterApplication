//
//  cityItem.swift
//  weatherApplication
//
//  Created by Ika Javakhishvili on 05/1/17.
//  Copyright © 2017 Ika Javakhishvili. All rights reserved.
//

import Foundation

class City {
    var cityName: String!
    var currentWeather: String!
    var arrayOfWeather = [Weather]()

}

class Weather {
    var weather: String!
    var temperature: Int!
    var date: Date!
    var weatherIcon: String!
}
