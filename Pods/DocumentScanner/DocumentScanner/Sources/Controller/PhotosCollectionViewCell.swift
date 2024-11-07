//
//  PhotosCollectionViewCell.swift
//  DocumentScanner
//
//  Created by Tuan Hoang on 6/11/24.
//

import UIKit

class PhotosCollectionViewCell: UICollectionViewCell {
    static let identifier: String = "PhotosCollectionViewCell"
    var image: UIImage?
    
    let imageView: UIImageView = {
        let imageView = UIImageView()
        imageView.contentMode = .scaleAspectFill
        imageView.clipsToBounds = true
        return imageView
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        contentView.addSubview(imageView)
        
        if image != nil {
            imageView.image = image
        }
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        imageView.frame = bounds
    }
    
    override func prepareForReuse() {
        super.prepareForReuse()
        imageView.image = nil
    }
}
