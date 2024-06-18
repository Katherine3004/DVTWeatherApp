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
        ZStack(alignment: .center) {
            switch vm.state {
            case .loading:
                loadingContent
            case .loaded:
                loadedContent(weather: vm.weather, forecast: vm.forecast)
            case let .error(title, message):
                errorContent(title: title, message: message)
            }
        }
        .edgesIgnoringSafeArea(.top)
        .fullScreenCover(isPresented: $vm.showLocationPermissionSheet) {
            LocationPermissionView(closePermissionSheet: { vm.showLocationPermissionSheet = false })
        }
    }
    
    //loading Content
    var loadingContent: some View {
        VStack(alignment: .center, spacing: 16) {
            Text("Fetching the weather")
                .font(.h5)
                .foregroundStyle(Color.darkCloudy)
            CircleProgressView()
        }
        .frame(maxWidth: .infinity, maxHeight: .infinity)
    }
    
    //loaded Content
    func loadedContent(weather: Weather?, forecast: Forecast?) -> some View {
        Group {
            if let weather = weather, let forecast = forecast {
                if let condition = weather.weather?.first?.main {
                    ScrollView(showsIndicators: false) {
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
                                tempData(temp: weather.main?.tempMin, label: "min")
                                Spacer()
                                //Current
                                tempData(temp: weather.main?.temp, label: "Current")
                                Spacer()
                                //Max
                                tempData(temp: weather.main?.tempMax, label: "max")
                            }
                            .padding(.horizontal, 16)
                            .padding(.top, 2)
                            .padding(.bottom, 4)
                            
                            Rectangle()
                                .fill(.white)
                                .frame(height: 1)
                                .frame(maxWidth: .infinity)
                            
                            VStack(alignment: .leading, spacing: 16) {
                                ForEach(getFilteredForecasts(from: forecast).prefix(5), id: \.dt) { item in
                                    forecastData(
                                        dayOfWeek: item.dtTxt,
                                        condition: item.weather?.first?.main ?? "",
                                        temp: item.main?.temp)
                                }
                            }
                            .frame(maxWidth: .infinity)
                            .padding(.horizontal, 16)
                            .padding(.vertical, 24)
                        }
                        .frame(maxWidth: .infinity, maxHeight: .infinity, alignment: .top)
                        .background(
                            Rectangle()
                                .fill(weatherBackgroundColor(for: condition))
                                .frame(maxWidth: .infinity, maxHeight: .infinity)
                        )
                    }
                    .background(weatherBackgroundColor(for: condition))
                }
            }
        }
    }
    
    //error Content
    func errorContent(title: String, message: String) -> some View {
        VStack(alignment: .center, spacing: 8) {
            Image(systemName: "exclamationmark.icloud.fill")
                .font(.system(size: 52))
                .foregroundStyle(Color.cloudy)
                .padding(.bottom, 8)
            Text(title)
                .font(.h3)
                .foregroundStyle(Color.cloudy)
            Text(message)
                .font(.body18)
                .foregroundStyle(Color.cloudy)
                .multilineTextAlignment(.center)
                .padding(.bottom, 16)
            
            Button(action: { vm.load() }, label: {
                Text("Retry")
            })
            .buttonStyle(PrimaryButtonStyle())
        }
        .frame(maxWidth: .infinity, maxHeight: .infinity, alignment: .center)
        .padding(.all, 16)
    }
    
    //Current Temperature and Current Condition
    func currentTemp(currentTemp: Double?, currentCondition: String) -> some View {
        VStack(alignment: .center, spacing: 12) {
            let tempString = String(format: "%.0f", ceil(currentTemp ?? 0))
            Text("\(tempString)°")
                .font(.largeHeading)
                .foregroundStyle(Color.white)
            Text(currentCondition)
                .font(.h4)
                .foregroundStyle(Color.white)
                .textCase(.uppercase)
        }
        .frame(maxWidth: .infinity, alignment: .center)
    }
    
    //Temperature and Label For Todays Min, Current and Max
    func tempData(temp: Double?, label: String) -> some View {
        VStack(alignment: .center, spacing: 2) {
            let tempString = String(format: "%.0f", ceil(temp ?? 0))
            Text("\(tempString)°")
                .font(.body16SemiBold)
                .foregroundStyle(Color.white)
            Text(label)
                .font(.body14)
                .foregroundStyle(Color.white)
        }
    }
    
    //5 Day Forecast
    func forecastData(dayOfWeek: String?, condition: String, temp: Double?) -> some View {
        HStack(alignment: .center, spacing: 0) {
            let tempString = String(format: "%.0f", ceil(temp ?? 0))
            let dayFormatted = dayOfWeekFormatter(from: dayOfWeek ?? "")
            GeometryReader { geometry in
                HStack(alignment: .center, spacing: 0) {
                    Text(dayFormatted)
                        .font(.body16SemiBold)
                        .foregroundStyle(Color.white)
                        .frame(width: geometry.size.width * ((100 / 3) / 100), alignment: .leading)
                    
                    Image(forecastIcon(for: condition))
                        .resizable()
                        .frame(width: 32, height: 32)
                        .frame(width: geometry.size.width * ((100 / 3) / 100), alignment: .center)
                    
                    Text("\(tempString)°")
                        .font(.body16SemiBold)
                        .foregroundStyle(Color.white)
                        .frame(width: geometry.size.width * ((100 / 3) / 100), alignment: .trailing)
                }
            }
            .frame(height: 24)
        }
    }
    
    func getFilteredForecasts(from forecase: Forecast) -> [List] {
        guard let list = forecase.list else { return [] }
        let filteredForecasts = list.filter { item in
            if let dtText = item.dtTxt {
                return dtText.hasSuffix("12:00:00")
            }
            
            return false
        }
        
        return filteredForecasts
    }
    
    //Changes the background image based on the condition that comes back
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
    
    //Changes the background color based on the condition that comes back
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
    
    //Changes the forecast icon based on the condition that comes back
    func forecastIcon(for condition: String) -> String {
        switch condition {
        case "Clear":
            return "clear"
        case "Clouds":
            return "partlysunny"
        case "Rain":
            return "rain"
        default:
            return "sun.max"
        }
    }
    
    //convert date to day of week
    func dayOfWeekFormatter(from dateString: String) -> String {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-dd HH:mm:ss"
        guard let date = dateFormatter.date(from: dateString) else { return "Invalid date" }
        
        let dayFormatter = DateFormatter()
        dayFormatter.dateFormat = "EEEE"
        let dayOfWeek = dayFormatter.string(from: date)
        return dayOfWeek
    }
    
    //Just going to keep this because the temperatures were coming back in Kelvin
    //converts Kelvin to Celsius
    func kelvinToCelsius(kelvin: Double?) -> String {
        let celsius = (kelvin ?? 0) - 273.15
        return String(format: "%.0f", celsius)
    }
}

//struct HomeView_Preview: PreviewProvider {
//    static var previews: some View {
//        let weatherElements = [
//            WeatherElement(id: 800, main: "Clear", description: "clear sky", icon: "01n")
//        ]
//        let main = Main(temp: 310.85, feelsLike: 309.03, tempMin: 310.44, tempMax: 310.85, pressure: 1007, seaLevel: 18, grndLevel: 1007, humidity: 989, tempKf: 1)
//        let wind = Wind(speed: 7.77, deg: 21, gust: 11.92)
//        let clouds = Clouds(all: 0)
//        let sys = Sys(type: 1, id: 2514, country: "EG", sunrise: 1718333689, sunset: 1718384268)
//        let weather = Weather(coord: Coord(lon: 31.02, lat: 29.85), weather: weatherElements, base: "stations", main: main, visibility: 10000, wind: wind, clouds: clouds, dt: 1718387245, sys: sys, timezone: 10800, id: 353219, name: "Madīnat Sittah Uktūbar", cod: 200)
//        HomeView(vm: HomeViewModelPreview(weather: weather))
//    }
//}
