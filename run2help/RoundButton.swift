//
//  RoundButton.swift
//  run2help
//
//  Created by Arsalan Iravani on 28.03.17.
//  Copyright © 2017 Arsalan Iravani. All rights reserved.
//

import UIKit

//@IBDesignable
class RoundButton: UIButton {
    
    @IBInspectable
    var cornerRadius: CGFloat = 0 {
        didSet {
            self.layer.cornerRadius = cornerRadius
        }
    }
    
    @IBInspectable
    var borderWidth: CGFloat = 0 {
        didSet {
            self.layer.borderWidth = borderWidth
        }
    }
    
    @IBInspectable
    var borderColor: UIColor = .clear {
        didSet {
            self.layer.borderColor = borderColor.cgColor
        }
    }

    override func awakeFromNib() {
        imageView?.contentMode = .scaleAspectFill
    }
    
    
}
