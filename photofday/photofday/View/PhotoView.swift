//
//  PhotoView.swift
//  photofday
//
//  Created by Siddharth on 02/03/23.
//

import Foundation
import UIKit

class PhotoView: UIView {
    
    @IBOutlet var title: UILabel!
    @IBOutlet var subTitle: UILabel!
    @IBOutlet var imageView: UIImageView!
    
    override init(frame: CGRect) {
        self.imageView = UIImageView()
        super.init(frame: frame)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func update(title: String, description: String, image: UIImage) {
        self.title?.text = title
        self.subTitle?.text = description
        self.imageView.image = image
    }
}

