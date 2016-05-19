//
//  SatelliteViewController.swift
//  Satellite
//
//  Created by Chen Jonathan on 5/19/16.
//  Copyright © 2016 Chen Yi Tai. All rights reserved.
//

import UIKit

class SatelliteViewController: UIViewController {
    
    
    @IBOutlet weak var Image: UIImageView!
    
    @IBOutlet weak var DateLabel: UILabel!
    
    var longitude: String?
    var latitude: String?
    
    let apiKey = "XG4dQXm9GW70ZMDNcCNFdak5ylRrIvIRbuJ2NRsk"
    
    let baseURL = " https://api.nasa.gov/planetary/earth/imagery/"
    

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
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
