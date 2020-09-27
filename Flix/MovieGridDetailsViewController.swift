//
//  MovieGridDetailsViewController.swift
//  Flix
//
//  Created by Mina Kim on 9/26/20.
//

import UIKit
import AlamofireImage

class MovieGridDetailsViewController: UIViewController {

    @IBOutlet weak var backdropImage: UIImageView!
    @IBOutlet weak var posterImage: UIImageView!
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var detailLabel: UILabel!
    
    var movie : [String : Any]!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        print(movie["title"])
        
        titleLabel.text = movie["title"] as! String
        titleLabel.sizeToFit()
        detailLabel.text = movie["overview"] as! String
        detailLabel.sizeToFit()
        
        //Movie poster
        let baseUrl = "https://image.tmdb.org/t/p/w185"
        let posterPath = movie["poster_path"] as! String
        let posterUrl = URL(string: baseUrl + posterPath)
        posterImage.af_setImage(withURL: posterUrl!)
        
        
        //Backdrop image
        let backdropPath = movie["backdrop_path"] as! String
        let backdropUrl = URL(string: "https://image.tmdb.org/t/p/w780" + backdropPath)
        backdropImage.af_setImage(withURL: backdropUrl!)
        //backdropImage.frame.size = CGSize(width: view.frame.width, height: 240)
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
