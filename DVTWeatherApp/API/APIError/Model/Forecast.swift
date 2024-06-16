//
//  Forecast.swift
//  DVTWeatherApp
//
//  Created by Katherine Chambers on 2024/06/15.
//

import Foundation

// MARK: - Forecast
struct Forecast: Codable {
    let cod: String
    let message, cnt: Int
    let list: [List]
}

// MARK: - List
struct List: Codable {
    let dt: Int
    let main: Main
    let weather: [Weather]
    let clouds: Clouds
    let wind: Wind
    let visibility: Int
    let pop: Double
    let sys: Sys
    let dtTxt: String

    enum CodingKeys: String, CodingKey {
        case dt
        case main
        case weather
        case clouds
        case wind
        case visibility
        case pop
        case sys
        case dtTxt = "dt_txt"
    }
}
