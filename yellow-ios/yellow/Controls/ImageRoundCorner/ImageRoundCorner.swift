//
//  ImageRoundCorner.swift
//  yellow
//
//  Created by Nattapong Unaregul on 9/18/17.
//  Copyright © 2017 23. All rights reserved.
//

import UIKit
@IBDesignable
class ImageRoundCorner: UIImageView {
    
    override func layoutSubviews() {
        super.layoutSubviews()
        self.layer.cornerRadius = self.bounds.width / 2
    }
    
}
