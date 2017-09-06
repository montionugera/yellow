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
            annotation.type = .color(color, radius: 25)
            annotation.pinContent = pinContent
            // or
//            annotation.type = .image(UIImage(named: "pin")?.filled(with: color)) // custom image
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
            var view = mapView.dequeueReusableAnnotationView(withIdentifier: identifier) as? MKPinAnnotationView
            if let view = view {
                view.annotation = annotation
            
            } else {
                view = MKPinAnnotationView(annotation: annotation, reuseIdentifier: identifier)
//                let vv =  UIImageView()
//                vv.frame = CGRect(x:0,y:0,width:20,height:40)
//                vv.image = UIImage(named: "pin")?.filled(with: .green)
//                view?.addSubview(vv)
            }
        
        
            if #available(iOS 9.0, *), case let .color(color, _) = type {
                view?.pinTintColor =  color
            } else {
                view?.pinColor = .green
            }

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
            if let ppContent = (annotation as! CustomAnnotation).pinContent , annotation .isKind(of: CustomAnnotation.self){
                feedContents.append(ppContent)
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
            countLabel.text = "\(count)"
            
            backgroundColor = .clear
            self.image = image
            
            layer.borderWidth = 0
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
