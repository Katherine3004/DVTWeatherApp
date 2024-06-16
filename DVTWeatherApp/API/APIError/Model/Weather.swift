//
//  Weather.swift
//  DVTWeatherApp
//
//  Created by Katherine Chambers on 2024/06/13.
//

import Foundation

//MARK: - Weather
struct Weather: Codable {
    let coord: Coord?
    let weather: [WeatherElement]?
    let base: String?
    let main: Main?
    let visibility: Int?
    let wind: Wind?
    let clouds: Clouds?
    let dt: Int?
    let sys: Sys?
    let timezone, id: Int?
    let name: String?
    let cod: Int?
}

//MARK: - Clouds
struct Clouds: Codable {
    let all: Int?
}

//MARK: - Coord
struct Coord: Codable {
    let lon: Double?
    let lat: Double?
}

//MARK: - Main
struct Main: Codable {
    let temp: Double?
    let feelsLike: Double?
    let tempMin: Double?
    let tempMax: Double?
    let pressure: Int?
    let seaLevel: Int?
    let grndLevel: Int?
    let humidity: Int?
    let tempKf: Double?

    enum CodingKeys: String, CodingKey {
        case temp
        case feelsLike = "feels_like"
        case tempMin = "temp_min"
        case tempMax = "temp_max"
        case pressure
        case seaLevel = "sea_level"
        case grndLevel = "grnd_level"
        case humidity
        case tempKf = "temp_kf"
    }
}

//MARK: - Sys
struct Sys: Codable {
    let type: Int?
    let id: Int?
    let country: String?
    let sunrise: Int?
    let sunset: Int?
}

//MARK: - WeatherElement
struct WeatherElement: Codable {
    let id: Int?
    let main: String?
    let description: String?
    let icon: String?
}

//MARK: - Wind
struct Wind: Codable {
    let speed: Double?
    let deg: Int?
    let gust: Double?
}
