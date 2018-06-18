//
//  ImageCollectionCell.swift
//  ImageApp
//
//  Created by Alanda Syla on 11/4/17.
//  Copyright © 2017 Alanda Syla. All rights reserved.
//

import UIKit

class ImageCollectionCell: UICollectionViewCell {

    @IBOutlet weak var imageView: UIImageView!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }
}

extension UICollectionView {
    func registerImageCollectionCell() {
        let nib = UINib(nibName: "ImageCollectionCell", bundle: nil)
        self.register(nib, forCellWithReuseIdentifier: "ImageCollectionCell")
    }
    
    func dequeueImageCollectionCell(indexPath: IndexPath) -> ImageCollectionCell {
        return self.dequeueReusableCell(withReuseIdentifier: "ImageCollectionCell", for: indexPath) as! ImageCollectionCell
    }
}
