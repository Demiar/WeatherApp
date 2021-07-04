//
//  CustomTableViewCell.swift
//  WeatherApp
//
//  Created by Алексей on 04.07.2021.
//

import UIKit

class CustomTableViewCell: UITableViewCell {
    @IBOutlet weak var iconImage: UIImageView!
    @IBOutlet weak var cityLabel: UILabel!
    @IBOutlet weak var temperatureLabel: UILabel!
    @IBOutlet weak var activityIndicator: UIActivityIndicatorView!
    
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        iconImage.isHidden = true
        cityLabel.isHidden = true
        temperatureLabel.isHidden = true
        activityIndicator.startAnimating()
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
