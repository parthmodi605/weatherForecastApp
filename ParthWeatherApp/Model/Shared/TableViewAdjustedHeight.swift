//
//  TableViewAdjustedHeight.swift
//  ParthWeatherApp
//
//  Created by Parth Modi on 11/01/25.
//
import UIKit

class TableViewAdjustedHeight: UITableView {
    
    override var contentSize: CGSize {
        didSet {
            invalidateIntrinsicContentSize()
        }
    }
    
    override var intrinsicContentSize: CGSize {
        return contentSize
    }
    
    override func reloadData() {
        super.reloadData()
        invalidateIntrinsicContentSize()
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        if bounds.size != intrinsicContentSize {
            invalidateIntrinsicContentSize()
            self.invalidateIntrinsicContentSizeOfSuperview()
        }
    }
    
    private func invalidateIntrinsicContentSizeOfSuperview() {
        var view: UIView? = superview
        
        while view != nil {
            view?.invalidateIntrinsicContentSize()
            if view is UITableView {
                break
            }
            view = view?.superview
        }
    }
}
