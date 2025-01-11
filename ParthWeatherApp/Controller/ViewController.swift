//
//  ViewController.swift
//  ParthWeatherApp
//
//  Created by Parth Modi on 10/01/25.
//

import UIKit

class ViewController: UIViewController {

    //MARK: - IBOutlets -
    @IBOutlet weak var lblCityName: UILabel!
    @IBOutlet weak var lblTemperature: UILabel!
    @IBOutlet weak var lblWeatherConditions: UILabel!
    @IBOutlet weak var lblHumidity: UILabel!
    @IBOutlet weak var lblForecastTitle: UILabel!
    @IBOutlet weak var lblInfoMessage: UILabel!
    @IBOutlet weak var stackCurrentWeather: UIStackView!
    @IBOutlet weak var viewForecast: UIView!
    @IBOutlet weak var tblForecast: UITableView!
    @IBOutlet weak var searchBarCity: UISearchBar!

    
    //MARK: - Properties -
    var viewModel = WeatherViewModel()
    
    //MARK: - VC Life cycle -
    override func viewDidLoad() {
        super.viewDidLoad()
        setupView()
    }
    
    //MARK: - Helper methods -
    func setupView(){
        setupSearchbar()
        tblForecast.register(UINib(nibName: "ForecastTVC", bundle: nil), forCellReuseIdentifier: "ForecastTVC")
        Utils.addShadow(view: viewForecast, cornerRadius: 10)
        viewForecast.isHidden = true
        stackCurrentWeather.isHidden = true
        lblInfoMessage.isHidden = false
        if !Utils.fetchString(forKey: kLastSearchedCity).isEmpty {
            viewModel.cityName = Utils.fetchString(forKey: kLastSearchedCity)
            LoaderView.displaySpinner(win: self.view)
        }
        viewModel.reloadWeatherView = { [weak self] in
            if let self = self {
                LoaderView.removeSpinner(win: view)
                if !viewModel.getWeatherGroupedByDate().isEmpty {
                    guard let currentWeather = viewModel.currentWeather else { return }
                    viewForecast.isHidden = false
                    stackCurrentWeather.isHidden = false
                    lblInfoMessage.isHidden = true
                    searchBarCity.text = ""
                    lblCityName.text = viewModel.cityName
                    lblForecastTitle.text = "\(viewModel.getWeatherGroupedByDate().count)-DAY FORECAST"
                    lblTemperature.text = currentWeather.temp
                    lblWeatherConditions.text = currentWeather.weatherConditions
                    lblHumidity.text = "Humidity: \(currentWeather.humidity)"
                    tblForecast.reloadData()
                }
            }
        }
    }
    func setupSearchbar() {
        searchBarCity.backgroundImage = UIImage()
        searchBarCity.searchTextField.backgroundColor = .white
        if let textField = searchBarCity.value(forKey: "searchField") as? UITextField {
            textField.attributedPlaceholder = NSAttributedString(
                string: searchBarCity.placeholder ?? "",
                attributes: [NSAttributedString.Key.foregroundColor: UIColor.lightGray]  // Set placeholder color
            )
            textField.textColor = .black
            textField.leftView?.tintColor = .lightGray  // Set search icon color
        }
    }
}

//MARK: - UISearchBar Methods -
extension ViewController: UISearchBarDelegate {
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        self.view.endEditing(true)
        viewModel.cityName = searchBar.text?.trimmingCharacters(in: .whitespaces) ?? ""
        LoaderView.displaySpinner(win: self.view)
    }
}

//MARK: - UITableView Methods -
extension ViewController : UITableViewDataSource, UITableViewDelegate {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return viewModel.getWeatherGroupedByDate().count
    }
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "ForecastTVC", for: indexPath) as? ForecastTVC
        cell?.cellConfigure(viewModel: viewModel, indexPath: indexPath)
        return cell ?? UITableViewCell()
    }
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 45
    }
}

