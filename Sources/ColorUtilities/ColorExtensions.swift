//
//  File.swift
//  
//
//  Created by TJ Sartain on 10/14/20.
//

import UIKit
import StringUtilities

extension UIColor
{
    var channels: (r: CGFloat, g: CGFloat, b: CGFloat, a: CGFloat) {
        var chans: (r: CGFloat, g: CGFloat, b: CGFloat, a: CGFloat) = (0, 0, 0, 0)
        getRed(&chans.r, green: &chans.g, blue: &chans.b, alpha: &chans.a)
        return chans
    }
    
    var intChannels: (r: Int, g: Int, b: Int, a: CGFloat) {
        var chans: (r: CGFloat, g: CGFloat, b: CGFloat, a: CGFloat) = (0, 0, 0, 0)
        getRed(&chans.r, green: &chans.g, blue: &chans.b, alpha: &chans.a)
        return (Int(round(chans.r * 255)), Int(round(chans.g * 255)), Int(round(chans.b * 255)), chans.a)
    }
    
    public func withAlpha(_ a: Double) -> UIColor
    {
        let c = channels
        return rgba(Double(c.r), Double(c.g), Double(c.b), a)
    }
    
    public func lighter() -> UIColor
    {
        lighter(by: 25)
    }
    
    public func lighter(by pct: CGFloat) -> UIColor
    {
        let c = channels
        return rgb(min(c.r + c.r * pct / 100, 1),
                   min(c.g + c.g * pct / 100, 1),
                   min(c.b + c.b * pct / 100, 1))
    }
    
    public func darker() -> UIColor
    {
        darker(by: 20)
    }
    
    public func darker(by pct: CGFloat) -> UIColor
    {
        let c = channels
        return rgb(max(c.r - c.r * pct / 100, 0),
                   max(c.g - c.g * pct / 100, 0),
                   max(c.b - c.b * pct / 100, 0))
    }
    
    public func description() -> String
    {
        "\(hex()) \(csv())"
    }
    
    public func csv() -> String
    {
        let c = channels
        return String(format: "(%ld, %ld, %ld)", Int(round(c.r * 255)), Int(round(c.g * 255)), Int(round(c.b * 255)))
    }
    
    public func hex() -> String
    {
        let c = channels
        return String(format: "#%02X%02X%02X", Int(round(c.r * 255)), Int(round(c.g * 255)), Int(round(c.b * 255)))
    }
    
    public func image() -> UIImage?
    {
        imageWithOpacity(channels.a)
    }
    
    public func imageWithOpacity(_ alpha: CGFloat) -> UIImage?
    {
        let rect = CGRect(x: 0, y: 0, width: 1, height: 1)
        UIGraphicsBeginImageContext(rect.size)
        let context = UIGraphicsGetCurrentContext()
        
        context?.setFillColor(withAlphaComponent(alpha).cgColor)
        context?.fill(rect)
        
        let image = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        
        return image
    }
    
    public func discImage(radius: CGFloat, text: String? = nil, _ font: UIFont? = UIFont.systemFont(ofSize: 72)) -> UIImage?
    {
        let rect = CGRect(x: 0, y: 0, width: 2*radius, height: 2*radius)
        UIGraphicsBeginImageContext(rect.size)
        let context = UIGraphicsGetCurrentContext()
        context?.setFillColor(withAlpha(1).cgColor)
        context?.fillEllipse(in: rect)
        if let text = text, text.isNotEmpty() {
            text.draw(at: CGPoint(x: radius, y: radius),
                      font: font!,
                      color: .white,
                      align: .Center,
                      vAlign: .Middle)
        }
        let image = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        return image
    }
    
    public func relativeLuminance() -> CGFloat
    {
        var red: CGFloat = 0
        var green: CGFloat = 0
        var blue: CGFloat = 0
        guard getRed(&red, green: &green, blue: &blue, alpha: nil) else { return 1.0 }
        let convert: (CGFloat) -> CGFloat = { component in
            guard component > 0.03928 else { return component / 12.92 }
            return pow(((component + 0.055) / 1.055), 2.4)
        }
        return 0.2126 * convert(red) + 0.7152 * convert(green) + 0.0722 * convert(blue)
    }
    
    public func contrastRatio(_ otherColor: UIColor) -> CGFloat
    {
        let luminance1 = relativeLuminance()
        let luminance2 = otherColor.relativeLuminance()
        return (min(luminance1, luminance2) + 0.05) / (max(luminance1, luminance2) + 0.05)
    }
    
    public func invert(_ r: CGFloat, _ g: CGFloat, _ b: CGFloat) -> (CGFloat, CGFloat, CGFloat)
    {
        (1 - r, 1 - g, 1 - b)
    }
    
    public func invert() -> UIColor
    {
        let c = channels
        let inv = invert(c.r, c.g, c.b)
        return rgba(inv.0, inv.1, inv.2, c.a)
    }
    
    public func desaturate() -> UIColor
    {
        let c = channels
        let avg = (c.r + c.g + c.b) / 3
        return rgba(avg, avg, avg, c.a)
    }
    
    // MARK: - Blending -
    
    public func blend(_ top: UIColor,
                      _ blendFunction: (CGFloat, CGFloat) -> CGFloat) -> UIColor
    {
        let bottom = channels
        let top = top.channels
        let r = blendFunction(bottom.r, top.r)
        let g = blendFunction(bottom.g, top.g)
        let b = blendFunction(bottom.b, top.b)
        return rgb(r, g, b) // whose alpha value?
    }
    
    public func multiply(_ top: UIColor) -> UIColor
    {
        blend(top, { (_ a: CGFloat, _ b: CGFloat) -> CGFloat in
            return a * b } )
    }
    
    public func screen(_ top: UIColor) -> UIColor
    {
        blend(top, { (_ a: CGFloat, _ b: CGFloat) -> CGFloat in
            return 1 - (1 - a) * (1 - b) } )
    }
    
    public func hardLight(_ top: UIColor) -> UIColor
    {
        top.blend(self, { (_ a: CGFloat, _ b: CGFloat) -> CGFloat in
            if a < 0.5 {
                return 2 * a * b
            } else {
                return 1 - 2 * (1 - a) * (1 - b)
            } } )
    }
    
    public func softLight(_ top: UIColor) -> UIColor
    {
        blend(top, { (_ a: CGFloat, _ b: CGFloat) -> CGFloat in
            if b < 0.5 {
                return 2 * a * b + a * a * (1 - 2 * b)
            } else {
                return 2 * a * (1 - b) + sqrt(a) * (2 * b - 1)
            } } )
    }
    
    public func softLight2(_ top: UIColor) -> UIColor
    {
        blend(top, { (_ a: CGFloat, _ b: CGFloat) -> CGFloat in
            return pow(a, pow(2, 2 * (0.5 - b))) } )
    }
    
    public func overlay(_ top: UIColor) -> UIColor
    {
        blend(top, { (_ a: CGFloat, _ b: CGFloat) -> CGFloat in
            if a < 0.5 {
                return 2 * a * b
            } else {
                return 1 - 2 * (1 - a) * (1 - b)
            } } )
    }
    
    public func divide(_ top: UIColor) -> UIColor
    {
        blend(top, { (_ a: CGFloat, _ b: CGFloat) -> CGFloat in
            return b == 0 ? (a == 0 ? 0 : 1) : a / b } )
    }
    
    public func addition(_ top: UIColor) -> UIColor
    {
        blend(top, { (_ a: CGFloat, _ b: CGFloat) -> CGFloat in
            return a + b > 1 ? 1 : a + b } )
    }
    
    public func subtract(_ top: UIColor) -> UIColor
    {
        blend(top, { (_ a: CGFloat, _ b: CGFloat) -> CGFloat in
            return b > a ? 0 : a - b } )
    }
    
    public func difference(_ top: UIColor) -> UIColor
    {
        blend(top, { (_ a: CGFloat, _ b: CGFloat) -> CGFloat in
            return a < b ? b - a : a - b } )
    }
    
    public func darkenOnly(_ top: UIColor) -> UIColor
    {
        blend(top, { (_ a: CGFloat, _ b: CGFloat) -> CGFloat in
            return a > b ? b : a } )
    }
    
    public func lightenOnly(_ top: UIColor) -> UIColor
    {
        blend(top, { (_ a: CGFloat, _ b: CGFloat) -> CGFloat in
            return a > b ? a : b } )
    }
}

