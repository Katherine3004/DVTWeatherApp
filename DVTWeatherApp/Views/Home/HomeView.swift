//
//  HomeView.swift
//  DVTWeatherApp
//
//  Created by Katherine Chambers on 2024/06/13.
//

import SwiftUI

struct HomeView<ViewModel: HomeViewModelType>: View {
    
    @StateObject var vm: ViewModel
    
    var body: some View {
        VStack(alignment: .center, spacing: 0) {
            if let weather = vm.weather {
                if let condition = vm.weather?.weather?.first?.main {
                    VStack(alignment: .center, spacing: 0) {
                        ZStack(alignment: .center) {
                            Image(weatherBackground(for: condition))
                                .resizable()
                                .frame(height: 383)
                                .frame(maxWidth: .infinity)
                            
                            currentTemp(currentTemp: weather.main?.temp, currentCondition: condition)
                        }
                        
                        HStack(alignment: .center, spacing: 0) {
                            //Min
                            tempData(kelvinTemp: weather.main?.tempMin, label: "min")
                            Spacer()
                            //Current
                            tempData(kelvinTemp: weather.main?.temp, label: "Current")
                            Spacer()
                            //Max
                            tempData(kelvinTemp: weather.main?.tempMax, label: "max")
                        }
                        .padding(.horizontal, 16)
                        .padding(.top, 2)
                        .padding(.bottom, 4)
                        
                        Rectangle()
                            .fill(.white)
                            .frame(height: 1)
                            .frame(maxWidth: .infinity)
                        
                        VStack(alignment: .leading, spacing: 8) {
                            
                        }
                    }
                    .frame(maxWidth: .infinity, maxHeight: .infinity, alignment: .top)
                    .background(
                        Rectangle()
                            .fill(weatherBackgroundColor(for: condition))
                            .frame(maxWidth: .infinity, maxHeight: .infinity)
                    )
                }
            } 
            else {
                Text("Loading weather...")
                    .font(.title)
            }
        }
        .edgesIgnoringSafeArea(.top)
        .onAppear {
            vm.fetachWeather(lat: "-29.85", long: "31.02")
        }
    }
    
    func currentTemp(currentTemp: Double?, currentCondition: String) -> some View {
        VStack(alignment: .center, spacing: 16) {
            let temp = kelvinToCelsius(kelvin: currentTemp)
            Text("\(temp)°")
                .font(.h3)
                .foregroundStyle(Color.white)
            Text(currentCondition)
                .font(.body18)
                .foregroundStyle(Color.white)
        }
    }
    
    func kelvinToCelsius(kelvin: Double?) -> String {
        let celsius = (kelvin ?? 0) - 273.15
        return String(format: "%.0f", celsius)
    }
    
    func tempData(kelvinTemp: Double?, label: String) -> some View {
        VStack(alignment: .center, spacing: 2) {
            let temp = kelvinToCelsius(kelvin: kelvinTemp)
            Text("\(temp)°")
                .font(.body16Medium)
                .foregroundStyle(Color.white)
            Text(label)
                .font(.body14)
                .foregroundStyle(Color.white)
        }
    }
    
    func weatherBackground(for condition: String) -> String {
        switch condition {
        case "Clear":
            return "forest-sunny"
        case "Clouds":
            return "forest-cloudy"
        case "Rain":
            return "forest-rainy"
        default:
            return "forest-sunny"
        }
    }
    
    func weatherBackgroundColor(for condition: String) -> Color {
        switch condition {
        case "Clear":
            return Color.sunny
        case "Clouds":
            return Color.cloudy
        case "Rain":
            return Color.rainy
        default:
            return Color.sunny
        }
    }
}

struct HomeView_Preview: PreviewProvider {
    static var previews: some View {
        let weatherElements = [
            WeatherElement(id: 800, main: "Clear", description: "clear sky", icon: "01n")
        ]
        let main = Main(temp: 310.85, feelsLike: 309.03, tempMin: 310.44, tempMax: 310.85, pressure: 1007, humidity: 18, seaLevel: 1007, grndLevel: 989)
        let wind = Wind(speed: 7.77, deg: 21, gust: 11.92)
        let clouds = Clouds(all: 0)
        let sys = Sys(type: 1, id: 2514, country: "EG", sunrise: 1718333689, sunset: 1718384268)
        let weather = Weather(coord: Coord(lon: 31.02, lat: 29.85), weather: weatherElements, base: "stations", main: main, visibility: 10000, wind: wind, clouds: clouds, dt: 1718387245, sys: sys, timezone: 10800, id: 353219, name: "Madīnat Sittah Uktūbar", cod: 200)
        HomeView(vm: HomeViewModelPreview(weather: weather))
    }
}
