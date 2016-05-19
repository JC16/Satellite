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
    
    let baseURL = "https://api.nasa.gov/planetary/earth/imagery"
    

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        
        NASARequest("150.817765",latitude: "-34.528522",date: "2016-05-19")
        
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func NASARequest (longitude: String, latitude: String, date: String)
    {
        let urlComponents = NSURLComponents(string: baseURL)
        
        let longitudeQuery :NSURLQueryItem = NSURLQueryItem(name: "lon", value: longitude)
        
        let latitudeQuery: NSURLQueryItem = NSURLQueryItem(name: "lat", value: latitude)
        
        let dateQuery: NSURLQueryItem = NSURLQueryItem(name: "date", value: date)
        
        let cloudQuery: NSURLQueryItem = NSURLQueryItem(name: "cloud_score", value: "True")
        
        let apiKeyQuery: NSURLQueryItem = NSURLQueryItem(name: "api_Key", value: apiKey);
        
        urlComponents!.queryItems = [longitudeQuery,latitudeQuery,dateQuery,cloudQuery,apiKeyQuery]
        
        let url = urlComponents?.URL
        
        print(url)
        
        let session = NSURLSession.sharedSession()
        let request = NSMutableURLRequest(URL: url!)
        
        request.HTTPMethod = "GET"
        
        let task = session.dataTaskWithRequest(request,
            completionHandler: {(data, response, error) -> Void in
                if error != nil {
                print("Error trying to GET from NASA \(error)")
                }
                else if let d = data, let r = response as? NSHTTPURLResponse{
                    let result = NSString(data: d, encoding:NSASCIIStringEncoding)!
                    print("query result \(result)")
                if(r.statusCode == 200){
                do{
                    //print(response)
                    print("test")
                    //print("current order \(order)")
                let json = try NSJSONSerialization.JSONObjectWithData(d, options:NSJSONReadingOptions.AllowFragments )
                    //print("current order \(order)")
                guard let dict : NSDictionary = json as? NSDictionary else {
                    print("not a dictionary")
                    return
                }
                if let date = dict["date"] as? String, img = dict["url"] as? String{
                    
                //self.fetchImage(img, withDate: date, currentCount: order)
                    
                                                                
                }  else {
                        print("date and image not found in json string")
                    }
                } catch {
                        print("json error")
                        }
                }
            }
                                                
        })
        task.resume()
        
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
