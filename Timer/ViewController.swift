//
//  ViewController.swift
//  Timer
//
//  Created by Cong Chen on 3/10/17.
//  Copyright © 2017 Cong Chen. All rights reserved.
//

import UIKit

class ViewController: UIViewController, UIPickerViewDelegate, UIPickerViewDataSource
{
    var seconds = 0
    var timer = Timer()
    @IBOutlet weak var labelDisplay: UILabel!
    @IBOutlet weak var pickerView  : UIPickerView!
    @IBOutlet weak var btStart: UIButton!
    @IBOutlet weak var btStop: UIButton!

    override func viewDidLoad() {
        super.viewDidLoad()
        updateDisplay()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }

    @IBAction func onStart(_ sender: UIButton)
    {
        timer = Timer.scheduledTimer(timeInterval: 1, target: self, selector: #selector(ViewController.timeout), userInfo: nil, repeats: true)
        btStart.isEnabled = false
        pickerView.isHidden = true
    }

    @IBAction func onStop(_ sender: UIButton)
    {
        if timer.isValid {
            resetSeconds()
        }
        else {
            seconds = 0
            pickerView.selectRow(0, inComponent: 0, animated: true)
            pickerView.selectRow(0, inComponent: 2, animated: true)
        }
        
        timer.invalidate()
        updateDisplay()
        btStart.isEnabled = true
        pickerView.isHidden = false
    }
    
    func timeout()
    {
        seconds -= 1
        
        if seconds >= 0 {
            updateDisplay()
        }
        
        if seconds <= 0 {
            timer.invalidate()
            btStart.isEnabled = true
            pickerView.isHidden = false
        }
    }
    
    func numberOfComponents(in _: UIPickerView) -> Int {
        return 4
    }
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        switch component {
        case 0:
            return 61
        case 1:
            return 1
        case 2:
            return 60
        case 3:
            return 1
        default:
            return 1
        }
    }

    func pickerView(_: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        return pickerData(forComponent: component, forRow: row)
    }
    
    func pickerData(forComponent component: Int, forRow row: Int) -> String {
        switch component {
        case 0:
            return "\(row)"
        case 1:
            return "min"
        case 2:
            return "\(row)"
        case 3:
            return "sec"
        default:
            return ""
        }
    }
    
    func updateDisplay()
    {
        let minute = seconds / 60
        let second = seconds - minute * 60
        labelDisplay.text = String(format: "%02d:%02d", minute, second)
    }
    
    func resetSeconds()
    {
        let minute = pickerView.selectedRow(inComponent: 0)
        let second = pickerView.selectedRow(inComponent: 2)
        seconds = minute * 60 + second
    }
    
    // Pickerview moved
    func pickerView(_: UIPickerView, didSelectRow row: Int, inComponent component: Int)
    {
        resetSeconds()
        updateDisplay()
    }

    func pickerView(_: UIPickerView, widthForComponent component: Int) -> CGFloat {
        // labels
        if component == 1 || component == 3 {
            return 50
        }
        return 100
    }
    
    // Pickerview font
    func pickerView(_ pickerView: UIPickerView, viewForRow row: Int, forComponent component: Int, reusing view: UIView?) -> UIView
    {
        var label: UILabel
        if let view = view as? UILabel {
            label = view
        } else {
            label = UILabel()
        }
        
        let data = pickerData(forComponent: component, forRow: row)
        let title = NSAttributedString(string: data, attributes: [NSFontAttributeName: UIFont.systemFont(ofSize: 30.0, weight: UIFontWeightRegular)])
        label.attributedText = title
        label.textAlignment = .center
        
        return label
    }
    
    // Pickerview row height
    func pickerView(_: UIPickerView, rowHeightForComponent component: Int) -> CGFloat {
        return 40.0
    }
}

