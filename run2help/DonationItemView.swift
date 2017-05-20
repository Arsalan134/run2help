//
//  DonationItem.swift
//  run2help
//
//  Created by Arsalan Iravani on 26.03.17.
//  Copyright © 2017 Arsalan Iravani. All rights reserved.
//

import UIKit

class DonationItemView: UIView {
    
    var donationItemViewID: String?
    @IBOutlet weak var donationImageView: UIImageView!
    @IBOutlet weak var donationTitle: UILabel!
    @IBOutlet weak var donationDescription: UILabel!
    @IBOutlet weak var donationPeopleDonatedText: UILabel!
    @IBOutlet weak var donationButton: UIButton!
    
    override func awakeFromNib() {
        
//        donationButton.clipsToBounds = true
        donationImageView.clipsToBounds = true
        
        donationTitle.adjustsFontSizeToFitWidth = true
        donationDescription.adjustsFontSizeToFitWidth = true
        donationPeopleDonatedText.adjustsFontSizeToFitWidth = true
        donationButton.titleLabel?.adjustsFontSizeToFitWidth = true
        
        // constraint
        donationDescription.translatesAutoresizingMaskIntoConstraints = false
        
        donationDescription.leftAnchor.constraint(equalTo: self.leftAnchor, constant: 30).isActive = true
        donationDescription.topAnchor.constraint(equalTo: donationTitle.bottomAnchor, constant: 12).isActive = true
        donationDescription.rightAnchor.constraint(equalTo: self.rightAnchor, constant: -30).isActive = true
        donationDescription.bottomAnchor.constraint(equalTo: donationPeopleDonatedText.topAnchor, constant: -12).isActive = true
    }
}
