//
//  WeatherViewModel.swift
//  ParthWeatherApp
//
//  Created by Parth Modi on 11/01/25.
//

import Foundation

class WeatherViewModel {
    
    var cityName = String() {
        didSet {
            fetchWeatherInfo()
        }
    }
    var weatherArr = [WeatherModelForecastData]()
    var cityDict : WeatherModelCityData?
    var reloadWeatherView: (() -> Void)?
    
    var fetchedCityName : String {
        return cityDict?.name ?? ""
    }
    
    var currentWeather: WeatherInfoStruct? {
        guard !weatherArr.isEmpty else { return nil }
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = date_Format_dd_MM_yy_dash_HH_mm_ss
        let currentDate = Date()
        let currentDateString = dateFormatter.string(from: currentDate)
        let nearestWeather = weatherArr.min { weather1, weather2 in
            guard let dtTxt1 = weather1.dt_txt, let dtTxt2 = weather2.dt_txt else { return false }
            guard let date1 = dateFormatter.date(from: dtTxt1),
                  let date2 = dateFormatter.date(from: dtTxt2),
                  let currentParsedDate = dateFormatter.date(from: currentDateString) else { return false }
            
            let time1 = abs(date1.timeIntervalSince(currentParsedDate))
            let time2 = abs(date2.timeIntervalSince(currentParsedDate))
            return time1 < time2
        }
            
        guard let selectedWeather = nearestWeather else { return nil }
        return WeatherInfoStruct(
            date: dateFormatter.date(from: selectedWeather.dt_txt ?? "") ?? Date(),
            temp: kelvinToCelsius(selectedWeather.main?.temp ?? 0.0),
            weatherConditions: selectedWeather.weather?.first?.description?.capitalized ?? "",
            humidity: "\(selectedWeather.main?.humidity ?? 0)%",
            highTemp: kelvinToCelsius(selectedWeather.main?.temp_max ?? 0.0),
            lowTemp: kelvinToCelsius(selectedWeather.main?.temp_min ?? 0.0)
        )
    }
    
    func getWeatherGroupedByDate() -> [WeatherInfoStruct] {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = date_Format_yyyy_MM_dd_dash
        dateFormatter.timeZone = .current
        var groupedData: [String: [WeatherModelForecastData]] = [:]
        
        for entry in weatherArr {
            let date = Utils.convertStringToString(str: entry.dt_txt ?? "", currentDateString: date_Format_dd_MM_yy_dash_HH_mm_ss, formatString: date_Format_yyyy_MM_dd_dash)
            if groupedData[date] != nil {
                groupedData[date]?.append(entry)
            } else {
                groupedData[date] = [entry]
            }
        }
        
        var result: [WeatherInfoStruct] = []
        for (date, entries) in groupedData {
            let highTemp = kelvinToCelsius(entries.max(by: { $0.main?.temp_max ?? 0.0 < $1.main?.temp_max ?? 0.0 })?.main?.temp_max ?? 0)
            let lowTemp = kelvinToCelsius(entries.min(by: { $0.main?.temp_min ?? 0.0 < $1.main?.temp_min ?? 0.0 })?.main?.temp_min ?? 0)
            
            let representativeEntry = entries.first! // Pick any entry for shared attributes
            result.append(WeatherInfoStruct(
                date: dateFormatter.date(from: date) ?? Date(),
                temp: kelvinToCelsius(representativeEntry.main?.temp ?? 0.0),
                weatherConditions: representativeEntry.weather?.first?.description?.capitalized ?? "",
                humidity: "\(representativeEntry.main?.humidity ?? 0)%",
                highTemp: highTemp,
                lowTemp: lowTemp))
        }
        result.sort {
            $0.date < $1.date
        }
        return result
    }
    
    func fetchWeatherInfo() {
        Manager.shared.fetchWeatherData(cityName: cityName) { response, success, message in
            if !success {
                Utils.showAlert(withMessage: message)
                self.reloadWeatherView?()
                return
            }
            if let response = response, let dataArr = response.list {
                self.weatherArr.removeAll()
                self.weatherArr = dataArr
                self.cityDict = response.city
                Utils.setStringForKey(self.cityName, key: kLastSearchedCity)
                self.reloadWeatherView?()
            }
        }
    }
    func kelvinToCelsius(_ kelvin: Double) -> String {
        return String(format: "%.1f°", kelvin - 273.15)
    }
}

struct WeatherInfoStruct {
    var date: Date
    var temp: String
    var weatherConditions: String
    var humidity: String
    var highTemp: String
    var lowTemp: String
}
