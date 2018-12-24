//
//  MKMyPointAnnotation.swift
//  PR4S
//
//  Created by Alberto Revel on 18/12/2018.
//  Copyright © 2018 UOC. All rights reserved.
//

import Foundation

import MapKit
import CoreLocation

class MKMyPointAnnotation: MKPointAnnotation {
    
//    var coordinate: CLLocationCoordinate2D
//    var title:String?
//    var subtitle:String?
    
//    override var subtitle: String? {
//        willSet { willChangeValue(forKey: "subtitle") }
//        didSet { didChangeValue(forKey: "subtitle") }
//    }
    
    var movieURL:String

    init(coordinate:CLLocationCoordinate2D, title:String, subtitle:String, movieURL:String)
    {
        self.movieURL = movieURL
        
        super.init()
        
        self.coordinate = coordinate
        self.title = title
        self.subtitle = subtitle
        
    }

}
