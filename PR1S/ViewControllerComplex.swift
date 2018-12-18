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
        
        // We calculate sizes and positions
        let screenRect = UIScreen.main.bounds

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
        
        self.view.addSubview(self.m_map!)
        
        self.AddMarkers()
        
        
        // We create the video player
        
        self.player = AVPlayer()
//        self.player = AVPlayer(url: NSURL(string: ("https://www.w3schools.com/html/mov_bbb.mp4"))! as URL)
        
        self.m_AVPlayerLayer = AVPlayerLayer(player: self.player)
        self.m_AVPlayerLayer?.frame = videoRect
        self.m_AVPlayerLayer?.videoGravity = AVLayerVideoGravityResizeAspectFill
        self.view.layer.addSublayer(self.m_AVPlayerLayer!)
//        self.player?.play()
        
        //self.player?.addObserver(self, forKeyPath: "status", options: NSKeyValueObservingOptions(rawValue: 0), context: nil)
//        NotificationCenter.default.addObserver(self, selector: #selector(ViewController.playerItemDidReachEnd), name: NSNotification.Name.AVPlayerItemDidPlayToEndTime, object: self.player.currentItem)
        
//        let urlString = "http://einfmlinux1.uoc.edu/devios/media/movie.mp4"
//        let urlURL = URL(string: urlString)
//
//        self.m_player.player = AVPlayer(url: urlURL)
//        self.m_player.player?.play()
        
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
        
        self.m_locationManager = CLLocationManager()

        
        self.m_locationManager?.delegate = self
        
        self.m_locationManager?.allowsBackgroundLocationUpdates = true
        
        self.m_locationManager?.distanceFilter = 500 // The minimum distance (measured in meters) a device must move horizontally before an update event is generated.
        
        self.m_locationManager?.desiredAccuracy = kCLLocationAccuracyBest // Determining a location with greater accuracy requires more time and more power.
        
        //  if you need the current location only within a kilometer, you should specify kCLLocationAccuracyKilometer
        //   requres less time and power.
        
        self.m_map?.delegate = self
        
        let status:CLAuthorizationStatus = CLLocationManager.authorizationStatus()
        
        if (status == CLAuthorizationStatus.notDetermined){
            self.m_locationManager?.requestWhenInUseAuthorization()
        }
        else{
            self.m_locationManager?.startUpdatingLocation()
//            self.startLocation()
            
        }
        
        // END-CODE-UOC-5
        
        
        // BEGIN-CODE-UOC-6
        
        // END-CODE-UOC-6
        
    }
    
    // BEGIN-CODE-UOC-8
    func Play(sender:UIButton)
    {
      NSLog("hey")
      
    }

    
    func Pause(sender:UIButton)
    {
     NSLog("hay")
    }
    // END-CODE-UOC-8
    
    func AddMarkers()
    {
    
    // BEGIN-CODE-UOC-3
    
        guard let data:Data = self.m_item?.m_data.data(using: String.Encoding.utf8) else {
            return
        }
        do {
            let pointsList: NSMutableArray = try JSONSerialization.jsonObject(with: data , options: JSONSerialization.ReadingOptions.mutableContainers) as! NSMutableArray
            
            for point in pointsList {
                
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
    
    // END-CODE-UOC-7
    
    
    
    
    // BEGIN-CODE-UOC-4
    
    func mapView(_ mapView: MKMapView, didUpdate userLocation: MKUserLocation) {
        
        let span = MKCoordinateSpan(latitudeDelta: 0.05, longitudeDelta: 0.05)
        
        let location = userLocation.coordinate
        
        let region = MKCoordinateRegion(center: location ,span: span)
        
        self.m_map?.setRegion(region,animated: true)
        
    }
    
    
    func mapView(_ mapView: MKMapView, viewFor annotation: MKAnnotation) -> MKAnnotationView?
    {
        
        if  let annotation = annotation as? MKMyPointAnnotation
        {
            
            let identifier = "CustomPinAnnotationView"
            var pinView: MKPinAnnotationView
            if let dequeuedView = self.m_map?.dequeueReusableAnnotationView(withIdentifier: identifier)
                as? MKPinAnnotationView {
                dequeuedView.annotation = annotation
                pinView = dequeuedView
            } else {
                
                pinView = MKPinAnnotationView(annotation: annotation, reuseIdentifier: identifier)
                pinView.canShowCallout = true
                
                pinView.calloutOffset = CGPoint(x: -5, y: 5)
                pinView.rightCalloutAccessoryView = UIButton(type:.detailDisclosure) as UIView
                
                ///
                let current_loc:CLLocation  = self.m_locationManager!.location!
                
                let obj_loc:CLLocation = CLLocation(latitude: annotation.coordinate.latitude,longitude: annotation.coordinate.longitude)
                
                let distance:CLLocationDistance = (current_loc.distance(from: obj_loc))
                
                let string1:String = "Distance:\(distance)"
                
                annotation.subtitle = string1
                
            }
            return pinView
            
        }
        
        return nil
    }
    
    func mapView(_ mapView: MKMapView, annotationView: MKAnnotationView, calloutAccessoryControlTapped control: UIControl) {
        
        let annotation:MKMyPointAnnotation = annotationView.annotation as! MKMyPointAnnotation
        
        let current_loc:CLLocation  = self.m_locationManager!.location!
        
        let obj_loc:CLLocation = CLLocation(latitude: annotation.coordinate.latitude,longitude: annotation.coordinate.longitude)
        
        let distance:CLLocationDistance = (current_loc.distance(from: obj_loc))
        
        let string1:String = "Distance:\(distance)"

        annotation.subtitle = string1
//        let alert = UIAlertController(title: "Alert", message: string1, preferredStyle: UIAlertControllerStyle.alert)
//        alert.addAction(UIAlertAction(title: "Ok", style: UIAlertActionStyle.default, handler: nil))
//        self.present(alert, animated: true, completion: nil)
        
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
