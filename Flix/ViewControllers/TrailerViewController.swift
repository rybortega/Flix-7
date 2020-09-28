//
//  TrailerViewController.swift
//  Flix
//
//  Created by Mina Kim on 9/27/20.
//

import UIKit
import WebKit

class TrailerViewController: UIViewController, WKUIDelegate {

    var webView = WKWebView()
    
    var movie_id : Int!
    var videos = [[String : Any]]()
    
    //View?
    override func loadView() {
            let webConfiguration = WKWebViewConfiguration()
            webView = WKWebView(frame: .zero, configuration: webConfiguration)
            webView.uiDelegate = self
            view = webView
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        
        print(movie_id)
        
        // Do any additional setup after loading the view.
        let urlString = "https://api.themoviedb.org/3/movie/" + String(movie_id)+"/videos?api_key=a07e22bc18f5cb106bfe4cc1f83ad8ed"
        print(urlString)
        let url = URL(string: urlString)!
        let request = URLRequest(url: url, cachePolicy: .reloadIgnoringLocalCacheData, timeoutInterval: 10)
        let session = URLSession(configuration: .default, delegate: nil, delegateQueue: OperationQueue.main)
        let task = session.dataTask(with: request) { (data, response, error) in
           // This will run when the network request returns
           if let error = error {
              print(error.localizedDescription)
           } else if let data = data {
              let dataDictionary = try! JSONSerialization.jsonObject(with: data, options: []) as! [String: Any]
            
            self.videos = dataDictionary["results"] as! [[String:Any]]
            
            print(dataDictionary)
            
            //Retrieves key for video
            let video_key = self.videos.first?["key"] as! String
            print(video_key)
            
            //URL for video
            let urlString = "https://www.youtube.com/watch?v=" + video_key as! String
            let myURL = URL(string: urlString)
            let myRequest = URLRequest(url: myURL!)
            self.webView.load(myRequest)
           }
        }
        task.resume()
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}
