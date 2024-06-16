//
//  WeatherService.swift
//  DVTWeatherApp
//
//  Created by Katherine Chambers on 2024/06/13.
//

import Foundation

protocol WeatherService {
    func fetchWeather(lat: String, long: String) async throws -> Weather?
    func fetchForcast(lat: String, long: String) async throws -> Forecast?
}


class WeatherAPI: WeatherService {
    let apiKey = "57fe66849af71309f4bc6699002b3ed6"
    let baseUrl = "https://api.openweathermap.org/data/2.5/weather"
    
    func fetchWeather(lat: String, long: String) async throws -> Weather? {
        let urlString = "\(baseUrl)?lat=\(lat)&lon=\(long)&appid=\(apiKey)"

//    https://api.openweathermap.org/data/2.5/weather?lat=-29.85&lon=31.02&appid=57fe66849af71309f4bc6699002b3ed6
// "https://api.openweathermap.org/data/2.5/forecast?lat=-29.85&lon=31.02&appid=57fe66849af71309f4bc6699002b3ed6&units=metric"
        guard let url = URL(string: urlString) else { throw ApiError.urlError(message: "Error Fetching Weather Data") }
        
        do {
            let (data, _) = try await URLSession.shared.data(from: url)
            let response = try? JSONDecoder().decode(Weather.self, from: data)
            
            return response
        }
        catch {
            print("DEBUG: Error fetchWeather(city: String, lat: String, long: String): \(error)")
            return nil
        }
    }
    
    func fetchForcast(lat: String, long: String) async throws -> Forecast? {
        let urlString = "\(baseUrl)?lat=\(lat)&lon=\(long)&appid=\(apiKey)&units=metric"
        guard let url = URL(string: urlString) else { throw ApiError.urlError(message: "Error Fetching Forcast Data") }
        do {
            let (data, _) = try await URLSession.shared.data(from: url)
            let response = try JSONDecoder().decode(Forecast.self, from: data)
            
            return response
        }
        catch {
            print("DEBUG: Error fetchForcast(lat: String, long: String): \(error)")
            return nil
        }
    }
}

