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
    struct Channels {
        var r, g, b, a: CGFloat
    }
    
    static func channels(_ c: UIColor) -> Channels
    {
        var channels = Channels(r: 0, g: 0, b: 0, a: 0)
        c.getRed(&channels.r, green: &channels.g, blue: &channels.b, alpha: &channels.a)
        return channels
    }
    
    public func withAlpha(_ a: Double) -> UIColor
    {
        let c = UIColor.channels(self)
        return rgba(Double(c.r), Double(c.g), Double(c.b), a)
    }
    
    public func lighter() -> UIColor
    {
        return lighter(by: 25)
    }
    
    public func lighter(by pct: CGFloat) -> UIColor
    {
        let c = UIColor.channels(self)
        return rgb(min(c.r + c.r * pct / 100, 1),
                   min(c.g + c.g * pct / 100, 1),
                   min(c.b + c.b * pct / 100, 1))
    }
    
    public func darker() -> UIColor
    {
        return darker(by: 20)
    }
    
    public func darker(by pct: CGFloat) -> UIColor
    {
        let c = UIColor.channels(self)
        return rgb(max(c.r - c.r * pct / 100, 0),
                   max(c.g - c.g * pct / 100, 0),
                   max(c.b - c.b * pct / 100, 0))
    }
    
    public func hexValue() -> String
    {
        var r: CGFloat = 0
        var g: CGFloat = 0
        var b: CGFloat = 0
        var a: CGFloat = 0
        getRed(&r, green: &g, blue: &b, alpha: &a)
        return String(format: "#%02X%02X%02X", Int(r * 255), Int(g * 255), Int(b * 255))
    }
    
    public func description() -> String
    {
        var r: CGFloat = 0
        var g: CGFloat = 0
        var b: CGFloat = 0
        var a: CGFloat = 0
        getRed(&r, green: &g, blue: &b, alpha: &a)
        return String(format: "(%ld, %ld, %ld)", Int(round(r * 255)), Int(round(g * 255)), Int(round(b * 255)))
    }
    
    public func image() -> UIImage?
    {
        let chan = UIColor.channels(self)
        return imageWithOpacity(chan.a)
    }
    
    public func imageWithOpacity(_ alpha: CGFloat) -> UIImage?
    {
        let rect = CGRect(x: 0, y: 0, width: 1, height: 1)
        UIGraphicsBeginImageContext(rect.size)
        let context = UIGraphicsGetCurrentContext()
        
        context?.setFillColor(self.withAlphaComponent(alpha).cgColor)
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
        context?.setFillColor(self.withAlpha(1).cgColor)
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
    
    public func invert(_ r: CGFloat, _ g: CGFloat, _ b: CGFloat) -> (CGFloat, CGFloat, CGFloat)
    {
        return (1 - r, 1 - g, 1 - b)
    }
    
    public func invert() -> UIColor
    {
        let chan = UIColor.channels(self)
        let inv = invert(chan.r, chan.g, chan.b)
        return rgb(inv.0, inv.1, inv.2)
    }
    
    public func desaturate() -> UIColor
    {
        let chan = UIColor.channels(self)
        let avg = (chan.r + chan.g + chan.b) / 3
        return rgb(avg, avg, avg)
    }
    
    // MARK: - Blending -
    
    public func blend(_ top: UIColor,
               _ blendFunction: (CGFloat, CGFloat) -> CGFloat) -> UIColor
    {
        let bottom = UIColor.channels(self)
        let top = UIColor.channels(top)
        let r = blendFunction(bottom.r, top.r)
        let g = blendFunction(bottom.g, top.g)
        let b = blendFunction(bottom.b, top.b)
        return rgb(r, g, b)
    }
    
    public func multiply(_ top: UIColor) -> UIColor
    {
        return blend(top, { (_ a: CGFloat, _ b: CGFloat) -> CGFloat in
            return a * b } )
    }
    
    public func screen(_ top: UIColor) -> UIColor
    {
        return blend(top, { (_ a: CGFloat, _ b: CGFloat) -> CGFloat in
            return 1 - (1 - a) * (1 - b) } )
    }
    
    public func hardLight(_ top: UIColor) -> UIColor
    {
        return top.blend(self, { (_ a: CGFloat, _ b: CGFloat) -> CGFloat in
            if a < 0.5 {
                return 2 * a * b
            } else {
                return 1 - 2 * (1 - a) * (1 - b)
            } } )
    }
    
    public func softLight(_ top: UIColor) -> UIColor
    {
        return blend(top, { (_ a: CGFloat, _ b: CGFloat) -> CGFloat in
            if b < 0.5 {
                return 2 * a * b + a * a * (1 - 2 * b)
            } else {
                return 2 * a * (1 - b) + sqrt(a) * (2 * b - 1)
            } } )
    }
    
    public func softLight2(_ top: UIColor) -> UIColor
    {
        return blend(top, { (_ a: CGFloat, _ b: CGFloat) -> CGFloat in
            return pow(a, pow(2, 2 * (0.5 - b))) } )
    }
    
    public func overlay(_ top: UIColor) -> UIColor
    {
        return blend(top, { (_ a: CGFloat, _ b: CGFloat) -> CGFloat in
            if a < 0.5 {
                return 2 * a * b
            } else {
                return 1 - 2 * (1 - a) * (1 - b)
            } } )
    }
    
    public func divide(_ top: UIColor) -> UIColor
    {
        return blend(top, { (_ a: CGFloat, _ b: CGFloat) -> CGFloat in
            return b == 0 ? (a == 0 ? 0 : 1) : a / b } )
    }
    
    public func addition(_ top: UIColor) -> UIColor
    {
        return blend(top, { (_ a: CGFloat, _ b: CGFloat) -> CGFloat in
            return a + b > 1 ? 1 : a + b } )
    }
    
    public func subtract(_ top: UIColor) -> UIColor
    {
        return blend(top, { (_ a: CGFloat, _ b: CGFloat) -> CGFloat in
            return b > a ? 0 : a - b } )
    }
    
    public func difference(_ top: UIColor) -> UIColor
    {
        return blend(top, { (_ a: CGFloat, _ b: CGFloat) -> CGFloat in
            return a - b < 0 ? b - a : a - b } )
    }
    
    public func darkenOnly(_ top: UIColor) -> UIColor
    {
        return blend(top, { (_ a: CGFloat, _ b: CGFloat) -> CGFloat in
            return a > b ? b : a } )
    }
    
    public func lightenOnly(_ top: UIColor) -> UIColor
    {
        return blend(top, { (_ a: CGFloat, _ b: CGFloat) -> CGFloat in
            return a > b ? a : b } )
    }
}

