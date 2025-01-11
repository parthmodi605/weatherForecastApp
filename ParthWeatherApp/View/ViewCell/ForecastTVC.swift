//
//  ForecastTVC.swift
//  ParthWeatherApp
//
//  Created by Parth Modi on 11/01/25.
//

import UIKit

class ForecastTVC: UITableViewCell {

    //MARK: - IBOutlets -
    @IBOutlet weak var lblDate: UILabel!
    @IBOutlet weak var lblHighTemp: UILabel!
    @IBOutlet weak var lblLowTemp: UILabel!
    @IBOutlet weak var viewSeparator: UIView!

    override func awakeFromNib() {
        super.awakeFromNib()
        selectionStyle = .none
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    func cellConfigure(viewModel: WeatherViewModel, indexPath: IndexPath) {
        let dataObj = viewModel.getWeatherGroupedByDate()[indexPath.row]
        if Utils.convertDateToString(date: dataObj.date, formatter_string: "dd MM yyyy") == Utils.convertDateToString(date: Date(), formatter_string: "dd MM yyyy") {
            lblDate.text = "Today"
        } else {
            lblDate.text = Utils.convertDateToString(date: dataObj.date, formatter_string: "dd MMM")
        }
        lblLowTemp.text = dataObj.lowTemp
        lblHighTemp.text = dataObj.highTemp
        viewSeparator.isHidden = indexPath.row == (viewModel.getWeatherGroupedByDate().count-1)
    }
    
}
