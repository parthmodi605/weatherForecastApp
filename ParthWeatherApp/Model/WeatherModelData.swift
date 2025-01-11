//
//  WeatherModelData.swift
//  ParthWeatherApp
//
//  Created by Parth Modi on 11/01/25.
//

import Foundation


struct WeatherModelData: Codable {
    let cnt : Int?
    let cod : String?
    let message: MessageType?  // Use MessageType instead of String or Int
    let city: WeatherModelCityData?
    let list: [WeatherModelForecastData]?
}

struct WeatherModelCityData: Codable {
    let country : String?
    let id : Int?
    let name : String?
    let population : Int?
    let sunrise : Int?
    let sunset : Int?
    let timezone : Int?
}

struct WeatherModelForecastData: Codable {
    let dt: TimeInterval?
    let main: WeatherModelMainData?
    let weather: [WeatherModelWeatherData]?
    let dt_txt: String?
}

struct WeatherModelMainData: Codable {
    let temp: Double?
    let temp_min: Double?
    let temp_max: Double?
    let humidity: Int?
}

struct WeatherModelWeatherData: Codable {
    let id: Int?
    let main: String?
    let description: String?
    let icon: String?
}

enum MessageType: Codable {
    case string(String)
    case int(Int)

    init(from decoder: Decoder) throws {
        let container = try decoder.singleValueContainer()
        
        if let intValue = try? container.decode(Int.self) {
            self = .int(intValue)
        } else if let stringValue = try? container.decode(String.self) {
            self = .string(stringValue)
        } else {
            throw DecodingError.dataCorruptedError(in: container, debugDescription: "Invalid value for message")
        }
    }

    func encode(to encoder: Encoder) throws {
        var container = encoder.singleValueContainer()
        switch self {
        case .int(let value):
            try container.encode(value)
        case .string(let value):
            try container.encode(value)
        }
    }
    var messageString: String {
            switch self {
            case .string(let value):
                return value
            case .int(let value):
                return String(value)
            }
        }
}
