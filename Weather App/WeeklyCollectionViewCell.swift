//
//  WeeklyCollectionViewCell.swift
//  Weather App
//
//  Created by administrator on 05/01/2022.
//

import UIKit

class WeeklyCollectionViewCell: UICollectionViewCell {
    @IBOutlet weak var labelDay: UILabel!
    @IBOutlet weak var labelTemp: UILabel!
    @IBOutlet weak var contentViewWeekly: UIView!
    
    func setupCell(day: String, temp: String) {
        labelDay.text = day
        labelTemp.text = temp + "°"
        contentView.layer.cornerRadius = 10
        contentView.clipsToBounds = true
    }
}
