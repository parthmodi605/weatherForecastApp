//
//  LoaderView.swift
//  ParthWeatherApp
//
//  Created by Parth Modi on 11/01/25.
//

import UIKit

class LoaderView: UIView {
    
    class func displaySpinner(win:UIView) {
        
        let spinnerView = UIView.init(frame: win.bounds)
        spinnerView.tag = 9999
        spinnerView.backgroundColor = UIColor.init(red: 0, green: 0, blue: 0, alpha: 0.5)
        let ai = UIActivityIndicatorView(frame: CGRect(x: 0, y: 0, width: 50, height: 50))
        if #available(iOS 13.0, *) {
            ai.style = .large
            ai.color = .white
        } else {
            ai.style = .whiteLarge
        }
        ai.center = spinnerView.center
        ai.startAnimating()
        DispatchQueue.main.async {
            spinnerView.addSubview(ai)
            win.addSubview(spinnerView)
        }
    }
    
    class func removeSpinner(win:UIView) {
        DispatchQueue.main.async {
            for subView : UIView in win.subviews {
                if subView.tag == 9999{
                    subView.removeFromSuperview()
                }
            }
        }
    }
}
