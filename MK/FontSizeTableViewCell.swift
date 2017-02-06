//
//  FontSizeTableViewCell.swift
//  MK
//
//  Created by MK on 16/9/4.
//  Copyright © 2016年 MK. All rights reserved.
//

import UIKit

class FontSizeTableViewCell: UITableViewCell {

    
    @IBOutlet var slider: UISlider!
    var fontSize: Float? {
        didSet {
            updateUI()
        }
    }
    
    var delegate: ResizeFontTableViewControllerDelegate?
    
    
    // MARK: - Computed Properties
    
    var scale : CGFloat {
        var scale: CGFloat = 1
        if Device.IS_IPHONE_5 {
            scale = 320/375
        } else if Device.IS_IPHONE_6P {
            scale = 414/375
        } else if Device.IS_IPHONE_4_OR_LESS {
            scale = 320/375
        }
        return scale
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        slider.isContinuous = true
        slider.addTarget(self, action: #selector(sliderValueChanged(_:)), for: .valueChanged)
        
        configureLabel()
        
        let tap = UITapGestureRecognizer(target: self, action: #selector(sliderTapGestureHandle(_:)))
        slider.addGestureRecognizer(tap)
    }
    
    func updateUI() {
        
        if let fontSize = self.fontSize {
            
            slider.value = fontSize
        }
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    func sliderValueChanged(_ slider: UISlider) {
        if slider.value > 90 && slider.value < 95 {
            slider.value = 90
            delegate?.resizeFont(90)
        }
        if slider.value >= 95 && slider.value < 105 {
            slider.value = 100
            delegate?.resizeFont(100)
        }
        if slider.value >= 105 && slider.value < 115 {
            slider.value = 110
            delegate?.resizeFont(110)
        }
        if slider.value >= 115 && slider.value < 125 {
            slider.value = 120
            delegate?.resizeFont(120)
        }
        if slider.value >= 125 && slider.value < 130 {
            slider.value = 130
            delegate?.resizeFont(130)
        }
    }
    
    func configureLabel() {
        
        let label_0 = UILabel()
        
        label_0.text = "A"
        label_0.frame = CGRect(x: 28, y: 30, width: 20, height: 20)
        label_0.font = UIFont.systemFont(ofSize: 15)
        
        self.addSubview(label_0)
        
        let label_1 = UILabel()
        
        label_1.text = "A"
        label_1.font = UIFont.systemFont(ofSize: 21.6)
        
        if Device.IS_IPHONE_6 {
            label_1.frame = CGRect(x: 336, y: 30, width: 40, height: 20)
        } else if Device.IS_IPHONE_6P {
            label_1.frame = CGRect(x: 372, y: 30, width: 40, height: 20)
        } else {
            label_1.frame = CGRect(x: 281, y: 30, width: 40, height: 20)
        }
        
        self.addSubview(label_1)
        
        
        let label_2 = UILabel()
        
        label_2.text = "标准"
        label_2.frame = CGRect(x: 94, y: 30, width: 60, height: 20)
        label_2.textColor = UIColor.fromRGB(0xCCCCCC)
        if Device.IS_IPHONE_6 {
            label_2.frame = CGRect(x: 94, y: 30, width: 60, height: 20)
        } else if Device.IS_IPHONE_6P {
            label_2.frame = CGRect(x: 101.5, y: 30, width: 60, height: 20)
        } else {
            label_2.frame = CGRect(x: 79, y: 30, width: 60, height: 20)
        }
        
        self.addSubview(label_2)
    }
    
    func sliderTapGestureHandle(_ gesture: UITapGestureRecognizer) {
        
        let position = gesture.location(in: slider)
        
        if position.x < (50 * scale) {
            slider.value = 90
            delegate?.resizeFont(90)
        }
        if position.x > (80 * scale) && position.x < (130 * scale) {
            slider.value = 100
            delegate?.resizeFont(100)
        }
        if position.x > (155 * scale) && position.x < (195 * scale) {
            slider.value = 110
            delegate?.resizeFont(110)
        }
        if position.x > (225 * scale) && position.x < (265 * scale) {
            slider.value = 120
            delegate?.resizeFont(120)
        }
        if position.x > (295 * scale) {
            slider.value = 130
            delegate?.resizeFont(130)
        }
    }
}
