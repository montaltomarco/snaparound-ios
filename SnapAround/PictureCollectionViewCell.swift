//
//  PictureCollectionViewCell.swift
//  TestPopUp
//
//  Created by Marco Montalto on 12/04/16.
//  Copyright © 2016 Marco Montalto. All rights reserved.
//

import UIKit

class PictureCollectionViewCell: UICollectionViewCell {
    
    @IBOutlet weak var picture: UIImageView!
    
    var post : Post!
    
    func updateCell(post: Post) {
        
        self.post = post

        let url = NSURLRequest(URL: NSURL(string: post.pic)!)
        
        self.picture.setImageWithURLRequest(url, placeholderImage: CollectionTableViewCell.placeholderImage, success:nil, failure: nil)
    }
}
