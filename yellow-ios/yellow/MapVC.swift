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

class MapVC: UIViewController {

    @IBOutlet weak var mapView: MKMapView!
    
    var firebaseAPI : FirebaseAPI!
    let feedViewModel = FeedViewModel()
    
    let manager = ClusterManager()
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        
        // When zoom level is quite close to the pins, disable clustering in order to show individual pins and allow the user to interact with them via callouts.
        manager.zoomLevel = 17
        
        manager.minimumCountForCluster = 3
        manager.shouldRemoveInvisibleAnnotations = true
        
        // Add annotations to the manager.
        let annotations: [Annotation] = (0..<1000).map { i in
            let annotation = Annotation()
            annotation.coordinate = CLLocationCoordinate2D(latitude: drand48() * 80 - 40, longitude: drand48() * 80 - 40)
            let color = UIColor(red: 255/255, green: 149/255, blue: 0/255, alpha: 1)
            //annotation.type = .color(color, radius: 25)
            // or
            annotation.type = .image(UIImage(named: "pin")?.filled(with: color)) // custom image
            
            return annotation
        }
        manager.add(annotations)
        mapView.centerCoordinate = CLLocationCoordinate2D(latitude: 0, longitude: 0)
        
        
        
        feedViewModel.delegate = self
        feedViewModel.initilization()
    
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

extension MapVC : FeedViewModelDelegate {
    func didFinishUpdate(indexPath: IndexPath, product: FeedContent) {

    }
    
    func didAppendData(indexPath: IndexPath) {
  
    }
    func didFinishLoadDataOnInitilization() {
     
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
            guard let annotation = annotation as? Annotation, let type = annotation.type else { return nil }
            let identifier = "Pin"
            var view = mapView.dequeueReusableAnnotationView(withIdentifier: identifier) as? MKPinAnnotationView
            if let view = view {
                view.annotation = annotation
            
            } else {
                view = MKPinAnnotationView(annotation: annotation, reuseIdentifier: identifier)
                
                let vv =  UIImageView()
                vv.frame = CGRect(x:0,y:0,width:20,height:40)
                vv.image = UIImage(named: "pin")?.filled(with: .green)
                view?.addSubview(vv)
            }
            
//            if #available(iOS 9.0, *), case let .color(color, _) = type {
//                view?.pinTintColor =  color
//            } else {
//                view?.pinColor = .green
//            }
            
           
            return view
        }
    }
    
    func mapView(_ mapView: MKMapView, regionDidChangeAnimated animated: Bool) {
        manager.reload(mapView, visibleMapRect: mapView.visibleMapRect)
    }
    
    func mapView(_ mapView: MKMapView, didSelect view: MKAnnotationView) {
        guard let annotation = view.annotation else { return }
        
        if let cluster = annotation as? ClusterAnnotation {
            var zoomRect = MKMapRectNull
            for annotation in cluster.annotations {
                let annotationPoint = MKMapPointForCoordinate(annotation.coordinate)
                let pointRect = MKMapRectMake(annotationPoint.x, annotationPoint.y, 0, 0)
                if MKMapRectIsNull(zoomRect) {
                    zoomRect = pointRect
                } else {
                    zoomRect = MKMapRectUnion(zoomRect, pointRect)
                }
            }
            mapView.setVisibleMapRect(zoomRect, animated: true)
        }
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
