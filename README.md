# ColorUtilities

A collection of handy utilities and extensions for the String class.


Utilities

public func rgb(_ r: Int, _ g: Int, _ b: Int, _ a: Double? = 1) -> UIColor
public func rgb(_ r: CGFloat, _ g: CGFloat, _ b: CGFloat) -> UIColor
public func rgb(_ r: Double, _ g: Double, _ b: Double) -> UIColor
public func rgba(_ r: CGFloat, _ g: CGFloat, _ b: CGFloat, _ a: CGFloat) -> UIColor
public func rgba(_ r: Double, _ g: Double, _ b: Double, _ a: Double) -> UIColor

public func from(string: String) -> UIColor
public func from(csv: String) -> UIColor
public func from(hex: String) -> UIColor


Extensions

public func withAlpha(_ a: Double) -> UIColor
public func lighter(by pct: CGFloat? = 25) -> UIColor
public func darker(by pct: CGFloat? = 20) -> UIColor
public override var description: String
public func csv() -> String
public func hex() -> String
public func image() -> UIImage?
public func imageWithOpacity(_ alpha: CGFloat) -> UIImage?
public func relativeLuminance() -> CGFloat
public func contrastRatio(_ otherColor: UIColor) -> CGFloat
public func invert(_ r: CGFloat, _ g: CGFloat, _ b: CGFloat) -> (CGFloat, CGFloat, CGFloat)
public func invert() -> UIColor
public func desaturate() -> UIColor

public func blend(_ top: UIColor, _ function: (_ a: CGFloat, _ b: CGFloat) -> CGFloat) -> UIColor
public func multiply(_ top: UIColor) -> UIColor
public func screen(_ top: UIColor) -> UIColor
public func softLight2(_ top: UIColor) -> UIColor
public func divide(_ top: UIColor) -> UIColor
public func addition(_ top: UIColor) -> UIColor
public func subtract(_ top: UIColor) -> UIColor
public func difference(_ top: UIColor) -> UIColor
public func darkenOnly(_ top: UIColor) -> UIColor
public func lightenOnly(_ top: UIColor) -> UIColor
public func hardLight(_ top: UIColor) -> UIColor
public func softLight(_ top: UIColor) -> UIColor
public func overlay(_ top: UIColor) -> UIColor
