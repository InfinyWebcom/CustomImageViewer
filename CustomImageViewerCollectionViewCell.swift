//
//  CustomImageViewerCollectionViewCell.swift
//
//  Created by Siddhesh jadhav on 24/12/21.
//  Copyright © 2021 Apple. All rights reserved.
//

import UIKit

class CustomImageViewerCollectionViewCell: UICollectionViewCell {
    
    @IBOutlet weak var imageView: UIImageView!
    @IBOutlet weak var wrapperView: UIView!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }
    
    override var isSelected: Bool {
        didSet{
            if self.isSelected {
                self.transform = CGAffineTransform(scaleX: 1.1, y: 1.1)
                self.wrapperView.borderWidth = 1.0
                self.wrapperView.borderColor = .white
            }else {
                self.transform = CGAffineTransform.identity
                self.wrapperView.borderWidth = 0.0
                self.wrapperView.borderColor = .clear
            }
        }
    }
}
