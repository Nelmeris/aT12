//
//  CustomTableViewCell.swift
//  Offers
//
//  Created by Igor on 03.07.2020.
//  Copyright © 2020 Igor Gapanovich. All rights reserved.
//

import UIKit
import UI

protocol CustomTableViewCellProtocol: class {
    func fillData(offer: Offer)
}

class CustomTableViewCell: UITableViewCell, CustomTableViewCellProtocol {
    func fillData(offer: Offer) {
    }
}
