//
//  Color.Extensions.swift
//
//  Created by TJ Sartain on 1/17/20.
//

import UIKit
import StringUtilities

func pin(_ n: Int, _ a: Int, _ b: Int) -> Int
{
    let m = (a > n ? a : n)
    return (m < b ? m : b)
}

func pin(_ n: Double, _ a: Double, _ b: Double) -> Double
{
    let m = (a > n ? a : n)
    return (m < b ? m : b)
}

public func rgb(_ r: Int, _ g: Int, _ b: Int, _ a: Double? = 1) -> UIColor
{
    return rgba(Double(pin(r, 0, 255)) / 255,
                Double(pin(g, 0, 255)) / 255,
                Double(pin(b, 0, 255)) / 255,
                Double(pin(a!, 0, 1)))
}

public func rgb(_ r: CGFloat, _ g: CGFloat, _ b: CGFloat) -> UIColor
{
    return rgba(Double(r), Double(g), Double(b), 1)
}

public func rgb(_ r: Double, _ g: Double, _ b: Double) -> UIColor
{
    return rgba(r, g, b, 1)
}

public func rgba(_ r: Double, _ g: Double, _ b: Double, _ a: Double) -> UIColor
{
    return UIColor(red: CGFloat(r), green: CGFloat(g), blue: CGFloat(b), alpha: CGFloat(a))
}

public func colorFrom(_ str: String) -> UIColor
{
    if str.hasPrefix("(") {
        return fromCSV(str)
    } else if str.hasPrefix("#") {
        return hexColor(str)
    } else {
        return .clear
    }
}

public func fromCSV(_ c: String) -> UIColor
{
    var csv = c.replace("(", with: "")
    csv = csv.replace(")", with: "")
    let parts = csv.split(separator: ",").map() { "\($0)".trim }
    guard parts.count == 3 else {
        return .clear
    }
    if let r = Int("\(String(describing: parts[0]))"),
        let g = Int("\(String(describing: parts[1]))"),
        let b = Int("\(String(describing: parts[2]))") {
        return rgb(r, g, b)
    } else {
        return .clear
    }
}

public func hexColor(_ h: String) -> UIColor
{
    var hex = h.replace("#", with: "")
    if hex.count == 1 {
        hex = hex + hex + hex + hex + hex + hex
    } else if hex.count == 2 {
        hex = hex + hex + hex
    } else if hex.count == 3 {
        let h1 = hex[0]
        let h2 = hex[1]
        let h3 = hex[2]
        hex = "\(h1)\(h1)\(h2)\(h2)\(h3)\(h3)"
    }
    if hex.count != 6 {
        return .clear
    }
    let r = hexToInt(hex: String(hex[0...1]))
    let g = hexToInt(hex: String(hex[2...3]))
    let b = hexToInt(hex: String(hex[4...5]))
    print(r, g, b)
    return rgb(r, g, b)
}

func hexToInt(hex: String) -> Int
{
    var value: UInt64 = 0
    let hexValueScanner = Scanner(string: hex)
    hexValueScanner.scanHexInt64(&value)
    return Int(value)
}
