//
//  MenuTableViewCell.swift
//  ERF
//
//  Created by Vũ Kiên on 26/07/2016.
//  Copyright © 2016 Kiên Vũ. All rights reserved.
//

import UIKit

class MenuTableViewCell: UITableViewCell {

    @IBOutlet weak var iconImageView: UIImageView!
    @IBOutlet weak var menuLabel: UILabel!
    
    var menuItem: LeftMenuItem? {
        didSet {
            self.setupLayout()
        }
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
    }

    override func setSelected(selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    func setupLayout() -> Void {
        if let menu = self.menuItem {
            menuLabel.text = menu.title
            iconImageView.image = UIImage(named: menu.icon!)
        }
    }

}
