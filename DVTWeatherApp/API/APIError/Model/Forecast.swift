//
//  Forecast.swift
//  DVTWeatherApp
//
//  Created by Katherine Chambers on 2024/06/15.
//

import Foundation

// MARK: - Forecast
struct Forecast: Codable {
    let cod: String?
    let message: Int?
    let cnt: Int?
    let list: [List]?
    let city: City?
}

// MARK: - List
struct List: Codable {
    let dt: Int?
    let main: Main?
    let weather: [WeatherElement]?
    let clouds: Clouds?
    let wind: Wind?
    let visibility: Int?
    let pop: Double?
    let sys: Sys?
    let dtTxt: String?

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

// MARK: - City
struct City: Codable {
    let id: Int?
    let name: String?
    let coord: Coord?
    let country: String?
    let population: Int?
    let timezone: Int?
    let sunrise: Int?
    let sunset: Int?
}
