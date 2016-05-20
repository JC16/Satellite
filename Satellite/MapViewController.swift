//
//  MapViewController.swift
//  Satellite
//
//  Created by Chen Jonathan on 5/20/16.
//  Copyright © 2016 Chen Yi Tai. All rights reserved.
//

import UIKit
import MapKit

class MapViewController: UIViewController, MKMapViewDelegate {

  
    @IBOutlet weak var mapView: MKMapView!
    
    @IBOutlet weak var ViewLocationBtn: UIButton!
    
    var latitude : Double?
    var longtitude : Double?
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.mapView.delegate = self
        
        let press = UILongPressGestureRecognizer(target: self, action: "longPress:")
        press.minimumPressDuration = 1.5
        mapView.addGestureRecognizer(press)
        
        ViewLocationBtn.alpha = 0

        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func longPress(gestureRec: UIGestureRecognizer)
    {
        if gestureRec.state == UIGestureRecognizerState.Began
        {
            if mapView.annotations.count != 0
            {
                mapView.removeAnnotations(mapView.annotations)
            }
            
            let touchPoint = gestureRec.locationInView(mapView)
            let Coordinates = mapView.convertPoint(touchPoint, toCoordinateFromView: mapView)
            let annotation = MKPointAnnotation()
            latitude = Coordinates.latitude
            longtitude = Coordinates.longitude
            
            annotation.coordinate = Coordinates
            mapView.addAnnotation(annotation)
            
            print(latitude)
            print(longtitude)
            
            ViewLocationBtn.alpha = 1
        }
    }
    
    override func shouldPerformSegueWithIdentifier(identifier: String, sender: AnyObject?) -> Bool {
        if identifier == "Details" {
            if let long = longtitude, lat = latitude {
                return true
            }
        }
        return false
    }
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        if segue.identifier == "Details" {
            print("long and lat exist")
          
            let vC = segue.destinationViewController as! SatelliteViewController
            vC.longitude = String(format:"%f", longtitude!)
            vC.latitude = String(format:"%f", latitude!)
        }
    }
    
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
