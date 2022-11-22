//
//  UIFont+.swift
//  HorizontalPickerView
//
//  Created by Ruyha on 2022/11/22.
//

import Foundation

import UIKit

extension UIFont {
    class func systemRoundedFont(ofSize size: CGFloat, weight: UIFont.Weight) -> UIFont {
        let systemFont = UIFont.systemFont(ofSize: size, weight: weight)
        guard #available(iOS 13.0, *), let descriptor = systemFont.fontDescriptor.withDesign(.rounded) else { return systemFont }
        return UIFont(descriptor: descriptor, size: size)
    }
}
