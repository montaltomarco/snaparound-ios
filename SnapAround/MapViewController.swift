//
//  MapViewController.swift
//  SnapAround
//
//  Created by Mehdi Kitane on 29/04/2015.
//  Copyright (c) 2015 Mehdi Kitane. All rights reserved.
//

import UIKit
import MapKit

class MapViewController: UIViewController, MKMapViewDelegate, CustomAnnotationViewDelegate {
    
    @IBOutlet weak var mapView: MKMapView!
    @IBOutlet weak var tabBarView: UIView!
    var posts : Posts!
    
    
    var locationHandler = LocationHandler()
    override func viewDidLoad() {
        super.viewDidLoad()
        mapView.delegate = self
        mapView.showsUserLocation = true
        
        locationHandler.startLocationTracker()

    }
    override func viewDidAppear(animated: Bool) {
        super.viewDidAppear(animated)
        NSNotificationCenter.defaultCenter().addObserver(self, selector: Selector("didReceiveNotification:"), name: "SnapRemoteNotification", object: nil)
    }
    
    override func viewDidLayoutSubviews() {
        if NSFoundationVersionNumber > NSFoundationVersionNumber_iOS_7_1 {
            tabBarView.backgroundColor = UIColor.clearColor()
            let bgToolbar = UIToolbar(frame: tabBarView.frame)
            bgToolbar.barStyle = .Default
            bgToolbar.layer.opacity = 0.8
            bgToolbar.clipsToBounds = true
            view.addSubview(bgToolbar)
            view.insertSubview(bgToolbar, belowSubview: tabBarView)
            
            let separator = CALayer()
            separator.frame = CGRectMake(0, tabBarView.frame.origin.y-0.5, tabBarView.frame.width, 0.5)
            separator.backgroundColor = UIColor(rgba: "#D4D4D4").CGColor
            
            view.layer.addSublayer(separator)
        }
    }
    
    override func preferredStatusBarStyle() -> UIStatusBarStyle {
        return UIStatusBarStyle.Default
    }
    
    
    //one request at a time
    var count = 0
    func fetchData(completion: (success: Bool) -> Void ) {
        if count != 0 {
            completion(success: false)
            return
        }
        
        count++
        let token = FBSDKAccessToken.currentAccessToken()
        if token != nil {
            UIApplication.sharedApplication().networkActivityIndicatorVisible = true
            APIPosts.getPosts(token.tokenString, lat: mapView.userLocation.location!.coordinate.latitude, lon: mapView.userLocation.location!.coordinate.longitude) { (posts, error) -> Void in
                UIApplication.sharedApplication().networkActivityIndicatorVisible = false
                self.count--
                if let posts = posts {
                    self.posts = posts
                    completion(success: true)
                } else {
                    completion(success: false)
                }
            }
        } else {
            count--
            completion(success: false)
        }
    }
    
    
    // MARK: MapView Delegate
    func mapView(mapView: MKMapView, didFailToLocateUserWithError error: NSError) {
        if CLLocationManager.authorizationStatus() == CLAuthorizationStatus.Denied {
            UIAlertView(title: NSLocalizedString("OOPS",comment:"oops"), message: NSLocalizedString("UNAUTHORIZED_LOCALIZATION",comment:"unauthorized localization"), delegate: nil, cancelButtonTitle: "Ok").show()
        }
    }
    
    func mapView(mapView: MKMapView, didUpdateUserLocation userLocation: MKUserLocation) {
        if userLocation.location == nil {
            return
        }
        
        snapLog("Did Update")
        NSUserDefaults.standardUserDefaults().setObject(userLocation.coordinate.latitude, forKey: "SnapLatitude")
        NSUserDefaults.standardUserDefaults().setObject(userLocation.coordinate.longitude, forKey: "SnapLongitude")
        fetchData { (success) -> Void in
            if success {
                mapView.removeAnnotations(mapView.annotations)
                
                dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), {
                    var annotations : [MKPointAnnotation] = []
                    
                    for (index,aggregate) in self.posts.hidden.enumerate() {
                        let annotation = MKPointAnnotation()
                        annotation.coordinate = CLLocationCoordinate2DMake(Double(aggregate.latitude), Double(aggregate.longitude))
                        annotation.title = String(aggregate.count)
                        annotation.accessibilityLabel = String(index)
                        
                        annotations.append(annotation)
                    }
                    
//                    for (index,post) in enumerate(self.posts.myPosts) {
//                        var annotation = MKPointAnnotation()
//                        annotation.coordinate = CLLocationCoordinate2DMake(Double(post.latitude), Double(post.longitude))
//                        annotation.title = String(index)
//                        annotation.accessibilityLabel = "mine"
//                        
//                        //annotations.append(annotation)
//                    }
                    
                    if self.posts.visible.count > 0 {
                        let _ = NSUserDefaults.standardUserDefaults().objectForKey("SnapLongitude")  as? Double
                        let _ = NSUserDefaults.standardUserDefaults().objectForKey("SnapLatitude")  as? Double
                        let annotation = MKPointAnnotation()
                        annotation.coordinate = CLLocationCoordinate2DMake(mapView.userLocation.location!.coordinate.latitude, mapView.userLocation.location!.coordinate.longitude)
                        annotation.title = String(self.posts.visible.count)
                        annotation.accessibilityLabel = "visible"
                        annotations.append(annotation)
                    }
                    
                    dispatch_async(dispatch_get_main_queue()) {
                        mapView.addAnnotations(annotations)
//                        mapView.showAnnotations(mapView.annotations, animated: false)
                        
                        if userLocation.title != "" {
                            userLocation.title = ""
                            //I don't want to be disturbed everytime I change my location
                            var region = MKCoordinateRegion()
                            var span = MKCoordinateSpan()
                            span.latitudeDelta = 0.006
                            span.longitudeDelta = 0.006
                            var location = CLLocationCoordinate2D()
                            location.latitude = userLocation.coordinate.latitude
                            location.longitude = userLocation.coordinate.longitude
                            region.span = span
                            region.center = location
                            mapView.setRegion(region, animated: true)
                        }
                    }
                })
            }
        }
    }
    
    func mapView(mapView: MKMapView, viewForAnnotation annotation: MKAnnotation) -> MKAnnotationView? {
        if annotation.isKindOfClass(MKUserLocation) {
            return nil
        }
        
        if !annotation.isKindOfClass(MKPointAnnotation) {
            return nil
        }
        
        let myAnnotation = annotation as! MKPointAnnotation
        var annotationView : MKAnnotationView?

        if myAnnotation.accessibilityLabel == "visible" {
            let reuseIdentifier = "LocationPinVisible"
            annotationView = mapView.dequeueReusableAnnotationViewWithIdentifier(reuseIdentifier) as? VisibleAnnotationView
            
            if annotationView == nil {
                annotationView = VisibleAnnotationView(annotation: annotation, reuseIdentifier: reuseIdentifier)
            }
            else {
                annotationView!.annotation = annotation
            }
            
            if let annotationView = annotationView as? VisibleAnnotationView {
                annotationView.delegate = self
                annotationView.updateAnnotation(posts.visible.count)
            }
        } else if myAnnotation.accessibilityLabel == "mine" {
            let reuseIdentifier = "MinePinVisible"
            annotationView = mapView.dequeueReusableAnnotationViewWithIdentifier(reuseIdentifier) as? MineAnnotationView
            
            if annotationView == nil {
                annotationView = MineAnnotationView(annotation: annotation, reuseIdentifier: reuseIdentifier)
            }
            else {
                annotationView!.annotation = annotation
            }
            if let annotationView = annotationView as? MineAnnotationView {
                annotationView.delegate = self
            }
        }
        else {
            let reuseIdentifier = "LocationPinHidden"
            annotationView = mapView.dequeueReusableAnnotationViewWithIdentifier(reuseIdentifier) as? HiddenAnnotationView
            
            if annotationView == nil {
                annotationView = HiddenAnnotationView(annotation: annotation, reuseIdentifier: reuseIdentifier)
            }
            else {
                annotationView!.annotation = annotation
            }
            
            if let annotationView = annotationView as? HiddenAnnotationView {
                if let accessibilityLabel = myAnnotation.accessibilityLabel {
                    let index = Int(accessibilityLabel)!
                    annotationView.updateAnnotation(posts.hidden[index])
                    annotationView.delegate = self
                }
            }
            
        }
        
        return annotationView
    }
 
//    var zPositionForAnnotationViews: CGFloat = 10000
//    func mapView(mapView: MKMapView!, didAddAnnotationViews views: [AnyObject]!) {
//        
//        // Set zPosition
//        for annotationView in views {
//            if let annotationView = annotationView as? MKAnnotationView {
//                if let annotation = annotationView.annotation as? MKPointAnnotation {
//                    if annotation.accessibilityLabel == "visible" {
//                        annotationView.layer.zPosition = 1000+zPositionForAnnotationViews
//                    }
//                    else {
//                        annotationView.layer.zPosition = ++zPositionForAnnotationViews
//                    }
//                }
//            }
//            
//        }
//        
//    }
//    
    func didTapAnnotation() {
        self.performSegueWithIdentifier("segue_collection", sender: "map")
    }
    
    
    
    
    
    @IBAction func clickedBackToMyPosition(sender: AnyObject) {
        //Mixpanel.sharedInstance().track("clicked back to my position")
        var region = MKCoordinateRegion()
        
        var location = CLLocationCoordinate2D()
        location.latitude = mapView.userLocation.coordinate.latitude
        location.longitude = mapView.userLocation.coordinate.longitude
        region.span = mapView.region.span
        region.center = location
        mapView.setRegion(region, animated: true)
    }
    override func viewDidDisappear(animated: Bool) {
        super.viewDidDisappear(animated)
        NSNotificationCenter.defaultCenter().removeObserver(self)
    }
    
    func didReceiveNotification(notification : NSNotification) {
        let userInfo = notification.userInfo
        
        if let userInfo = userInfo {
            let lat = userInfo["lat"] as? Double
            let lon = userInfo["lon"] as? Double
            
            if (self.isViewLoaded() && self.view.window != nil ) {
                var region = MKCoordinateRegion()
                var span = MKCoordinateSpan()
                span.latitudeDelta = 0.006
                span.longitudeDelta = 0.006
                var location = CLLocationCoordinate2D()
                location.latitude = lat!
                location.longitude = lon!
                region.span = span
                region.center = location
                mapView.setRegion(region, animated: true)
            }
        }
    }
    
    
        override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
            if segue.identifier == "segue_collection" {
                if let _ = sender as? String {
                    if let navigation = segue.destinationViewController as? UINavigationController {
                        if let destinationVC = navigation.topViewController as? CollectionTableViewController{
                            destinationVC.isCollectionView = false
                            destinationVC.collectionPosts = posts.visible
                            //Mixpanel.sharedInstance().track("opened around me")
                        }
                    }
                } else {
                    if let navigation = segue.destinationViewController as? UINavigationController {
                        if let destinationVC = navigation.topViewController as? CollectionTableViewController{
                            destinationVC.isCollectionView = true
                            //Mixpanel.sharedInstance().track("opened collection")
                        }
                    }
                }
            }
        }
    
}
