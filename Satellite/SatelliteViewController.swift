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
    
    var count: Int = 6
    var completeLoad: Bool  = false
    
    struct ImgInfo
    {
        var img : UIImage
        var url : NSURL
        var date : String
    }
    
    var ImageHistory = [ImgInfo?](count: 6, repeatedValue: nil)
    
    var ImgIndex: Int?
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        
        //Test the Request
        //NASARequest("150.817765",latitude: "-34.528522",date: "2016-05-19")
        NASARequestSequence(longitude!,latitude: latitude!)
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    //The NSAS request sequence for load image
    func NASARequestSequence(longitude: String, latitude: String)
    {
        //Get the current date and format it into YYYY-MM-dd formate
        let currentDate = NSDate()
        let dateFormat = NSDateFormatter()
        dateFormat.dateFormat = "YYYY-MM-dd"
        
        var dateStr = dateFormat.stringFromDate(currentDate)
        
        //Use the calender for add the day period
        let calendar = NSCalendar.currentCalendar()
        
        let periodComponents = NSDateComponents()
        
        var orderIndex = 5
        
        //Get 5 image request from the NASA
        for index in 0...5
        {
        
            periodComponents.month = -index
            //Change the date from 5 times
            let d = calendar.dateByAddingComponents(periodComponents, toDate: currentDate, options: [])
            
            if let date = d
            {
                dateStr = dateFormat.stringFromDate(date)
                
                //Run rhe query request for image
                NASARequest (longitude,latitude: latitude, date: dateStr, order: orderIndex)
                orderIndex--
            }
        }
        
        
    }
    
    
    //Create the NSURL Query Request
    func NASARequest (longitude: String, latitude: String, date: String, order: Int)
    {
        //The user to connect to NSAS
        let urlComponents = NSURLComponents(string: baseURL)
        
        
        //The query item used to get information
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
        
        
        //The HTTP request to get information
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
                    print("current order \(order)")
                    let json = try NSJSONSerialization.JSONObjectWithData(d, options:NSJSONReadingOptions.AllowFragments )
                    
                    guard let dict : NSDictionary = json as? NSDictionary else {
                        print("not a dictionary")
                        return
                    }
                    if let date = dict["date"] as? String, img = dict["url"] as? String{
                    
                        // self.DateLabel.text = date
                        self.fetchImage(img,date: date, count: order)
                    
                                                                
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

    //Fetch image from URL
    func fetchImage(urlString: String, date: String, count: Int)
    {
        if let url = NSURL(string: urlString){
            let session = NSURLSession.sharedSession()
            let task = session.dataTaskWithURL(url, completionHandler: {(data, response, error) in
                
                if error != nil {
                    print("error with image url")
                }
                else if let d = data {
                    print("loading image into the picture")
                    
                    //Create a image histroy array for store history image
                    dispatch_async(dispatch_get_main_queue(), {
                        
                        let currentImg = ImgInfo(img: UIImage(data: d)!, url: url, date: date)
                        
                        self.ImageHistory[count] = currentImg
                        
                        self.count--
                        
                        if self.count == 0 {
                            self.completeLoad = true
                         
                            //Set the time interval for switching the image
                            var timer = NSTimer.scheduledTimerWithTimeInterval(4, target: self, selector: Selector("displayImage"), userInfo: nil, repeats: true)
                            
                        }
                    })
                    
                }
                
            })
            task.resume()
        }
    }
    
    //The display image function
    func displayImage()
    {
        if ImgIndex == nil || ImgIndex == ImageHistory.count
        {
            ImgIndex = 0
        }
        
        //Set the date and image for view
        self.DateLabel.text = ImageHistory[ImgIndex!]!.date
        print(ImageHistory[ImgIndex!]?.date)
        self.Image.image = ImageHistory[ImgIndex!]!.img
        ImgIndex!++
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
