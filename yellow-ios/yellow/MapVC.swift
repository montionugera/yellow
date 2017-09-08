//
//  MapVC.swift
//  yellow
//
//  Created by montionugera on 8/17/17.
//  Copyright © 2017 23. All rights reserved.
//

import UIKit
import MapKit
import Cluster
import Pulley
import FirebaseDatabase
import CoreLocation

class MapVC: UIViewController {

    @IBOutlet weak var mapView: MKMapView!
    
    var firebaseAPI : FirebaseAPI!
    let feedViewModel = FeedViewModel()
    
    let manager = ClusterManager()
    let locationManager: CLLocationManager = CLLocationManager()
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        
        // When zoom level is quite close to the pins, disable clustering in order to show individual pins and allow the user to interact with them via callouts.
        manager.zoomLevel = 20
        manager.minimumCountForCluster = 3
        manager.shouldRemoveInvisibleAnnotations = true
        
        mapView.showsUserLocation = true
        mapView.showsCompass = false
        mapView.delegate = self

//        let pinchRecognizer = UIPinchGestureRecognizer(target: self, action: #selector(scale))
//        pinchRecognizer.delegate = self
//        mapView.addGestureRecognizer(pinchRecognizer)
        
        if (CLLocationManager.locationServicesEnabled()) {
            self.locationManager.requestAlwaysAuthorization()
            self.locationManager.desiredAccuracy = kCLLocationAccuracyBest
            self.locationManager.distanceFilter = 50.0
            self.locationManager.delegate = self
            self.locationManager.startMonitoringSignificantLocationChanges()
            self.locationManager.startUpdatingLocation()
            addMapTrackingButton()
        }
        
        feedViewModel.delegate = self
        feedViewModel.initilization()
    
    }

    func addMapTrackingButton(){
        let image = UIImage(named: "btReCenter") as UIImage?
        let button   = UIButton(type: UIButtonType.custom) as UIButton
        button.frame = CGRect(x: UIScreen.main.bounds.width - 55, y: 25, width: 44, height: 47)
        button.setImage(image, for: .normal)
        button.backgroundColor = UIColor.clear
        button.addTarget(self, action: #selector(MapVC.centerMapOnUserButtonClicked), for: .touchUpInside)
        self.mapView.addSubview(button)
    }
    func centerMapOnUserButtonClicked() {
        self.mapView.setUserTrackingMode( MKUserTrackingMode.follow, animated: true)
    }

    override func viewDidAppear(_ animated: Bool){
        super.viewDidAppear(animated)
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */
    
}

extension MapVC : UIGestureRecognizerDelegate {
    func scale(_ gesture: UIPinchGestureRecognizer) {
        if (gesture.state != .changed) {
            return;
        }
        
        let aMapView = gesture.view as! MKMapView;
        
//        for annotation in aMapView.annotations {
//            if(annotation .isKind(of: MKUserLocation)){
//                return
//            }
//        }
//        
//        for (id <MKAnnotation>annotation in aMapView.annotations) {
//            // if it's the user location, just return nil.
//            if ([annotation isKindOfClass:[MKUserLocation class]])
//            return;
//            
//            // handle our custom annotations
//            //
//            if ([annotation isKindOfClass:[MKPointAnnotation class]])
//            {
//                // try to retrieve an existing pin view first
//                MKAnnotationView *pinView = [aMapView viewForAnnotation:annotation];
//                //Format the pin view
//                [self formatAnnotationView:pinView forMapView:aMapView];
//            }
//        }
        
//        - (void)formatAnnotationView:(MKAnnotationView *)pinView forMapView:(MKMapView *)aMapView {
//            if (pinView)
//            {
//                double zoomLevel = [aMapView zoomLevel];
//                double scale = -1 * sqrt((double)(1 - pow((zoomLevel/20.0), 2.0))) + 1.1; // This is a circular scale function where at zoom level 0 scale is 0.1 and at zoom level 20 scale is 1.1
//                
//                // Option #1
//                pinView.transform = CGAffineTransformMakeScale(scale, scale);
//                
//                // Option #2
//                UIImage *pinImage = [UIImage imageNamed:@"YOUR_IMAGE_NAME_HERE"];
//                pinView.image = [pinImage resizedImage:CGSizeMake(pinImage.size.width * scale, pinImage.size.height * scale) interpolationQuality:kCGInterpolationHigh];
//            }
//        }
    }
    
    func gestureRecognizer(_ gestureRecognizer: UIGestureRecognizer, shouldRecognizeSimultaneouslyWith otherGestureRecognizer: UIGestureRecognizer) -> Bool {
        return true
    }
    
}

extension MapVC : CLLocationManagerDelegate {
    func locationManager(_ manager: CLLocationManager, didFailWithError error: Error) {
        print("[\(type(of: self))] Error: \(error.localizedDescription)\n")
    }
    
    
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        let userLocation = locations.last!
        
        let span = MKCoordinateSpanMake(0.75, 0.75)
        let viewRegion = MKCoordinateRegion(center: CLLocationCoordinate2D(latitude: userLocation.coordinate.latitude, longitude: userLocation.coordinate.longitude), span: span)
        mapView.setRegion(viewRegion, animated: true)
        
    }
}

extension MapVC : FeedViewModelDelegate {
    func didFinishUpdate(indexPath: IndexPath, product: FeedContent) {

    }
    
    func didAppendData(indexPath: IndexPath) {
  
        if let pinContent = self.feedViewModel.feedContents[indexPath.row] as? FeedContent , self.feedViewModel.feedContents.count > 0{
            
            let dd = CLLocationCoordinate2D(geohash: pinContent.lochash)
            //var feedContents : [FeedContent] = [FeedContent]()
            
            //            pinContent.
            let annotation = CustomAnnotation()
            annotation.coordinate = CLLocationCoordinate2DMake(dd.latitude, dd.longitude)
            let color = UIColor(red: 255/255, green: 149/255, blue: 0/255, alpha: 1)
            annotation.type = .color(color, radius: 25)
            annotation.pinContent = pinContent
            // or
            //            annotation.type = .image(UIImage(named: "pin")?.filled(with: color)) // custom image

            self.manager.add(annotation)
        }
        
    }
    func didFinishLoadDataOnInitilization() {
       
        
        // Add annotations to the manager.
//        let annotations: [Annotation] = (0..<1000).map { i in
//            let annotation = Annotation()
//            annotation.coordinate = CLLocationCoordinate2D(latitude: drand48() * 80 - 40, longitude: drand48() * 80 - 40)
//            let color = UIColor(red: 255/255, green: 149/255, blue: 0/255, alpha: 1)
//            //annotation.type = .color(color, radius: 25)
//            // or
//            annotation.type = .image(UIImage(named: "pin")?.filled(with: color)) // custom image
//
//            return annotation
//        }
//        self.manager.add(annotations)
        
        var annotations:[CustomAnnotation] = [CustomAnnotation]()
        for pinContent in self.feedViewModel.feedContents {
            
            let dd = CLLocationCoordinate2D(geohash: pinContent.lochash)
//            print(dd.latitude)
//            print(dd.longitude)
            //        if let l = CLLocationCoordinate2D(geohash: "u4pruydqqvj") {
            //            print(l)
            //            // l.latitude == 57.64911063015461
            //            // l.longitude == 10.407439693808556
            //        }

            
            //var feedContents : [FeedContent] = [FeedContent]()
            
//            pinContent.
            let annotation = CustomAnnotation()
            annotation.title = pinContent.postDesc
            annotation.coordinate = CLLocationCoordinate2DMake(dd.latitude, dd.longitude)
            let color = UIColor(red: 255/255, green: 149/255, blue: 0/255, alpha: 1)
//            annotation.type = .color(color, radius: 25)
            annotation.pinContent = pinContent
            // or
            annotation.type = .image(UIImage(named: "pinOrange")) //?.filled(with: color)) // custom image
            annotations.append(annotation)
        }
        
        self.manager.add(annotations)
       // self.mapView.centerCoordinate = CLLocationCoordinate2D(latitude: 13.7426883 , longitude:100.5614013)
        

    }
    func didRemoveData(indexPath: IndexPath) {
      
    }
}

extension MapVC: MKMapViewDelegate {
    
    func mapView(_ mapView: MKMapView, viewFor annotation: MKAnnotation) -> MKAnnotationView? {
        if let annotation = annotation as? ClusterAnnotation {
            guard let type = annotation.type else { return nil }
            let identifier = "Cluster"
            var view = mapView.dequeueReusableAnnotationView(withIdentifier: identifier)
            if let view = view as? BorderedClusterAnnotationView {
                view.annotation = annotation
                view.configure(with: type)
            } else {
                view = BorderedClusterAnnotationView(annotation: annotation, reuseIdentifier: identifier, type: type, borderColor: .white)
            }
            return view
        } else {
            guard let annotation = annotation as? CustomAnnotation, let type = annotation.type else { return nil }
            let identifier = "Pin"
            var view = mapView.dequeueReusableAnnotationView(withIdentifier: identifier)
            if let view = view {
                view.annotation = annotation
            
            } else {
                view = MKAnnotationView(annotation: annotation, reuseIdentifier: identifier)
            }
        
            view?.image =  UIImage(named: "pinGreen")
            return view
        }
    }
    
    func mapView(_ mapView: MKMapView, regionDidChangeAnimated animated: Bool) {
        manager.reload(mapView, visibleMapRect: mapView.visibleMapRect)
    }
    func mapView(_ mapView: MKMapView, didSelect view: MKAnnotationView) {
        guard let annotation = view.annotation else { return }
        
        var feedContents : [FeedContent] = [FeedContent]()
        
        if let cluster = annotation as? ClusterAnnotation {
            var zoomRect = MKMapRectNull
                
            for annotation in cluster.annotations {
                let ppContent = (annotation as! CustomAnnotation).pinContent
//                let annotationPoint = MKMapPointForCoordinate(annotation.coordinate)
//                let pointRect = MKMapRectMake(annotationPoint.x, annotationPoint.y, 0, 0)
//                if MKMapRectIsNull(zoomRect) {
//                    zoomRect = pointRect
//                } else {
//                    zoomRect = MKMapRectUnion(zoomRect, pointRect)
//                }
                feedContents.append(ppContent!)
                
            }
//            mapView.setVisibleMapRect(zoomRect, animated: true)
            print(">>> : " , cluster.annotations.count)
        }else{
            if(annotation.isKind(of: CustomAnnotation.self)){
                if let ppContent = (annotation as! CustomAnnotation).pinContent {
                    feedContents.append(ppContent)
                }
            }
        }
        
        let feedDataDict:[String: [FeedContent]] = ["FeedContents": feedContents]
        // post a notification
        NotificationCenter.default.post(name: NSNotification.Name(rawValue: "updateFeedList"), object: nil, userInfo: feedDataDict)
        
    }
    
    func mapView(_ mapView: MKMapView, didAdd views: [MKAnnotationView]) {
        views.forEach { $0.alpha = 0 }
        UIView.animate(withDuration: 0.35, delay: 0, usingSpringWithDamping: 1, initialSpringVelocity: 0, options: [], animations: {
            views.forEach { $0.alpha = 1 }
        }, completion: nil)
    }
    
}

class BorderedClusterAnnotationView: ClusterAnnotationView {
    let borderColor: UIColor
    
    init(annotation: MKAnnotation?, reuseIdentifier: String?, type: ClusterAnnotationType, borderColor: UIColor) {
        self.borderColor = borderColor
        super.init(annotation: annotation, reuseIdentifier: reuseIdentifier, type: type)
    }
    
    required public init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func configure(with type: ClusterAnnotationType) {
//        super.configure(with: type)
        
        guard let annotation = annotation as? ClusterAnnotation else { return }
        
        switch type {
        case let .image(image):
            let count = annotation.annotations.count
//            self.countLabel.text = "\(count)"
//            self.countLabel.textColor = UIColor.black
            
            backgroundColor = .clear
            self.image = image
            
            layer.borderWidth = 0
            
            createBadge(cc: count)
            
        case let .color(color, radius):
            let count = annotation.annotations.count
            backgroundColor	= color
            var diameter = radius * 2
            switch count {
            case _ where count < 8:
                diameter *= 0.6
            case _ where count < 16:
                diameter *= 0.8
            default: break
            }
            frame = CGRect(origin: frame.origin, size: CGSize(width: diameter, height: diameter))
            countLabel.text = "\(count)"
            
            layer.borderColor = borderColor.cgColor
            layer.borderWidth = 2
        }
    }
    
    private func createBadge(cc : Int) {
        if let bb = self.viewWithTag(12345) as? BadgeSwift {
            bb.removeFromSuperview()
            print("removeBagd")
        }
    
        let badge = BadgeSwift()
        badge.tag = 12345
        self.addSubview(badge)
        
        //configureBadge
        // Text
        badge.text = "\(cc)"
        
        // Insets
        badge.insets = CGSize(width: 0, height: 0)
        
        // Font
        badge.font = UIFont(name: thaiSansNeueUltraBold, size: fontSizeMedium)!
        
        // Text color
        badge.textColor = UIColor.black
        
        // Badge color
        badge.badgeColor = colorSunYellow
        
        // Shadow
        badge.shadowOpacityBadge = 0.5
        badge.shadowOffsetBadge = CGSize(width: 0, height: 0)
        badge.shadowRadiusBadge = 1.0
        badge.shadowColorBadge = UIColor.black
        
        // No shadow
        badge.shadowOpacityBadge = 0
        
        // Border width and color
        badge.borderWidth = 0
        badge.borderColor = UIColor.magenta
        
        //positionBadge
        badge.translatesAutoresizingMaskIntoConstraints = false
        var constraints = [NSLayoutConstraint]()
        
        // Center the badge vertically in its container
        constraints.append(NSLayoutConstraint(
            item: badge,
            attribute: NSLayoutAttribute.centerY,
            relatedBy: NSLayoutRelation.equal,
            toItem: self,
            attribute: NSLayoutAttribute.top,
            multiplier: 1, constant: 0)
        )
        
        // Center the badge horizontally in its container
        constraints.append(NSLayoutConstraint(
            item: badge,
            attribute: NSLayoutAttribute.centerX,
            relatedBy: NSLayoutRelation.equal,
            toItem: self,
            attribute: NSLayoutAttribute.centerX,
            multiplier: 1, constant: 0)
        )
        
        self.addConstraints(constraints)
    }
  
    
}

extension MapVC: PulleyPrimaryContentControllerDelegate {
    
    func makeUIAdjustmentsForFullscreen(progress: CGFloat)
    {
       // controlsContainer.alpha = 1.0 - progress
    }
    
    func drawerChangedDistanceFromBottom(drawer: PulleyViewController, distance: CGFloat)
    {
        if distance <= 268.0
        {
            //temperatureLabelBottomConstraint.constant = distance + temperatureLabelBottomDistance
        }
        else
        {
           // temperatureLabelBottomConstraint.constant = 268.0 + temperatureLabelBottomDistance
        }
    }
}
