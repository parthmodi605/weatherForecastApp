//
//  ParthWeatherAppTests.swift
//  ParthWeatherAppTests
//
//  Created by Parth Modi on 10/01/25.
//

import XCTest
@testable import ParthWeatherApp

final class ParthWeatherAppTests: XCTestCase {
    
    override func setUpWithError() throws {
        // Put setup code here. This method is called before the invocation of each test method in the class.
    }
    
    override func tearDownWithError() throws {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
    }
    
    func testExample() throws {
        // This is an example of a functional test case.
        // Use XCTAssert and related functions to verify your tests produce the correct results.
        // Any test you write for XCTest can be annotated as throws and async.
        // Mark your test throws to produce an unexpected failure when your test encounters an uncaught error.
        // Mark your test async to allow awaiting for asynchronous code to complete. Check the results with assertions afterwards.
    }
    
    func testPerformanceExample() throws {
        // This is an example of a performance test case.
        self.measure {
            // Put the code you want to measure the time of here.
        }
    }
    
    var viewModel: WeatherViewModel!
    
    override func setUp() {
        super.setUp()
        viewModel = WeatherViewModel()
    }
    
    override func tearDown() {
        viewModel = nil
        super.tearDown()
    }
    
    func testCurrentWeather_WhenNoWeatherData_ShouldReturnNil() {
        viewModel.weatherArr = []
        XCTAssertNil(viewModel.currentWeather, "Expected nil when no weather data is available")
    }
    
    func testCurrentWeather_WhenWeatherDataExists_ShouldReturnNearestWeather() {
        viewModel.weatherArr = createMockWeatherData()
        let currentWeather = viewModel.currentWeather
        
        XCTAssertNotNil(currentWeather, "Expected current weather to not be nil")
        XCTAssertEqual(currentWeather?.temp, "25.0°", "Expected temperature to match the mock data")
    }
    
    func testGetWeatherGroupedByDate_ShouldGroupWeatherByDate() {
        viewModel.weatherArr = createMockWeatherData()
        let groupedData = viewModel.getWeatherGroupedByDate()
        
        XCTAssertEqual(groupedData.count, 2, "Expected 2 groups of weather data")
        XCTAssertEqual(groupedData.first?.temp, "25.0°", "Expected first group temperature to match")
    }
    
    func testFetchWeatherInfo_ShouldUpdateWeatherArrayOnSuccess() {
        let expectation = self.expectation(description: "Fetch weather info completes")
        
        // Mock the reload callback
        viewModel.reloadWeatherView = {
            expectation.fulfill()
        }
        
        // Simulate a successful fetch
        MockManager.simulateFetchWeatherData(
            cityName: "TestCity",
            success: true,
            viewModel: viewModel
        )
        
        wait(for: [expectation], timeout: 1.0)
        XCTAssertFalse(viewModel.weatherArr.isEmpty, "Expected weatherArr to be updated with data")
    }
    
    // Helper to create mock weather data
    private func createMockWeatherData() -> [WeatherModelForecastData] {
        let weather1 = WeatherModelForecastData(
            dt: Date().timeIntervalSince1970,
            main: WeatherModelMainData(temp: 298.15, temp_min: 296.15, temp_max: 300.15, humidity: 50),
            weather: [WeatherModelWeatherData(id: 800, main: "Clear", description: "clear sky", icon: "01n")],
            dt_txt: "2025-01-11 12:00:00"
        )
        let weather2 = WeatherModelForecastData(
            dt: Date().addingTimeInterval(86400).timeIntervalSince1970, // +1 day
            main: WeatherModelMainData(temp: 295.15, temp_min: 293.15, temp_max: 297.15, humidity: 60),
            weather: [WeatherModelWeatherData(id: 803, main: "Clouds", description: "broken clouds", icon: "04d")],
            dt_txt: "2025-01-12 12:00:00"
        )
        return [weather1, weather2]
    }
}
// Mocking fetchWeatherData for simplicity
class MockManager {
    static func simulateFetchWeatherData(cityName: String, success: Bool, viewModel: WeatherViewModel) {
        if success {
            let mockData = [
                WeatherModelForecastData(
                    dt: Date().timeIntervalSince1970,
                    main: WeatherModelMainData(temp: 298.15, temp_min: 296.15, temp_max: 300.15, humidity: 50),
                    weather: [WeatherModelWeatherData(id: 803, main: "Clouds", description: "broken clouds", icon: "04d")],
                    dt_txt: "2025-01-11 12:00:00"
                )
            ]
            viewModel.weatherArr = mockData
            viewModel.reloadWeatherView?()
        } else {
            viewModel.weatherArr = []
            viewModel.reloadWeatherView?()
        }
    }
}


