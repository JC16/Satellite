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
    
    //The api key
    let apiKey = "XG4dQXm9GW70ZMDNcCNFdak5ylRrIvIRbuJ2NRsk"
    
    //The base url to connect to NASA
    let baseURL = "https://api.nasa.gov/planetary/earth/imagery"
    
    var cloudScore = true
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        
        //Test the Request
        NASARequest("150.817765",latitude: "-34.528522",date: "2016-05-19")
        
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    //Create the NSURL Query Request
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
                
                //IF there is an error
                if error != nil {
                print("Error trying to GET from NASA \(error)")
                }
                //Print the query result from NASA
                else if let d = data, let r = response as? NSHTTPURLResponse{
                    let result = NSString(data: d, encoding:NSASCIIStringEncoding)!
                    print("query result \(result)")
                
                // If status is 200
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
                    
                        // self.DateLabel.text = date
                        self.fetchImage(img)
                    
                                                                
                    } else {
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

    
    func fetchImage(urlString: String)
    {
        if let url = NSURL(string: urlString){
            let session = NSURLSession.sharedSession()
            let task = session.dataTaskWithURL(url, completionHandler: {(data, response, error) in
                
                if error != nil {
                    print("error with image url")
                }
                else if let d = data {
                    print("loading image into the picture")
                    dispatch_async(dispatch_get_main_queue(), {
                        self.Image.image = UIImage(data: d)
                        self.Image.contentMode = UIViewContentMode.ScaleAspectFit
                    })
                    
                }
                
            })
            task.resume()
        }    }
    
    
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
