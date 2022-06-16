//
//  DetailsProductTableViewCell.swift
//  NomadStory
//
//  Created by Ahmed on 6/15/22.
//

import UIKit

class DetailsProductTableViewCell: UITableViewCell {

    static let cellID = "DetailsProductTableViewCell"
    
    @IBOutlet weak var containerView: UIView!
    @IBOutlet weak var imageOutlet: UIImageView!
    @IBOutlet weak var productImage: UIImageView!
    @IBOutlet weak var titleLabelOutlet: UILabel!
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
