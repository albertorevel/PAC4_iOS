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
