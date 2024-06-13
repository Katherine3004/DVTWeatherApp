//
//  WeatherService.swift
//  DVTWeatherApp
//
//  Created by Katherine Chambers on 2024/06/13.
//

import Foundation

protocol WeatherService {
    func fetchWeather(lat: String, long: String) async throws -> Weather?
}


class WeatherAPI: WeatherService {
    //https://api.openweathermap.org/data/2.5/weather?lat=44.34&lon=10.99&appid={API key}
    let apiKey = "57fe66849af71309f4bc6699002b3ed6"
    let baseUrl = "https://api.openweathermap.org/data/2.5/weather"
    
    func fetchWeather(lat: String, long: String) async throws -> Weather? {
        let url = "\(baseUrl)?lat=\(lat)&lon=\(long)&appid=\(apiKey)"
        print(url)
        guard let url = URL(string: url) else { throw ApiError.urlError(message: "Error Fetching Weather Data")}
        
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
    
}

