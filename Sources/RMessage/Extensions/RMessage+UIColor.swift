//
//  RMessage+UIColor.swift
//  RMessage
//
//  Created by Adonis Peralta on 6/27/25.
//

import UIKit

extension UIColor {
    /// Initialize a UIColor from a 6char or 8char hex color code with or without a leading # character.
    /// - Parameter hex: The hex color code string to initialize the UIColor from.
    convenience init?(hex: String) {
        let r, g, b, a: CGFloat

        let hexColor: String

        if hex.hasPrefix("#") {
            let start = hex.index(hex.startIndex, offsetBy: 1)
            hexColor = String(hex[start...])
        } else {
            hexColor = hex
        }

        let hexColorCount = hexColor.count

        guard hexColorCount < 9 else { return nil }

        let scanner = Scanner(string: hexColor)
        var hexNumber = UInt64(0)

        guard scanner.scanHexInt64(&hexNumber) else { return nil }

        switch hexColorCount {
        case 8:
            r = CGFloat((hexNumber & 0xff00_0000) >> 24) / 255
            g = CGFloat((hexNumber & 0x00ff_0000) >> 16) / 255
            b = CGFloat((hexNumber & 0x0000_ff00) >> 8) / 255
            a = CGFloat(hexNumber & 0x0000_00ff) / 255
        default:
            r = CGFloat((hexNumber & 0xff0000) >> 16) / 255
            g = CGFloat((hexNumber & 0x00ff00) >> 8) / 255
            b = CGFloat(hexNumber & 0x0000ff) / 255
            a = 1.0
        }

        self.init(red: r, green: g, blue: b, alpha: a)
    }
}
