//
//  RealmTableViewCell.swift
//  homeWork27
//
//  Created by Валерий Вергейчик on 10.07.22.
//  Created by Валерий Вергейчик on 7.07.22.
//

import UIKit

class RealmTableViewCell: UITableViewCell {

    @IBOutlet weak var latLabel: UILabel!
    @IBOutlet weak var lonLabel: UILabel!
    @IBOutlet weak var tempLabel: UILabel!
    @IBOutlet weak var feelsLikeLabel: UILabel!
    @IBOutlet weak var descriptionLabel: UILabel!
    @IBOutlet weak var timeLabel: UILabel!
    
    static let key = "RealmTableViewCell"
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}
