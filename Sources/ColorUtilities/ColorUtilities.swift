//
//  Color.Extensions.swift
//
//  Created by TJ Sartain on 1/17/20.
//

import UIKit

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

public func rgba(_ r: CGFloat, _ g: CGFloat, _ b: CGFloat, _ a: CGFloat) -> UIColor
{
    return UIColor(red: r, green: g, blue: b, alpha: a)
}

public func rgba(_ r: Double, _ g: Double, _ b: Double, _ a: Double) -> UIColor
{
    return UIColor(red: CGFloat(r), green: CGFloat(g), blue: CGFloat(b), alpha: CGFloat(a))
}

public func from(string: String) -> UIColor
{
    if string.hasPrefix("(") {
        return from(csv: string)
    } else if string.hasPrefix("#") {
        return from(hex: string)
    } else {
        return .clear
    }
}

public func from(csv: String) -> UIColor
{
    var csv = replace("(", with: "", in: csv)
    csv = replace(")", with: "", in: csv)
    let parts = csv.split(separator: ",").map() { trim("\($0)") }
    guard parts.count == 3 else {
        return .clear
    }
    if let  r = Int("\(parts[0])"),
        let g = Int("\(parts[1])"),
        let b = Int("\(parts[2])") {
        return rgb(r, g, b)
    } else {
        return .clear
    }
}

public func from(hex: String) -> UIColor
{
    var hex = replace("#", with: "", in: hex)
    if hex.count == 1 {
        hex = hex + hex + hex + hex + hex + hex
    } else if hex.count == 2 {
        hex = hex + hex + hex
    } else if hex.count == 3 {
        let h1 = range(0, of: hex)
        let h2 = range(1, of: hex)
        let h3 = range(2, of: hex)
        hex = h1 + h1 + h2 + h2 + h3 + h3
    }
    if hex.count != 6 {
        return .clear
    }
    let r = hexToInt(range(0, 1, of: hex))
    let g = hexToInt(range(2, 3, of: hex))
    let b = hexToInt(range(4, 5, of: hex))
    return rgb(r, g, b)
}

func hexToInt(_ hex: String) -> Int
{
    var value: UInt64 = 0
    let hexValueScanner = Scanner(string: hex)
    hexValueScanner.scanHexInt64(&value)
    return Int(value)
}

// MARK: - String Helpers -

func replace(_ this: String, with that: String, in str: String) -> String
{
    return str.replacingOccurrences(of: this, with: that)
}

func trim(_ str: String) -> String
{
    return str.trimmingCharacters(in: .whitespacesAndNewlines)
}

func range(_ s: Int, _ e: Int? = 0, of str: String) -> String
{
    let start = str.index(str.startIndex, offsetBy: s)
    let end = str.index(str.startIndex, offsetBy: (e! > s ? e! : s))
    return String(str[start ... end])
}
