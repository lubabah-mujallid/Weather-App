//
//  DailyCollectionViewCell.swift
//  Weather App
//
//  Created by administrator on 05/01/2022.
//

import UIKit

class DailyCollectionViewCell: UICollectionViewCell {
    @IBOutlet weak var labelWeatherTitle: UILabel!
    @IBOutlet weak var labelWeatherDetails: UILabel!
    @IBOutlet weak var contenViewDaily: UIView!
    
    func setupCell(title:String, details: String) {
        labelWeatherTitle.text = title
        labelWeatherDetails.text = details
        contentView.layer.cornerRadius = 10
        contentView.clipsToBounds = true
    }
}
