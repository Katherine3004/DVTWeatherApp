//
//  WeatherService.swift
//  DVTWeatherApp
//
//  Created by Katherine Chambers on 2024/06/13.
//

import Foundation

protocol WeatherService {
    func fetchWeather(lat: String, long: String) async throws -> Weather?
    func fetchForecast(lat: String, long: String) async throws -> Forecast?
}

class WeatherAPI: WeatherService {
    let apiKey = "57fe66849af71309f4bc6699002b3ed6"
    let baseUrl = "https://api.openweathermap.org/data/2.5/"

    
    func fetchWeather(lat: String, long: String) async throws -> Weather? {
        let urlString = "\(baseUrl)weather?lat=\(lat)&lon=\(long)&appid=\(apiKey)&units=metric"
        guard let url = URL(string: urlString) else { throw ApiError.urlError(message: "Error Fetching Weather Data") }
        
        do {
            let (data, _) = try await URLSession.shared.data(from: url)
            let response = try JSONDecoder().decode(Weather.self, from: data)
            return response
        } catch {
            print("DEBUG: Error fetchWeather(lat: \(lat), long: \(long)): \(error)")
            return nil
        }
    }
    
    func fetchForecast(lat: String, long: String) async throws -> Forecast? {
        let urlString = "\(baseUrl)forecast?lat=\(lat)&lon=\(long)&appid=\(apiKey)&units=metric"
        guard let url = URL(string: urlString) else { throw ApiError.urlError(message: "Error Fetching Forecast Data") }
        
        do {
            let (data, _) = try await URLSession.shared.data(from: url)
            if let jsonString = String(data: data, encoding: .utf8) {
                print("DEBUG: Raw JSON response: \(jsonString)")
            }
            let response = try JSONDecoder().decode(Forecast.self, from: data)
            return response
        } catch {
            print("DEBUG: Error fetchForecast(lat: \(lat), long: \(long)): \(error)")
            return nil
        }
    }
}
