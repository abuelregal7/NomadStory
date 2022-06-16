//
//  TotalPriceTableViewCell.swift
//  NomadStoryTask
//
//  Created by Ahmed on 6/16/22.
//

import UIKit

class TotalPriceTableViewCell: UITableViewCell {
    
    static let cellID = "TotalPriceTableViewCell"
    
    @IBOutlet weak var containerView: UIView!
    @IBOutlet weak var priceLabelOutlet: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}
