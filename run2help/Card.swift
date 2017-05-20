//
//  Card.swift
//  run2help
//
//  Created by Arsalan Iravani on 08.04.17.
//  Copyright © 2017 Arsalan Iravani. All rights reserved.
//

import Foundation
import UIKit

class Card {
    var id: String?
    var title: String?
    var descriptionText: String?
    var image: UIImage?
    var numberOfDonatedPeople: Int?
    var donatedMoney: Int?
    
    init(id: String, title: String, descriptionText: String, image: UIImage, numberOfDonatedPeople: Int, donatedMoney: Int) {
        self.id = id
        self.title = title
        self.descriptionText = descriptionText
        self.image = image
        self.numberOfDonatedPeople = numberOfDonatedPeople
        self.donatedMoney = donatedMoney
    }
    
}



