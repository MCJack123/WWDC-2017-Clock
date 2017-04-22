import UIKit

public let numberSegs : [UInt8] = [
    0b01110111,
    0b00010010,
    0b01011101,
    0b01011011,
    0b00111010,
    0b01101011,
    0b01101111,
    0b01010010,
    0b01111111,
    0b01111011
]

public class ViewController : UIViewController {
    
    public var color : UIColor = UIColor.white
    public var clockType : Int = 0 // 0 = image, 1 = rectangles, 2 = ovals
    public var timeColor : UIColor = UIColor.blue
    public var timeType : Int = 2
    public var timeView : UIView = UIView()
    public var use24h : Bool = false
    public var startTime : String = "0:00:00"
    public var timeHour : Int {
        return Int(startTime.substring(to: startTime.index(startTime.startIndex, offsetBy: startTime.find(of: ":")!)))!
    }
    public var backColorButton : UIImageView = UIImageView(frame: CGRect(x: 15, y: 260, width: 30, height: 30))
    public var timeColorButton : UIImageView = UIImageView(frame: CGRect(x: 15, y: 305, width: 30, height: 30))
    public var backLabel : UILabel = UILabel(frame: CGRect(x: 50, y: 240, width: 450, height: 70))
    public var timeLabel : UILabel = UILabel(frame: CGRect(x: 50, y: 285, width: 450, height: 70))
    public var timeTypeSelector : UISegmentedControl = UISegmentedControl(items: ["Rectangle", "Oval", "Electronic", "8-Bit"])
    public var show24hSwitch : UISwitch = UISwitch(frame: CGRect(x: 15, y: 395, width: 50, height: 30))
    public var show24hLabel : UILabel = UILabel(frame: CGRect(x: 80, y: 395, width: 150, height: 30))
    public var startTimeText : UITextField = UITextField(frame: CGRect(x: 15, y: 440, width: 100, height: 30))
    public var startTimeButton : UIButton = UIButton(frame: CGRect(x: 110, y: 440, width: 50, height: 30))
    public var timeMin : Int {
        if startTime.lastIndexOf(":")! > startTime.find(of: ":")! {
            return Int(startTime.substring(with: Range<String.Index>(uncheckedBounds: (lower: startTime.index(startTime.startIndex, offsetBy: startTime.find(of: ":")! + 1), upper: startTime.index(startTime.startIndex, offsetBy: startTime.lastIndexOf(":")!)))))!
        } else {
            return Int(startTime.substring(from: startTime.index(startTime.startIndex, offsetBy: startTime.find(of: ":")! + 1)))!
        }
    }
    public var timeSec : Int {
        if startTime.lastIndexOf(":")! > startTime.find(of: ":")! {
            return Int(startTime.substring(from: startTime.index(startTime.startIndex, offsetBy: startTime.lastIndexOf(":")! + 1)))!
        } else {
            return -1
        }
    }
	public var doneTut : Bool = false
	public var skipHour : Bool = false
	var shour : Int = 0
	var smin : Int = 0
    var ssec : Int = Calendar.current.component(.second, from: Date())
    var segmentImg : UIImage? = UIImage(named: "segment")
    
    public func displayTooltip(_ text: String, frame: CGRect, facing: Direction = .up, backColor: UIColor = .white, completion: @escaping () -> () = {() in }) {
        let tool = ToolTip(frame: frame)
        tool.text = text
        tool.backColor = backColor
        tool.textColor = getTextColor(backColor)
		tool.completed = completion
		tool.arrowFacing = facing
        let singleFingerTap = UITapGestureRecognizer(target: tool, action: #selector(tool.dismiss))
        tool.addGestureRecognizer(singleFingerTap)
        self.view.addSubview(tool)
        tool.draw(frame)
    }
    
    
    public func display7Seg(segnum: UInt8, type: Int, x: Int, y: Int, width: Int, height: Int, thickness: Int) -> UIView {
        if type == 0 {
            return display7SegRect(segnum: segnum, x: x, y: y, width: width, height: height, thickness: thickness, timeColor: timeColor)
        } else if type == 1 {
            return display7SegOval(segnum: segnum, x: x, y: y, width: width, height: height, thickness: thickness, timeColor: timeColor)
        } else if (type == 3) {
            return display7SegImage(segnum: segnum, x: x, y: y, width: width, height: height, thickness: thickness, timeColor: timeColor, segmentImg: UIImage(named: "segment2"))
        } else {
            return display7SegImage(segnum: segnum, x: x, y: y, width: width, height: height, thickness: thickness, timeColor: timeColor, segmentImg: segmentImg)
        }
        
    }
    
    public func displayColon(isCircle: Bool, x: Int, y: Int, height: Int, thickness: Int) -> UIView {
        let segview : UIView = UIView(frame: CGRect(x: (x), y: (y), width: (thickness), height: (height)))
        if isCircle {
            segview.addSubview(DrawO(frame: CGRect(x: 0, y: 0, width: thickness, height: thickness)).setTColor(timeColor))
            segview.addSubview(DrawO(frame: CGRect(x: 0, y: height, width: thickness, height: thickness)).setTColor(timeColor))
        } else {
            segview.addSubview(Draw(frame: CGRect(x: 0, y: 0, width: thickness, height: thickness)).setTColor(timeColor))
            segview.addSubview(Draw(frame: CGRect(x: 0, y: height, width: thickness, height: thickness)).setTColor(timeColor))
        }
        return segview
    }
    
    public func displayTime(hour: Int, minute: Int, second: Int = -1, show24h: Bool = false) {
        var t = 0
        if timeView != UIView() {
            let viewWithTag = self.view.viewWithTag(100)
            viewWithTag?.removeFromSuperview()
        }
        let width = 240 + (Int(show24h) * 70) + (Int(second > -1) * 170) + (Int(!show24h) * 140) + (Int(!show24h && ((hour > 9 && hour < 13) || (hour > 21) || (hour == 0))) * 100)
        timeView = UIView(frame: CGRect(x: 340 - (width / 2), y: 75, width: width, height: 120))
        timeView.tag = 100
        if show24h {
            timeView.addSubview(display7Seg(segnum: numberSegs[((hour % 100) - (hour % 10)) / 10], type: timeType, x: 50-50, y: 0, width: 50, height: 120, thickness: 10))
            timeView.addSubview(display7Seg(segnum: numberSegs[hour % 10], type: timeType, x: 120-50, y: 0, width: 50, height: 120, thickness: 10))
        } else {
            let hourH = hour % 12 != 0 ? hour % 12 : 12
            if (hourH > 9) {
                timeView.addSubview(display7Seg(segnum: numberSegs[((hourH % 100) - (hourH % 10)) / 10], type: timeType, x: 50-50, y: 0, width: 50, height: 120, thickness: 10))
            } else {
                t = 70
            }
            timeView.addSubview(display7Seg(segnum: numberSegs[hourH % 10], type: timeType, x: 120-t-50, y: 0, width: 50, height: 120, thickness: 10))
        }
        timeView.addSubview(displayColon(isCircle: timeType != 0, x: 190-t-50, y: 10, height: 95, thickness: 10))
        timeView.addSubview(display7Seg(segnum: numberSegs[((minute % 100) - (minute % 10)) / 10], type: timeType, x: 220-t-50, y: 0, width: 50, height: 120, thickness: 10))
        timeView.addSubview(display7Seg(segnum: numberSegs[minute % 10], type: timeType, x: 290-t-50, y: 0, width: 50, height: 120, thickness: 10))
        var startPos = 360
        if second > -1 {
            timeView.addSubview(displayColon(isCircle: timeType != 0, x: 360-t-50, y: 10, height: 95, thickness: 10))
            timeView.addSubview(display7Seg(segnum: numberSegs[((second % 100) - (second % 10)) / 10], type: timeType, x: 390-t-50, y: 0, width: 50, height: 120, thickness: 10))
            timeView.addSubview(display7Seg(segnum: numberSegs[second % 10], type: timeType, x: 460-t-50, y: 0, width: 50, height: 120, thickness: 10))
            startPos = 530
        }
        if !show24h {
            timeView.addSubview(display7Seg(segnum: 124 + (UInt8(hour < 12) * 2), type: timeType, x: startPos-t-50, y: 0, width: 50, height: 120, thickness: 10))
            timeView.addSubview(display7Seg(segnum: 116, type: timeType, x: startPos + 70-t-50, y: 0, width: 40, height: 120, thickness: 10))
            timeView.addSubview(display7Seg(segnum: 82, type: timeType, x: startPos + 100-t-50, y: 0, width: 40, height: 120, thickness: 10))
        }
        self.view.addSubview(timeView)
    }
	
	public func updateTime() {
		if addStartMax(start: timeSec, add: addStartMax(start: ssec, add: Calendar.current.component(.second, from: Date()), max: 60), max: 60) == 0 {
			smin += 1
		}
		if smin > 59 {
			smin = 0
			shour += 1
		}
		if shour > 23 {
			shour = 0
		}
		self.displayTime(hour: shour, minute: smin, second: timeSec != -1 ? addStartMax(start: timeSec, add: addStartMax(start: ssec, add: Calendar.current.component(.second, from: Date()), max: 60), max: 60) : -1, show24h: self.use24h)
        backColorButton.tintColor = color
        timeColorButton.tintColor = timeColor
        timeType = timeTypeSelector.selectedSegmentIndex
        use24h = show24hSwitch.isOn
	}
	
	public func getTooltipText() -> (String, CGRect, Direction) {
		if self.startTime == "6:25:15" {
			if self.use24h == false && !self.skipHour {
				if self.timeType == 2 {
					if self.timeColor == #colorLiteral(red: 0.2549019754, green: 0.2745098174, blue: 0.3019607961, alpha: 1) {
						if self.color == #colorLiteral(red: 0.9254902005, green: 0.2352941185, blue: 0.1019607857, alpha: 1) {
							if self.doneTut == false {
								return ("Welcome to this playground. This tutorial will show you how to customize the clock to how you want it. (Click tooltip to continue)", CGRect(x: 80, y: 200, width: 520, height: 70), .up)
							}
							return ("You can change the background color by changing this. Click on the orange square, and choose a color now. (Click to continue)", CGRect(x: 150, y: 265, width: 450, height: 70), .left)
						} else {
							return ("You can also change the text color with this. Try it now.", CGRect(x: 100, y: 305, width: 450, height: 35), .left)
						}
					} else {
						return ("There are four different designs for the look of the clock segments: rectangular, elliptical, electronic (this one), and 8-bit. Try changing the design of the segments and see what happens!", CGRect(x: 215, y: 385, width: 450, height: 155), .up)
                    }
				} else {
					return ("The next option is to change between 12- and 24-hour time. If it is on, time will be displayed like \"19:04\", and if it is off, the time will be like \"7:04 PM\". You can change it, or just click on the tooltip to skip.", CGRect(x: 200, y: 395, width: 450, height: 110), .left)
				}
			} else {
				return ("You can change the time the clock starts at when you run the playground here. Just change the time (in 24-hour time) to set the start time. If you don't want to show seconds, then don't write them in the start time. Try changing the start time now.", CGRect(x: 160, y: 442, width: 520, height: 95), .left)
			}
		} else {
			return ("You have completed the tutorial! You can go and change this clock any way you want now. Thank you for using!", CGRect(x: 115, y: 5, width: 450, height: 70), .down)
		}
	}
    
    func screenLog(_ t: String) {
        NSLog(t)
        let tx = UILabel(frame: CGRect(x: 100, y: 400, width: 300, height: 40))
        tx.text = t
        self.view.addSubview(tx)
    }
    
    public func displayColorPicker(frame: CGRect, button: Bool) {
        let pickView = HSBColorPicker(frame: frame)
        self.view.addSubview(pickView)
        
        var timer : Timer = Timer()
        timer = Timer.scheduledTimer(withTimeInterval: 0.5, repeats: true, block: {(Timer) in
            if hexString(for: pickView.delegate.color) != "0B2137" && hexString(for: pickView.delegate.color) != "123456" {
                timer.invalidate()
                pickView.removeFromSuperview()
                self.setButtonColor(pickView.delegate.color, button: button)
            }
        })
        
        //return (UIColor.blue, ":" + String(describing: type(of: pickView.dataSource!)))
    }
    
    func selectColor() {
        //if sender.tag == 70 {
            displayColorPicker(frame: CGRect(x: 60, y: 180, width: 100, height: 160), button: true)
        //} else if sender.tag == 140 {
            //displayColorPicker(frame: CGRect(x: 60, y: 225, width: 100, height: 160), button: true)
        //}
    }
    
    func selectColor2() {
        //if sender.tag == 70 {
            //displayColorPicker(frame: CGRect(x: 60, y: 180, width: 100, height: 160), button: false)
        //} else if sender.tag == 140 {
            displayColorPicker(frame: CGRect(x: 60, y: 225, width: 100, height: 160), button: false)
        //}
    }
    
    public func updateTooltip() {
        let tooltip = getTooltipText()
        if tooltip.0 == "Welcome to this playground. This tutorial will show you how to customize the clock to how you want it. (Click tooltip to continue)" {
            displayTooltip(tooltip.0, frame: tooltip.1, facing: tooltip.2, backColor: getTextColor(color), completion: {() in
                self.doneTut = true
                self.updateTooltip()
            })
        } else if tooltip.0 == "The next option is to change between 12- and 24-hour time. If it is on, time will be displayed like \"19:04\", and if it is off, the time will be like \"7:04 PM\". You can change it, or just click on the tooltip to skip." {
            displayTooltip(tooltip.0, frame: tooltip.1, facing: tooltip.2, backColor: getTextColor(color), completion: {() in
                self.skipHour = true
                self.updateTooltip()
            })
        } else {
            displayTooltip(tooltip.0, frame: tooltip.1, facing: tooltip.2, backColor: getTextColor(color), completion: updateTooltip)
        }
    }
    
    public func updateStart() {
        startTime = startTimeText.text!
        shour = timeHour
        smin = timeMin
        self.updateTime()
    }
    
    override public func loadView() {
        let newView = UIView(frame: CGRect(x: 0, y: 0, width: 680, height: 620))
        newView.backgroundColor = .white
        
        self.view = newView
    }
    
    override public func viewDidLoad() {
        super.viewDidLoad()
        /*var colorS = UIButton(frame: CGRect(x: 160, y: 580, width: 160, height: 8))
        colorS.setTitle("Swap Colors", for: .normal)
    colorS.setTitleColor(self.view.tintColor, for: .normal)
        colorS.tag = 1
        self.view.addSubview(colorS)*/
        self.view.backgroundColor = color
        timeTypeSelector.selectedSegmentIndex = 2
        backColorButton.tag = 70
        timeColorButton.tag = 140
        backColorButton.image = UIImage(named: "RoundRect")!.withRenderingMode(.alwaysTemplate)
        timeColorButton.image = UIImage(named: "RoundRect")!.withRenderingMode(.alwaysTemplate)
        backColorButton.tintColor = color
        timeColorButton.tintColor = timeColor
        backColorButton.layer.borderWidth = 1
        timeColorButton.layer.borderWidth = 1
        let gesture = UITapGestureRecognizer(target: self, action: #selector(selectColor))
        backColorButton.addGestureRecognizer(gesture)
        backColorButton.isUserInteractionEnabled = true
        let gesture2 = UITapGestureRecognizer(target: self, action: #selector(selectColor2))
        timeColorButton.addGestureRecognizer(gesture2)
        timeColorButton.isUserInteractionEnabled = true
		shour = timeHour
		smin = timeMin
		self.updateTime()
        Timer.scheduledTimer(withTimeInterval: 1.0, repeats: true, block: { (Timer) in self.updateTime()})
		updateTooltip()
        backLabel.text = "Background"
        timeLabel.text = "Time"
        backLabel.textColor = getTextColor(color)
        timeLabel.textColor = getTextColor(color)
        timeTypeSelector.frame = CGRect(x: 15, y: 350, width: 300, height: 30)
        show24hLabel.text = "12/24hr Clock"
        startTimeText.placeholder = "Start Time"
        startTimeButton.setTitle("Set", for: .normal)
        startTimeButton.addTarget(self, action: #selector(updateStart), for: .touchUpInside)
        startTimeText.text = startTime
        startTimeText.backgroundColor = getTextColor(color)
        self.view.addSubview(backLabel)
        self.view.addSubview(timeLabel)
        self.view.addSubview(backColorButton)
        self.view.addSubview(timeColorButton)
        self.view.addSubview(timeTypeSelector)
        self.view.addSubview(show24hSwitch)
        self.view.addSubview(show24hLabel)
        self.view.addSubview(startTimeText)
        self.view.addSubview(startTimeButton)
    }
    
    func setButtonColor (_ color: UIColor, button: Bool) {
        if button {
            backColorButton.tintColor = color
            self.color = color
            self.view.backgroundColor = color
        } else {
            timeColorButton.tintColor = color
            self.timeColor = color
        }
    }
    
}
