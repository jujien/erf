//
//  InstructorCollectionViewCell.swift
//  ERF
//
//  Created by Vũ Kiên on 27/07/2016.
//  Copyright © 2016 Kiên Vũ. All rights reserved.
//

import UIKit

class InstructorCollectionViewCell: UICollectionViewCell {
    @IBOutlet weak var avatarImageView: UIImageView!
    @IBOutlet weak var attandanceView: UIView!
    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var codeLabel: UILabel!
    
    var instructor: Instructor? {
        didSet {
            self.layout()
        }
    }
    
    func layout() -> Void {
        self.layer.shadowColor = UIColor.blackColor().CGColor
        self.layer.shadowOpacity = 0.8
        self.layer.shadowOffset = CGSizeZero
        self.layer.shadowRadius = 10
        self.layer.cornerRadius = 5
        self.clipsToBounds = true
        
        nameLabel.text = "\(instructor!.name)"
        codeLabel.text = "\(instructor!.code)"
        LazyImage.showForImageView(avatarImageView, url: instructor?.imageUrl)
    }
    
    func pathImage(imageName: String) -> NSURL {
        return NSURL(fileURLWithPath: NSTemporaryDirectory()).URLByAppendingPathComponent(imageName)
    }
}
