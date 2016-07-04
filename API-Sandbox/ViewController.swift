//
//  ViewController.swift
//  API-Sandbox
//
//  Created by Dion Larson on 6/24/16.
//  Copyright © 2016 Make School. All rights reserved.
//

import UIKit
import SwiftyJSON
import Alamofire
import AlamofireImage
import AlamofireNetworkActivityIndicator

class ViewController: UIViewController {
    
    @IBOutlet weak var movieTitleLabel: UILabel!
    @IBOutlet weak var rightsOwnerLabel: UILabel!
    @IBOutlet weak var releaseDateLabel: UILabel!
    @IBOutlet weak var priceLabel: UILabel!
    @IBOutlet weak var posterImageView: UIImageView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
         // This code will call the iTunes top 25 movies endpoint listed above
        let apiToContact = "https://itunes.apple.com/us/rss/topmovies/limit=25/json"

        Alamofire.request(.GET, apiToContact).validate().responseJSON() { response in
            switch response.result {
            case .Success:
                if let value = response.result.value {
                    let moviesData = JSON(value)
                    
                    // Grab the array of JSON objects representing each movie
                    let allMoviesJSONData = moviesData["feed"]["entry"].arrayValue
                    
                    // Turn the allMoviesData array into Movie structs!
                    var allMovies: [Movie] = []
                    
                    for movieJSON in allMoviesJSONData  {
                        
                        allMovies.append(Movie(json: movieJSON))
                    }
     
                    //lets populate a movie
                    self.movieTitleLabel.text  = allMovies[0].name
                    self.rightsOwnerLabel.text = allMovies[0].rightsOwner
                    self.releaseDateLabel.text = allMovies[0].releaseDate
                    self.priceLabel.text =  String(allMovies[0].price)
                    
                    //load the image
                    if let imageLink = allMovies[0].imageLink {
                        self.loadPoster(imageLink)
                    }

                    

                }
        
            case .Failure(let error):
                print("pappu : \(error) ")
            }
        }
    
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    // Updates the image view when passed a url string
    func loadPoster(urlString: String) {
        posterImageView.af_setImageWithURL(NSURL(string: urlString)!)
    }
    
    @IBAction func viewOniTunesPressed(sender: AnyObject) {
        
        print (" inside viewOniTunesPressed ")
        UIApplication.sharedApplication().openURL(NSURL(string: "http://www.stackoverflow.com")!)
        
    }
    
}


