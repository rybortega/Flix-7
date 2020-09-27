//
//  MovieGridViewController.swift
//  Flix
//
//  Created by Mina Kim on 9/26/20.
//

import UIKit
import AlamofireImage

class MovieGridViewController: UIViewController, UICollectionViewDataSource, UICollectionViewDelegate {
    
    @IBOutlet weak var collectionView: UICollectionView!
    
    var movies = [[String:Any]]()
    
    override func viewDidLoad() {
        super.viewDidLoad()

        collectionView.delegate = self
        collectionView.dataSource = self
        
        let layout = collectionView.collectionViewLayout as! UICollectionViewFlowLayout
        
        //Space betwwen "rows"
        layout.minimumLineSpacing = 4
        //Space between items in "rows"
        layout.minimumInteritemSpacing = 4
        
        //Width of phone / 3
        let width = (view.frame.size.width - layout.minimumInteritemSpacing * 2) * (1/3)
        //Size of each item in collection view
        layout.itemSize = CGSize(width: width, height: width * 3/2)
        
        // Initialize a UIRefreshControl
        let refreshControl = UIRefreshControl()
        refreshControl.addTarget(self, action: #selector(refreshControlAction(_:)), for: UIControl.Event.valueChanged)
        collectionView.insertSubview(refreshControl, at: 0)
        
        // Do any additional setup after loading the view.
        
        //Put in function?
        // Create the URLRequest 'request'
        retrieveAPI()
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        movies.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "MovieGridCell", for: indexPath) as! MovieGridCell
        
        let movie = movies[indexPath.item]
        
        //Movie poster
        let baseUrl = "https://image.tmdb.org/t/p/w185"
        let posterPath = movie["poster_path"] as! String
        let posterUrl = URL(string: baseUrl + posterPath)
        cell.posterImage.af_setImage(withURL: posterUrl!)
        
        return cell
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        let cell = sender as! MovieGridCell
        let indexPath = collectionView.indexPath(for: cell)!
        let movie = movies[indexPath.item]
        
        //Passes information to MovieDetailsViewController
        let movieGridDetailsViewController = segue.destination as! MovieGridDetailsViewController
        movieGridDetailsViewController.movie = movie
    }

    @objc private func refreshControlAction(_ refreshControl: UIRefreshControl){
        //Put in function?
        // Create the URLRequest 'request'
        retrieveAPI()
        refreshControl.endRefreshing()
    }
    
    //Networking
    func retrieveAPI(){
        // Wonder Woman id = 297762
        // Onward id = 508439
        // Antebellum id = 627290
        let url = URL(string: "https://api.themoviedb.org/3/movie/297762/similar?api_key=a07e22bc18f5cb106bfe4cc1f83ad8ed")!
        let request = URLRequest(url: url, cachePolicy: .reloadIgnoringLocalCacheData, timeoutInterval: 10)

        // Configure session so that completion handler is executed on main UI thread
        let session = URLSession(configuration: .default, delegate: nil, delegateQueue: OperationQueue.main)
        let task: URLSessionDataTask = session.dataTask(with: request) { (data: Data?, response: URLResponse?, error: Error?) in
            // This will run when the network request returns
            if let error = error {
               print(error.localizedDescription)
            } else if let data = data {
               let dataDictionary = try! JSONSerialization.jsonObject(with: data, options: []) as! [String: Any]
                
                //Use the new data to update the data source
                self.movies = dataDictionary["results"] as! [[String:Any]]
                
                print(self.movies)
                
                self.collectionView.reloadData()
            }
        }
        task.resume()
    }

}
