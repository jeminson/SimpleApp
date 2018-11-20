//
//  Utility.swift
//  BASIC
//
//  Created by Je Min Son on 2018. 11. 8..
//  Copyright © 2018년 Je Min Son. All rights reserved.
//

import Foundation
import UIKit


extension UIView {
    @IBInspectable var ViewCorner: CGFloat {    // @IB -> design component
        get {
            return layer.cornerRadius
            
        }
        set {
            layer.cornerRadius = newValue
            layer.masksToBounds = newValue > 0
        }
    }
    
    @IBInspectable var viewBorderWidth: CGFloat {
        get {
            return layer.borderWidth
            
        }
        set {
            layer.borderWidth = newValue
            layer.masksToBounds = newValue > 0
        }
    }
    
    @IBInspectable var viewBordercolor: UIColor {
        get {
            return UIColor(cgColor:layer.borderColor!)
        }
        set {
            layer.borderColor = newValue.cgColor
        }
    }
}
