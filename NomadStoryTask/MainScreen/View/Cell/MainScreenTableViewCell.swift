//
//  MainScreenTableViewCell.swift
//  NomadStory
//
//  Created by Ahmed on 6/15/22.
//

import UIKit

class MainScreenTableViewCell: UITableViewCell {

    static let cellID = "MainScreenTableViewCell"
    
    @IBOutlet weak var containerView: UIView!
    @IBOutlet weak var imageOutlet: UIImageView!
    @IBOutlet weak var titleLabelOutlet: UILabel!
    @IBOutlet weak var priceLabelOutlet: UILabel!
    @IBOutlet weak var loveButtonOutlet: UIButton!
    
    var tappedButton: (() -> Void)?
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        selectionStyle = .none
        
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    @IBAction func loveButtonAction(_ sender: Any) {
        
        tappedButton?()
        
    }
    
}
