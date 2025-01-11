//
//  Manager.swift
//  ParthWeatherApp
//
//  Created by Parth Modi on 11/01/25.
//

import Foundation

class Manager: NSObject {
    
    static let shared = Manager()
    
    func fetchWeatherData(cityName: String, completion: @escaping (_ response: WeatherModelData?, _ success: Bool, _ message: String) -> Void) {
        guard let url = URL(string: "https://api.openweathermap.org/data/2.5/forecast?q=\(cityName)&appid=857ae8c51c4c0489a2c0a0f1594a966f") else {
            completion(nil, false, "Api not found")
            return
        }
        let task = URLSession.shared.dataTask(with: url) { data, response, error in
            guard let data = data, error == nil else {
                print("Error fetching data: \(error?.localizedDescription ?? "Unknown error")")
                DispatchQueue.main.async() {
                    completion(nil, false, "Error fetching data: \(error?.localizedDescription ?? "Unknown error")")
                }
                return
            }
            do {
                let decoder = JSONDecoder()
                decoder.dateDecodingStrategy = .secondsSince1970
                let weatherResponse = try decoder.decode(WeatherModelData.self, from: data)
                DispatchQueue.main.async() {
                    if weatherResponse.cod == "200" {
                        completion(weatherResponse, true, "")
                    } else {
                        completion(weatherResponse, false, weatherResponse.message?.messageString ?? "")
                    }
                }
            } catch {
                print("Error decoding JSON: \(error.localizedDescription)")
                DispatchQueue.main.async() {
                    completion(nil, false, "Error decoding JSON: \(error.localizedDescription)")
                }
            }
        }
        task.resume()
    }
}
