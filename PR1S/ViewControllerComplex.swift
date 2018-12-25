//
//  ViewControllerComplex.swift
//  PR4S
//
//  Created by Javier Salvador Calvo on 12/12/16.
//  Copyright © 2016 UOC. All rights reserved.
//

import UIKit
import Foundation
import MapKit

import AVFoundation
import AVKit

import MobileCoreServices

class ViewControllerComplex: UIViewController,MKMapViewDelegate,CLLocationManagerDelegate {

    var m_item:CItemData?
    var m_locationManager:CLLocationManager?
    var m_map:MKMapView?
    
    var player:AVPlayer?
    var m_AVPlayerLayer:AVPlayerLayer?
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Do any additional setup after loading the view.
        // BEGIN-CODE-UOC-2
        
        /* **** We calculate sizes and positions **** */
        
        
        // We get screen and statusBar size.
        var screenRect = UIScreen.main.bounds
        let barHeight = self.navigationController?.navigationBar.frame.height ?? 0
        
        screenRect.origin.y = screenRect.origin.y + barHeight
        screenRect.size.height = screenRect.size.height - barHeight
    
        // We set the frame sizes for the elements

        let buttonSize:CGFloat = 80
        let buttonMargin:CGFloat = 10
        
        let mapRect = CGRect(x: screenRect.origin.x, y: screenRect.origin.y,
                             width: screenRect.size.width , height: screenRect.size.height * 0.5)
        
        let videoRect = CGRect(x: screenRect.origin.x, y: mapRect.origin.y + mapRect.size.height,
                               width: screenRect.size.width,
                               height: screenRect.size.height - mapRect.size.height - buttonSize)
        
        let playRect = CGRect(x: screenRect.origin.x + buttonMargin,
                              y: (screenRect.origin.y + screenRect.size.height) - buttonSize,
                                 width: buttonSize, height: buttonSize)
        
        // We calculate pause button position depending on play button position
        let pauseRect = CGRect(x: playRect.origin.x + playRect.size.width + buttonMargin * 2,
                               y: playRect.origin.y,
                              width: buttonSize, height: buttonSize)
        
        // We set a black background
        self.view.backgroundColor = UIColor.black
        
        // We create the map and we add the given markers
        self.m_map = MKMapView()

        self.m_map?.delegate = self
        self.m_map?.frame = mapRect
        self.m_map?.mapType = MKMapType.standard
        self.m_map?.showsUserLocation = true
        
        self.view.addSubview(self.m_map!)
        
        self.AddMarkers()
        
        
        // We create the video player
        
        self.player = AVPlayer()
        
        self.m_AVPlayerLayer = AVPlayerLayer(player: self.player)
        self.m_AVPlayerLayer?.frame = videoRect
        self.m_AVPlayerLayer?.videoGravity = AVLayerVideoGravityResizeAspectFill
        self.view.layer.addSublayer(self.m_AVPlayerLayer!)
      
        // We create the tv frame
        let tvImageView = UIImageView(frame: videoRect)
        tvImageView.image = UIImage(named: "tv.png")
        self.view.addSubview(tvImageView)
        
        // We create play and pause buttons and we associate an action to them
        let playButton = UIButton(type: UIButtonType.custom)
        playButton.addTarget(self, action: #selector(Play), for: UIControlEvents.touchDown)
        playButton.frame = playRect
        playButton.setImage(UIImage(named: "play.png"), for: UIControlState.normal)
        
        let pauseButton = UIButton(type: UIButtonType.custom)
        pauseButton.addTarget(self, action: #selector(Pause), for: UIControlEvents.touchDown)
        pauseButton.frame = pauseRect
        pauseButton.setImage(UIImage(named: "pause.png"), for: UIControlState.normal)
        
        self.view.addSubview(playButton)
        self.view.addSubview(pauseButton)

        // END-CODE-UOC-2
        
        
        
        
        // BEGIN-CODE-UOC-5
        // We set the location manager and its properties
        self.m_locationManager = CLLocationManager()
        self.m_locationManager?.delegate = self
        self.m_locationManager?.allowsBackgroundLocationUpdates = false
        self.m_locationManager?.distanceFilter = 100
        self.m_locationManager?.desiredAccuracy = kCLLocationAccuracyBest
        
        // We check if we have the authorization to know user's location (If not, we ask him for it).
        let status:CLAuthorizationStatus = CLLocationManager.authorizationStatus()
        
        if (status == CLAuthorizationStatus.notDetermined){
            self.m_locationManager?.requestWhenInUseAuthorization()
        }
        else{
            self.m_locationManager?.startUpdatingLocation()
        }
        // END-CODE-UOC-5
        
        
        // BEGIN-CODE-UOC-6
        
        // We add an observer in order to perform an action when the player will be ready
        self.player?.addObserver(self, forKeyPath: "status", options: [.old, .new], context: nil)
        
        // END-CODE-UOC-6
        
    }
    
    // BEGIN-CODE-UOC-8
    
    // Method that will set the player in play state.
    func Play(sender:UIButton)
    {
      self.player?.play()
      
    }

    // Method that will set the player in pause state.
    func Pause(sender:UIButton)
    {
     self.player?.pause()
    }
    
    // END-CODE-UOC-8
    
    func AddMarkers()
    {
    
    // BEGIN-CODE-UOC-3
    
        // We check all the markers to add (stored in the item variable setted within the general Controller)
        guard let data:Data = self.m_item?.m_data.data(using: String.Encoding.utf8) else {
            return
        }
        do {
            let pointsList: NSMutableArray = try JSONSerialization.jsonObject(with: data , options: JSONSerialization.ReadingOptions.mutableContainers) as! NSMutableArray
            
            for point in pointsList {
                
                // We get all the attributes for the marker, we create an Annotation object and we add it to the map
                let title = (point as! NSMutableDictionary).value(forKey: "title") as! String
                let lat = (point as! NSMutableDictionary).value(forKey: "lat") as! Double
                let long = (point as! NSMutableDictionary).value(forKey: "lon") as! Double
                let movieURL = (point as! NSMutableDictionary).value(forKey: "movie") as! String
                
                let coordinate = CLLocationCoordinate2D(latitude: CLLocationDegrees(lat), longitude: CLLocationDegrees(long))
                let annotation = MKMyPointAnnotation(coordinate: coordinate, title: title, subtitle: "", movieURL: movieURL )
                
                self.m_map?.addAnnotation(annotation)
            }
        
        } catch {
            print("Unexpected error: \(error).")
        }
    
    // END-CODE-UOC-3
    
    }
    
    // BEGIN-CODE-UOC-7
    
    // This method will be called when there's a change in an observed value
    override func observeValue(forKeyPath: String?, of: Any?, change: [NSKeyValueChangeKey : Any]?, context: UnsafeMutableRawPointer?)
    {
        // We check if the key received is the same that the one that we are waiting
        if (forKeyPath == "status") {
            
                // If the player is ready, we start playing the loaded video
                if (self.player?.status == AVPlayerStatus.readyToPlay) {
                self.player?.play()
            }
        }
    }
    // END-CODE-UOC-7
    
    
    // BEGIN-CODE-UOC-4
    
    // This method will be called when the user's location changes
    func mapView(_ mapView: MKMapView, didUpdate userLocation: MKUserLocation) {
        
        // We set the showing region in the map with the user's new location in the center
        let span = MKCoordinateSpan(latitudeDelta: 0.05, longitudeDelta: 0.05)
        let location = userLocation.coordinate
        let region = MKCoordinateRegion(center: location ,span: span)
        self.m_map?.setRegion(region,animated: true)
    }
    
    // This method wil be called when an annotation is been added to the map, so we build the custom view for it.
    func mapView(_ mapView: MKMapView, viewFor annotation: MKAnnotation) -> MKAnnotationView?
    {

        if let annotation = annotation as? MKMyPointAnnotation
        {
            // We add the annotation and we set the detail button
            let identifier = "CustomPinAnnotationView"
            var pinView: MKPinAnnotationView
            if let dequeuedView = self.m_map?.dequeueReusableAnnotationView(withIdentifier: identifier)
                as? MKPinAnnotationView {
                dequeuedView.annotation = annotation
                pinView = dequeuedView
            }
            else {
                
                pinView = MKPinAnnotationView(annotation: annotation, reuseIdentifier: identifier)
                pinView.canShowCallout = true
                
                pinView.calloutOffset = CGPoint(x: -5, y: 5)
                pinView.rightCalloutAccessoryView = UIButton(type:.detailDisclosure) as UIView
            }
            return pinView
        }
        
        return nil
    }
    
    
    // This method will be called when an annotation is selected so we have to show it.
    func mapView(_ mapView: MKMapView, didSelect annotationView: MKAnnotationView) {
        
        guard let annotation:MKMyPointAnnotation = annotationView.annotation as? MKMyPointAnnotation else {
            return
        }
        
        guard let current_loc:CLLocation  = self.m_locationManager!.location else {
            return
        }
        
        // We calculate the current distance between the selected annotation and we set it as the annotation subtitle
            
        let obj_loc:CLLocation = CLLocation(latitude: annotation.coordinate.latitude,longitude: annotation.coordinate.longitude)
        let distance:CLLocationDistance = (current_loc.distance(from: obj_loc))
        let newSubtitle:String = String(format: "Distance: %.2f", distance)
        
        annotation.subtitle = newSubtitle
    
    }
    
    // This method is called when the button from an annotation is tapped.
    func mapView(_ mapView: MKMapView, annotationView: MKAnnotationView, calloutAccessoryControlTapped control: UIControl) {
        
        let annotation:MKMyPointAnnotation = annotationView.annotation as! MKMyPointAnnotation
        
        // We get the annotation's video URL and we set it as a new source in the player, launching it in a play state.
        if let url = URL(string: annotation.movieURL) {
            let playerItem = AVPlayerItem(url: url)
            self.player?.replaceCurrentItem(with: playerItem)
            
            self.player?.play()
        }
    }

    // END-CODE-UOC-4
    


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
