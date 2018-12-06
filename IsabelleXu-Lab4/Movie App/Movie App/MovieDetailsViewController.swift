//
//  MovieDetailsViewController.swift
//  Movie Search App
//
//  Created by Isabelle Xu on 10/12/18.
//  Copyright © 2018 WashU. All rights reserved.
//

import UIKit

class MovieDetailsViewController: UIViewController {
    

    @IBOutlet weak var moviePoster: UIImageView!
    @IBOutlet weak var release_Date: UILabel!
    @IBOutlet weak var vote_average: UILabel!
    @IBOutlet weak var vote_count: UILabel!
    @IBOutlet weak var overview: UILabel!
    @IBOutlet weak var favBtn: UIButton!
    
    var movie:Movie!
    var movieImage: UIImage!
    
    let defaults = UserDefaults.standard
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        getUIImage()
        favBtn.isEnabled = true
        favBtn.setTitle("Add to favorites", for: .normal)
        self.title = movie.title
        self.moviePoster.image = movieImage
        self.release_Date.text = "Release Date: " + movie.release_date
        self.vote_average.text = "Rating Average: " + String(movie.vote_average)
        self.vote_count.text = "Vote Count: " + String(movie.vote_count)
        self.overview.text = movie.overview
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func getUIImage() {
        if movie.poster_path == nil {
            self.movieImage = (UIImage(named: "poster-not-available.jpg")!)
        } else {
            let url = URL(string: "https://image.tmdb.org/t/p/w500" + movie.poster_path!)!
            let data = try? Data(contentsOf: url)
            if (data == nil) {
                self.movieImage = (UIImage(named: "poster-not-available.jpg")!)
            } else {
                self.movieImage = (UIImage(data: data!)!)
            }
        }
    }
    
    
    // add movie title to favorites w/ userDefaults
    @IBAction func addToFavorites(_ sender: UIButton) {
        var favorites = defaults.array(forKey: "favMovies") as? [String]
        if favorites == nil {
            print("favorites is nil")
            favorites = [String(movie.id)]
        } else {
            favorites!.append(String(movie.id))
        }
        defaults.set(favorites!, forKey:"favMovies")
        
        // disable button and change text
        favBtn.setTitle("Favorited", for: .normal)
        favBtn.isEnabled = false
       
    }
    
}
