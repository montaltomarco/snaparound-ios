//
//  PicturesCollectionViewController.swift
//  Snaparound
//
//  Created by Marco Montalto on 12/04/16.
//  Copyright © 2016 Marco Montalto. All rights reserved.
//

import UIKit

class PicturesCollectionViewController: UIViewController, UICollectionViewDataSource, UICollectionViewDelegate {
    
    @IBOutlet weak var picsCollectionView: UICollectionView!
    @IBOutlet weak var picsNumberLabel: UILabel!
    @IBOutlet weak var picsNumberSubView: UIView!
    
    var collectionPosts : Array<Post>! = []
    var identifier = "pic"
    var collectionViewWidth: CGFloat = 0.0
    var pictureSize: CGFloat = 0.0
    var pictureIndexToFocusOn: Int = 0
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.picsCollectionView.allowsSelection = true
        self.picsCollectionView.userInteractionEnabled = true
        picsCollectionView.dataSource = self
        
        let gesture = UITapGestureRecognizer(target: self, action: #selector(PicturesCollectionViewController.closeView(_:)))
        self.picsNumberSubView.addGestureRecognizer(gesture)
    }
    
    override func viewDidLayoutSubviews() {
        
        setCollectionViewLayout()
        setNumberOfPicsLabelPosition()
    }
    
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
        
        self.picsNumberLabel.text = "\(self.collectionPosts.count)"
        self.picsCollectionView.reloadData()
    }
    
    func collectionView(collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return self.collectionPosts.count
    }
    
    func collectionView(collectionView: UICollectionView, cellForItemAtIndexPath indexPath: NSIndexPath) -> UICollectionViewCell {
        
        let cell = collectionView.dequeueReusableCellWithReuseIdentifier(identifier, forIndexPath: indexPath) as! PictureCollectionViewCell
        let post = self.collectionPosts[indexPath.row]
        
        cell.tag = indexPath.row
        
        let gesture = UITapGestureRecognizer(target: self, action: #selector(PicturesCollectionViewController.detailPicture(_:)))
        cell.addGestureRecognizer(gesture)
        
        cell.updateCell(post)
        
        return cell
    }
    
    func setCollectionViewLayout() {
        let collectionViewPadding: CGFloat = 6.0
        let paddingBetweenPics: CGFloat = 3.0
        
        let picturesPerRow: CGFloat = 3
        let spaceTookByPadding = (picturesPerRow-CGFloat(1.0))*paddingBetweenPics + collectionViewPadding*CGFloat(2.0)
        
        collectionViewWidth = picsCollectionView.collectionViewLayout.collectionViewContentSize().width
        pictureSize = (collectionViewWidth-spaceTookByPadding)/3
        
        let layout: UICollectionViewFlowLayout = UICollectionViewFlowLayout()
        layout.sectionInset = UIEdgeInsets(top: collectionViewPadding, left: collectionViewPadding, bottom: collectionViewPadding, right: collectionViewPadding)
        layout.itemSize = CGSize(width: pictureSize, height: pictureSize)
        layout.minimumInteritemSpacing = paddingBetweenPics
        layout.minimumLineSpacing = paddingBetweenPics
        
        picsCollectionView.collectionViewLayout = layout
    }
    
    func setNumberOfPicsLabelPosition() {
        // -- Placing label : number of pictures
        let xRightCollectionView = picsCollectionView.frame.origin.x+collectionViewWidth
        let yBottomCollectionView = picsCollectionView.frame.origin.y+picsCollectionView.bounds.size.height
        
        let labelSize: CGFloat = 50.0
        let offset: CGFloat = 8.0
        
        picsNumberSubView.frame.origin = CGPoint(x: xRightCollectionView-labelSize/2-offset, y: yBottomCollectionView-labelSize/2-offset)
    }
    
    func closeView(sender: UITapGestureRecognizer) {
        self.dismissViewControllerAnimated(true, completion: nil)
    }
    
    func detailPicture(sender: UITapGestureRecognizer) {
        let view = sender.view
        print(view!.tag)
        pictureIndexToFocusOn = view!.tag
        self.performSegueWithIdentifier("segue_detail_picture", sender: "collection")
    }
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        if segue.identifier == "segue_detail_picture" {
            if let navigation = segue.destinationViewController as? UINavigationController {
                if let destinationVC = navigation.topViewController as? CollectionTableViewController {
                    destinationVC.pictureIndexToFocusOn = self.pictureIndexToFocusOn
                    destinationVC.isCollectionView = false
                    destinationVC.collectionPosts = self.collectionPosts
                }
            }
        }
    }

}
