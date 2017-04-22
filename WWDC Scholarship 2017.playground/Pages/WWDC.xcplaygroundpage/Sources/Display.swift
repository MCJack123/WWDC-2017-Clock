import UIKit

public extension String {
    func pad(with character: String, toLength length: Int) -> String {
        let padCount = length - self.characters.count
        guard padCount > 0 else { return self }
        
        return String(repeating: character, count: padCount) + self
    }
    
    public func find(of char: Character) -> Int? {
        if let idx = characters.index(of: char) {
            return characters.distance(from: startIndex, to: idx)
        }
        return nil
    }
    
    func lastIndexOf(_ target: Character) -> Int? {
        return self.characters.count - String(self.characters.reversed()).find(of: target)! - 1
    }
}

public extension UInt8 {
    init(_ b: Bool) {
        if b {
            self = UInt8(1)
        } else {
            self = UInt8(0)
        }
    }
}

public extension Int {
    init(_ b: Bool) {
        if b {
            self = Int(1)
        } else {
            self = Int(0)
        }
    }
}

public extension CGFloat {
    init(_ b: Bool) {
        if b {
            self = CGFloat(1.0)
        } else {
            self = CGFloat(0.0)
        }
    }
}

public extension UIColor {
    var coreImageColor: CIColor {
        return CIColor(color: self)
    }
}

public enum Direction : Int {
	case up = 0
	case down
	case left
	case right
}

public class Draw: UIView {
    
    var color : UIColor = .black
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        //self.backgroundColor = color
    }
    
    required public init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func setTColor(_ colorr: UIColor) -> Draw {
        color = colorr
        self.backgroundColor = color
        return self
    }
    
    override public func draw(_ rect: CGRect) {
        self.backgroundColor = color
    }
    
}

public class DrawO: UIView {
    
    var color : UIColor = .black
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        //self.backgroundColor = color
    }
    
    required public init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func setTColor(_ colorr: UIColor) -> DrawO {
        color = colorr
        self.backgroundColor = .clear
        return self
    }
    
    override public func draw(_ rect: CGRect) {
        self.backgroundColor = .clear
        let ovalPath = UIBezierPath(ovalIn: rect)
        color.setFill()
        ovalPath.fill()
        return
    }
    
}

public class TriangleView : UIView {
    
    var color : UIColor = .white
	var pointing : Direction = .up
    
    public override init(frame: CGRect) {
        super.init(frame: frame)
    }
    
    public required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    
    public func setTColor(_ colorr: UIColor) -> TriangleView {
        color = colorr
        self.backgroundColor = .clear
        return self
    }
    
    public override func draw(_ rect: CGRect) {
        
        guard let context = UIGraphicsGetCurrentContext() else { return }
        
        self.backgroundColor = .clear
        context.beginPath()
		if pointing == .up {
			context.move(to: CGPoint(x: rect.minX, y: rect.maxY))
			context.addLine(to: CGPoint(x: rect.maxX, y: rect.maxY))
			context.addLine(to: CGPoint(x: (rect.maxX / 2.0), y: rect.minY))
		} else if pointing == .down {
			context.move(to: CGPoint(x: rect.minX, y: rect.minY))
			context.addLine(to: CGPoint(x: rect.maxX, y: rect.minY))
			context.addLine(to: CGPoint(x: (rect.maxX / 2.0), y: rect.maxY))
		} else if pointing == .left {
			context.move(to: CGPoint(x: rect.maxX, y: rect.minY))
			context.addLine(to: CGPoint(x: rect.maxX, y: rect.maxY))
			context.addLine(to: CGPoint(x: rect.minX, y: (rect.maxY / 2.0)))
		} else {
			context.move(to: CGPoint(x: rect.minX, y: rect.minY))
			context.addLine(to: CGPoint(x: rect.minX, y: rect.maxY))
			context.addLine(to: CGPoint(x: rect.maxX, y: (rect.maxY / 2.0)))
		}
        context.closePath()
        
        self.color.setFill()
        context.fillPath()
    }
}

public class ToolTip : UIView {
    
    public var text : String = "This is a tooltip."
    public var textColor : UIColor = .black
    public var backColor : UIColor = .white
	public var completed : () -> () = {() in }
	public var arrowFacing : Direction = .up
    
    public override init(frame: CGRect) {
        super.init(frame: frame)
    }
    
    required public init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    
    override public func draw(_ rect: CGRect) {
        self.backgroundColor = .clear
		var bottomView = UIView()
		var topView = TriangleView()
        if arrowFacing == .up {
			topView = TriangleView(frame: CGRect(x: 0, y: 0, width: rect.height / 4, height: rect.height / 4))
			bottomView = UIView(frame: CGRect(x: 0, y: (rect.height / 4) - 1, width: rect.width, height: rect.height - (rect.height / 4)))
		} else if arrowFacing == .down {
			topView = TriangleView(frame: CGRect(x: 0, y: rect.height - (rect.height / 4), width: rect.height / 4, height: rect.height / 4))
			bottomView = UIView(frame: CGRect(x: 0, y: 0, width: rect.width, height: rect.height - (rect.height / 4)))
		} else if arrowFacing == .left {
			topView = TriangleView(frame: CGRect(x: 0, y: 0, width: rect.height / 4, height: rect.height / 4))
			bottomView = UIView(frame: CGRect(x: topView.frame.width, y: 0, width: rect.width - topView.frame.width, height: rect.height))
		} else {
			topView = TriangleView(frame: CGRect(x: rect.width - (rect.width / 20), y: 0, width: rect.height / 4, height: rect.height / 4))
			bottomView = UIView(frame: CGRect(x: 0, y: 0, width: rect.width - (rect.width / 20), height: rect.height))
		}
        _ = topView.setTColor(backColor)
		bottomView.backgroundColor = backColor
		topView.pointing = self.arrowFacing
        let textView = UILabel(frame: CGRect(x: 5, y: 5, width: bottomView.frame.width - 10, height: bottomView.frame.height - 9))
		textView.lineBreakMode = .byWordWrapping
		textView.numberOfLines = Int(ceil((textView.frame.height / 35) + CGFloat(arrowFacing == .left || arrowFacing == .right)))
		let widthConstraint = NSLayoutConstraint(item: textView, attribute: NSLayoutAttribute.width, relatedBy: NSLayoutRelation.equal, toItem: nil, attribute: NSLayoutAttribute.notAnAttribute, multiplier: 1, constant: textView.frame.width)
        textView.text = self.text
        textView.textColor = textColor
        bottomView.addSubview(textView)
		bottomView.addConstraint(widthConstraint)
        self.addSubview(bottomView)
        self.addSubview(topView)
    }
    
    public func dismiss(_: Bool) {
        UIView.animate(withDuration: 1.0, animations: {() -> Void in self.alpha = 0.0
        }, completion: self.dismissV)
    }
    
    func dismissV(_: Bool) {
        self.removeFromSuperview()
		self.completed()
    }
    
}

internal protocol HSBColorPickerDelegate : NSObjectProtocol {
    func HSBColorColorPickerTouched(sender:HSBColorPicker, color:UIColor,    point:CGPoint, state:UIGestureRecognizerState)
}

class ColorDelegate : NSObject, HSBColorPickerDelegate {
    
    var color : UIColor = UIColor(red: (12 / 256) as CGFloat, green: (34 / 256) as CGFloat, blue: (56 / 256) as CGFloat, alpha: 1.0 as CGFloat)
    
    func HSBColorColorPickerTouched(sender:HSBColorPicker, color:UIColor,    point:CGPoint, state:UIGestureRecognizerState) {
        self.color = color
    }
    
}

@IBDesignable
class HSBColorPicker : UIView {
    
    var delegate: ColorDelegate = ColorDelegate()
    let saturationExponentTop:Float = 2.0
    let saturationExponentBottom:Float = 1.3
    
    @IBInspectable var elementSize: CGFloat = 1.0 {
        didSet {
            setNeedsDisplay()
        }
    }
    
    private func initialize() {
        self.clipsToBounds = true
        let touchGesture = UILongPressGestureRecognizer(target: self, action: #selector(HSBColorPicker.touchedColor))
        touchGesture.minimumPressDuration = 0
        touchGesture.allowableMovement = CGFloat.greatestFiniteMagnitude
        self.addGestureRecognizer(touchGesture)
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        initialize()
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        initialize()
    }
    
    override func draw(_ rect: CGRect) {
        let context = UIGraphicsGetCurrentContext()
        
        for y in stride(from: 0, to: rect.height, by: elementSize) {
            var saturation = y < rect.height / 2.0 ? CGFloat(2 * y) / rect.height : 2.0 * CGFloat(rect.height - y) / rect.height
            saturation = CGFloat(powf(Float(saturation), y < rect.height / 2.0 ? saturationExponentTop : saturationExponentBottom))
            let brightness = y < rect.height / 2.0 ? CGFloat(1.0) : 2.0 * CGFloat(rect.height - y) / rect.height
            
            for x in stride(from: 0, to: rect.width, by: elementSize) {
                let hue = x / rect.width
                let color = UIColor(hue: hue, saturation: saturation, brightness: brightness, alpha: 1.0)
                context!.setFillColor(color.cgColor)
                context!.fill(CGRect(x:x, y:y, width:elementSize,height:elementSize))
            }
        }
    }
    
    func getColorAtPoint(point:CGPoint) -> UIColor {
        let roundedPoint = CGPoint(x:elementSize * CGFloat(Int(point.x / elementSize)),
                                   y:elementSize * CGFloat(Int(point.y / elementSize)))
        var saturation = roundedPoint.y < self.bounds.height / 2.0 ? CGFloat(2 * roundedPoint.y) / self.bounds.height
            : 2.0 * CGFloat(self.bounds.height - roundedPoint.y) / self.bounds.height
        saturation = CGFloat(powf(Float(saturation), roundedPoint.y < self.bounds.height / 2.0 ? saturationExponentTop : saturationExponentBottom))
        let brightness = roundedPoint.y < self.bounds.height / 2.0 ? CGFloat(1.0) : 2.0 * CGFloat(self.bounds.height - roundedPoint.y) / self.bounds.height
        let hue = roundedPoint.x / self.bounds.width
        return UIColor(hue: hue, saturation: saturation, brightness: brightness, alpha: 1.0)
    }
    
    func getPointForColor(color:UIColor) -> CGPoint {
        var hue:CGFloat=0;
        var saturation:CGFloat=0;
        var brightness:CGFloat=0;
        color.getHue(&hue, saturation: &saturation, brightness: &brightness, alpha: nil);
        
        var yPos:CGFloat = 0
        let halfHeight = (self.bounds.height / 2)
        
        if (brightness >= 0.99) {
            let percentageY = powf(Float(saturation), 1.0 / saturationExponentTop)
            yPos = CGFloat(percentageY) * halfHeight
        } else {
            //use brightness to get Y
            yPos = halfHeight + halfHeight * (1.0 - brightness)
        }
        
        let xPos = hue * self.bounds.width
        
        return CGPoint(x: xPos, y: yPos)
    }
    
    func touchedColor(_ gestureRecognizer: UILongPressGestureRecognizer){
        let point = gestureRecognizer.location(in: self)
        let color = getColorAtPoint(point: point)
        
        self.delegate.HSBColorColorPickerTouched(sender: self, color: color, point: point, state:gestureRecognizer.state)
    }
}

public func display7SegRect(segnum: UInt8, x: Int, y: Int, width: Int, height: Int, thickness: Int, timeColor: UIColor) -> UIView {
    // 00111010
    // unused, top, top left, top right, middle, bottom left, bottom right, bottom
    let segview = UIView(frame: CGRect(x: x, y: y, width: width, height: height))
    let segstr = String(segnum, radix: 2).pad(with: "0", toLength: 8)
    if segstr[segstr.index(segstr.startIndex, offsetBy: 1)] == "1" {
        segview.addSubview(Draw(frame: CGRect(x: 0, y: 0, width: width, height: thickness)).setTColor(timeColor))
        
    }
    if segstr[segstr.index(segstr.startIndex, offsetBy: 2)] == "1" {
        segview.addSubview(Draw(frame: CGRect(x: 0, y: 0, width: thickness, height: height / 2)).setTColor(timeColor))
        
    }
    if segstr[segstr.index(segstr.startIndex, offsetBy: 3)] == "1" {
        segview.addSubview(Draw(frame: CGRect(x: width - thickness, y: 0, width: thickness, height: height / 2)).setTColor(timeColor))
        
    }
    if segstr[segstr.index(segstr.startIndex, offsetBy: 4)] == "1" {
        segview.addSubview(Draw(frame: CGRect(x: 0, y: height / 2, width: width, height: thickness)).setTColor(timeColor))
        
    }
    if segstr[segstr.index(segstr.startIndex, offsetBy: 5)] == "1" {
        segview.addSubview(Draw(frame: CGRect(x: 0, y: height / 2, width: thickness, height: height / 2 + thickness)).setTColor(timeColor))
        
    }
    if segstr[segstr.index(segstr.startIndex, offsetBy: 6)] == "1" {
        segview.addSubview(Draw(frame: CGRect(x: width - thickness, y: height / 2, width: thickness, height: height / 2 + thickness)).setTColor(timeColor))
        
    }
    if segstr[segstr.index(segstr.startIndex, offsetBy: 7)] == "1" {
        segview.addSubview(Draw(frame: CGRect(x: 0, y: height, width: width, height: thickness)).setTColor(timeColor))
        
    }
    
    //self.view.addSubview(segview)
    return segview
}

public func display7SegOval(segnum: UInt8, x: Int, y: Int, width: Int, height: Int, thickness: Int, timeColor: UIColor) -> UIView {
    // 00111010
    // unused, top, top left, top right, middle, bottom left, bottom right, bottom
    let segview = UIView(frame: CGRect(x: x, y: y, width: width, height: height))
    let segstr = String(segnum, radix: 2).pad(with: "0", toLength: 8)
    if segstr[segstr.index(segstr.startIndex, offsetBy: 1)] == "1" {
        segview.addSubview(DrawO(frame: CGRect(x: 0, y: 0, width: width, height: thickness)).setTColor(timeColor))
        
    }
    if segstr[segstr.index(segstr.startIndex, offsetBy: 2)] == "1" {
        segview.addSubview(DrawO(frame: CGRect(x: 0, y: thickness, width: thickness, height: (height / 2) - thickness)).setTColor(timeColor))
        
    }
    if segstr[segstr.index(segstr.startIndex, offsetBy: 3)] == "1" {
        segview.addSubview(DrawO(frame: CGRect(x: width - thickness, y: thickness, width: thickness, height: (height / 2) - thickness)).setTColor(timeColor))
        
    }
    if segstr[segstr.index(segstr.startIndex, offsetBy: 4)] == "1" {
        segview.addSubview(DrawO(frame: CGRect(x: 0, y: height / 2, width: width, height: thickness)).setTColor(timeColor))
        
    }
    if segstr[segstr.index(segstr.startIndex, offsetBy: 5)] == "1" {
        segview.addSubview(DrawO(frame: CGRect(x: 0, y: (height / 2) + thickness, width: thickness, height: (height / 2) - thickness)).setTColor(timeColor))
        
    }
    if segstr[segstr.index(segstr.startIndex, offsetBy: 6)] == "1" {
        segview.addSubview(DrawO(frame: CGRect(x: width - thickness, y: (height / 2) + thickness, width: thickness, height: (height / 2) - thickness)).setTColor(timeColor))
        
    }
    if segstr[segstr.index(segstr.startIndex, offsetBy: 7)] == "1" {
        segview.addSubview(DrawO(frame: CGRect(x: 0, y: height, width: width, height: thickness)).setTColor(timeColor))
        
    }
    return segview
    //self.view.addSubview(segview)
}

public func display7SegImage(segnum: UInt8, x: Int, y: Int, width: Int, height: Int, thickness: Int, timeColor: UIColor, segmentImg: UIImage?) -> UIView {
    // 00111010
    // unused, top, top left, top right, middle, bottom left, bottom right, bottom
    let segview = UIView(frame: CGRect(x: x, y: y, width: width, height: height))
    let segstr = String(segnum, radix: 2).pad(with: "0", toLength: 8)
    if segstr[segstr.index(segstr.startIndex, offsetBy: 1)] == "1" {
        let t = UIImageView(frame: CGRect(x: Int(Float(width) / 2.5), y: Int(Float(thickness) * -1.19), width: thickness, height: width - thickness))
        t.transform = t.transform.rotated(by: CGFloat.pi/2)
        t.image = segmentImg!.withRenderingMode(.alwaysTemplate)
        t.tintColor = timeColor
        segview.addSubview(t)
        
    }
    if segstr[segstr.index(segstr.startIndex, offsetBy: 2)] == "1" {
        let tl = UIImageView(frame: CGRect(x: 0, y: thickness, width: thickness, height: (height / 2) - thickness))
        tl.image = segmentImg!.withRenderingMode(.alwaysTemplate)
        tl.tintColor = timeColor
        segview.addSubview(tl)
        
    }
    if segstr[segstr.index(segstr.startIndex, offsetBy: 3)] == "1" {
        let tr = UIImageView(frame: CGRect(x: width - thickness, y: thickness, width: thickness, height: (height / 2) - thickness))
        tr.image = segmentImg!.withRenderingMode(.alwaysTemplate)
        tr.tintColor = timeColor
        segview.addSubview(tr)
        
    }
    if segstr[segstr.index(segstr.startIndex, offsetBy: 4)] == "1" {
        let m = UIImageView(frame: CGRect(x: Int(Float(width) / 2.5), y: (height / 3) + 1, width: thickness, height: width - thickness))
        m.transform = m.transform.rotated(by: CGFloat.pi/2)
        m.image = segmentImg!.withRenderingMode(.alwaysTemplate)
        m.tintColor = timeColor
        segview.addSubview(m)
        
    }
    if segstr[segstr.index(segstr.startIndex, offsetBy: 5)] == "1" {
        let bl = UIImageView(frame: CGRect(x: 0, y: (height / 2) + 2, width: thickness, height: (height / 2) - thickness))
        bl.image = segmentImg!.withRenderingMode(.alwaysTemplate)
        bl.tintColor = timeColor
        segview.addSubview(bl)
        
    }
    if segstr[segstr.index(segstr.startIndex, offsetBy: 6)] == "1" {
        let br = UIImageView(frame: CGRect(x: width - thickness, y: (height / 2) + 2, width: thickness, height: (height / 2) - thickness))
        br.image = segmentImg!.withRenderingMode(.alwaysTemplate)
        br.tintColor = timeColor
        segview.addSubview(br)
        
    }
    if segstr[segstr.index(segstr.startIndex, offsetBy: 7)] == "1" {
        let b = UIImageView(frame: CGRect(x: Int(Float(width) / 2.5), y: Int(Float(height) / 1.29), width: thickness, height: width - thickness))
        b.transform = b.transform.rotated(by: CGFloat.pi/2)
        b.image = segmentImg!.withRenderingMode(.alwaysTemplate)
        b.tintColor = timeColor
        segview.addSubview(b)
        
    }
    return segview
}

public func getTextColor(_ color: UIColor) -> UIColor {
    let red = color.coreImageColor.red
    let green = color.coreImageColor.green
    let blue = color.coreImageColor.blue
    let brightness = ((red * 299) + (green * 587) + (blue  * 114)) / 1000
    if (brightness > (125 / 256)) {
        return .black
    }
    else {
        return .white
    }
}

public func addStartMax(start: Int, add: Int, max: Int, min: Int = 0) -> Int {
	if start + add >= max {
		return add - (max - start) - min
	} else {
		return start + add
	}
}

func hexString(for color: UIColor) -> String {
    let components: [CGFloat] = color.cgColor.components!
    let r: CGFloat = components[0]
    let g: CGFloat = components[1]
    let b: CGFloat = components[2]
    let hexString = String(format: "%02X%02X%02X", Int(r * 255), Int(g * 255), Int(b * 255))
    return hexString
}
