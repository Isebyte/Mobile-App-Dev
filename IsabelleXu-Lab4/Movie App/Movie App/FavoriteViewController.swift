//
//  FavoriteViewController.swift
//  Movie Search App
//
//  Created by Isabelle Xu on 10/4/18.
//  Copyright © 2018 WashU. All rights reserved.
//

import UIKit

class FavoriteViewController: UIViewController, UITableViewDataSource, UITableViewDelegate {
    
    @IBOutlet weak var favoritesTable: UITableView!
    
    var favMovies:[Movie]! = []
    var favMovieId:[String]! = []
    
    let defaults = UserDefaults.standard
    
    private let activityView = UIActivityIndicatorView(activityIndicatorStyle: .whiteLarge)
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        favMovieId = defaults.stringArray(forKey: "favMovies") ?? [String]()
        self.favMovies.removeAll()
        loadFavMovies()
        
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // print ("favMovies count = " + String(favMovies.count))
        return favMovies.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        // fill table with cells
        let cell = UITableViewCell(style: .default, reuseIdentifier: "favMovieCell")
        cell.textLabel!.text = favMovies[indexPath.row].title
        return cell;
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        performSegue(withIdentifier: "FavoriteVC", sender: indexPath.row)
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if  segue.identifier == "FavoriteVC" {
            let detailsVC = segue.destination as? MovieDetailsViewController
            let index = sender as! Int
            let selectedPost = self.favMovies[index]
            detailsVC?.movie = selectedPost // send over movie
        }
    }

    func tableView(_ tableView: UITableView, editActionsForRowAt indexPath: IndexPath) -> [UITableViewRowAction]? {
        let delete = UITableViewRowAction(style: .destructive, title: "delete") { (action, indexPath) in
            // delete item on UI and in userDefaults
            self.favMovies.remove(at: indexPath.row)
            self.favMovieId.remove(at: indexPath.row)
            var favMovies = self.defaults.array(forKey: "favMovies") as! [String]
            favMovies.remove(at: indexPath.row)
            UserDefaults.standard.set(favMovies, forKey:"favMovies")
            tableView.deleteRows(at: [indexPath], with: .fade)
        }
        return [delete]
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        // retrieve user saved favorites movie title array from database
        favoritesTable.delegate = self
        favoritesTable.dataSource = self
        
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    // load and save every movie into favMovies array
    private func loadFavMovies() {
        // start loading in background
        // Set spinner over collection view
        self.view.addSubview(activityView)
        activityView.hidesWhenStopped = true
        activityView.center = self.favoritesTable.center
        activityView.startAnimating()
        DispatchQueue.global(qos: .userInitiated).async {
            for movieId in self.favMovieId {
                // search for every movie title and append movie to array
                let query = "https://api.themoviedb.org/3/movie/" + movieId + "?api_key=da6a802deae18b6cb48f6972a67fa9ed&language=en-US"
                self.getMovieJSON(url:query)
                
            }
            // render UI in main async
            DispatchQueue.main.async {
                self.favoritesTable.reloadData()
                
                // remove spinner from table upon finish load
                UIView.animate(withDuration: 1, delay: 1, usingSpringWithDamping: 1, initialSpringVelocity: 1, options: .curveEaseInOut, animations: {
                    self.favoritesTable?.alpha = 1
                    self.favoritesTable?.reloadData()
                    self.activityView.stopAnimating()
                }, completion: nil)
            }
        }
    }
    
    private func getMovieJSON(url: String) {
        // clear old info from arrays
        //Implementing URLSession to get raw JSON data from url
        guard let queryUrl = URL(string: url) else { return }
        let data = try? Data(contentsOf: queryUrl)
        if (data == nil) {
            return
        } else {
            // turn Json into a Movie object
            guard let movieResult = try? JSONDecoder().decode(Movie.self, from: data!) else {
                print("No results")
                return
            }
            self.favMovies.append(movieResult)
        }
    }
}



