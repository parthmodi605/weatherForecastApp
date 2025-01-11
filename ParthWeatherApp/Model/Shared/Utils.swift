//
//  Utils.swift
//  ParthWeatherApp
//
//  Created by Parth Modi on 11/01/25.
//

import UIKit
let kAPPTITLE = "Weather"

class Utils: NSObject {
    
    class func getTopViewController() -> UIViewController {
        
        let keyWindow = UIApplication.shared.windows.filter {$0.isKeyWindow}.first
        var topController = keyWindow?.rootViewController
        while ((topController?.presentedViewController) != nil) {
            topController = topController?.presentedViewController
        }
        return topController!
    }
    class func showAlert(withMessage message: String) {
        let alertController = UIAlertController(title: kAPPTITLE, message: message , preferredStyle: .alert)
        let actionOk = UIAlertAction(title: "OK", style: .default, handler: nil)
        alertController.addAction(actionOk)
        Utils.getTopViewController().present(alertController, animated: true)
    }
    class func convertDateToString(date:Date , formatter_string : String) -> String{
        let formatter = DateFormatter()
        formatter.dateFormat = formatter_string
        formatter.timeZone = .current
        return formatter.string(from: date)
    }
    class func convertStringToString(str:String, currentDateString:String, formatString:String) -> String {
        let dateFormatterGet = DateFormatter()
        dateFormatterGet.dateFormat = currentDateString
        let dateFormatterPrint = DateFormatter()
        dateFormatterPrint.dateFormat = formatString
        let date: Date = dateFormatterGet.date(from: str) ?? Date()
        return dateFormatterPrint.string(from: date)
    }
    class func addShadow(view: UIView, cornerRadius: CGFloat, shadowRadius: CGFloat = 2) {
        view.layer.shadowOpacity = 1
        view.layer.shadowOffset = .zero
        view.layer.shadowRadius = shadowRadius
        view.layer.shadowColor = UIColor.white.cgColor
        view.layer.cornerRadius = cornerRadius
    }
}

//MARK: - Userdefault methods -
extension Utils{
    class func setStringForKey(_ value: String, key: String) {
        UserDefaults.standard.set(value, forKey: key)
        UserDefaults.standard.synchronize()
    }
    class func fetchString(forKey key: String) -> String {
        return UserDefaults.standard.string(forKey: key) == nil ? "" : UserDefaults.standard.string(forKey: key)!
    }
    class func removekey(forKey key: String) -> Void {
        return UserDefaults.standard.removeObject(forKey: key)
    }
}
