//
//  FirstViewController.swift
//  Movie Search App
//
//  Created by Isabelle Xu on 10/4/18.
//  Copyright © 2018 WashU. All rights reserved.
//
// Creative Portion:
// 1. Implemented scrolling full length descriptions for each movie
// 2. Implemented movie sorting buttons
// 3. Additional API calls when scroll to bottom of UICollectionView

import UIKit

class MoviesViewController: UIViewController, UISearchBarDelegate, UICollectionViewDelegate, UICollectionViewDataSource{
    
    @IBOutlet weak var moviesCollectionView: UICollectionView!
    @IBOutlet weak var searchInput: UISearchBar!
    @IBOutlet weak var buttonsBar: UIStackView!
    
    // these two arrays must be of equal length!
    var movies:[Movie] = []
    var imageCache:[UIImage] = []
    var pageNum = 1;
    var currentQuery = "A"
    
    
    
    // Movie Sorting Functions (creative)
    @IBAction func AlphaSort(_ sender: UIButton) {
        // Set spinner over collection view
        let fadeView:UIView = UIView()
        fadeView.frame = self.moviesCollectionView.frame
        fadeView.backgroundColor = UIColor.white
        fadeView.alpha = 0.6
        
        self.view.addSubview(fadeView)
        
        self.view.addSubview(activityView)
        activityView.hidesWhenStopped = true
        activityView.center = self.moviesCollectionView.center
        activityView.startAnimating()
        
        // start loading in background
        DispatchQueue.global(qos: .userInitiated).async {
            if self.movies.count != 0 {
                self.movies.sort(by: { (first: Movie, second: Movie) -> Bool in
                    first.title < second.title
                })
                self.cacheImages()
            }
            // render UI in main async
            DispatchQueue.main.async {
                // print("Finished loading")
                self.moviesCollectionView.reloadData()
                
                // remove spinner from Collection view upon finish load
                UIView.animate(withDuration: 1, delay: 1, usingSpringWithDamping: 1, initialSpringVelocity: 1, options: .curveEaseInOut, animations: {
                    self.moviesCollectionView?.alpha = 1
                    self.moviesCollectionView?.reloadData()
                    fadeView.removeFromSuperview()
                    self.activityView.stopAnimating()
                }, completion: nil)
            }
        }
    }
    
    @IBAction func PopularitySort(_ sender: UIButton) {
        // Set spinner over collection view
        let fadeView:UIView = UIView()
        fadeView.frame = self.moviesCollectionView.frame
        fadeView.backgroundColor = UIColor.white
        fadeView.alpha = 0.6
        
        self.view.addSubview(fadeView)
        
        self.view.addSubview(activityView)
        activityView.hidesWhenStopped = true
        activityView.center = self.moviesCollectionView.center
        activityView.startAnimating()
        
        // start loading in background
        DispatchQueue.global(qos: .userInitiated).async {
            if self.movies.count != 0 {
                self.movies.sort(by: { (first: Movie, second: Movie) -> Bool in
                    first.vote_count > second.vote_count
                })
                self.cacheImages()
            }
            // render UI in main async
            DispatchQueue.main.async {
                // print("Finished loading")
                self.moviesCollectionView.reloadData()
                
                // remove spinner from Collection view upon finish load
                UIView.animate(withDuration: 1, delay: 1, usingSpringWithDamping: 1, initialSpringVelocity: 1, options: .curveEaseInOut, animations: {
                    self.moviesCollectionView?.alpha = 1
                    self.moviesCollectionView?.reloadData()
                    fadeView.removeFromSuperview()
                    self.activityView.stopAnimating()
                }, completion: nil)
            }
        }
    }
    
    @IBAction func RatingSort(_ sender: UIButton) {
        // Set spinner over collection view
        let fadeView:UIView = UIView()
        fadeView.frame = self.moviesCollectionView.frame
        fadeView.backgroundColor = UIColor.white
        fadeView.alpha = 0.6
        
        self.view.addSubview(fadeView)
        
        self.view.addSubview(activityView)
        activityView.hidesWhenStopped = true
        activityView.center = self.moviesCollectionView.center
        activityView.startAnimating()
        
        // start loading in background
        DispatchQueue.global(qos: .userInitiated).async {
            if self.movies.count != 0 {
                self.movies.sort(by: { (first: Movie, second: Movie) -> Bool in
                    first.vote_average > second.vote_average
                })
                self.cacheImages()
            }
            // render UI in main async
            DispatchQueue.main.async {
                // print("Finished loading")
                self.moviesCollectionView.reloadData()
                
                // remove spinner from Collection view upon finish load
                UIView.animate(withDuration: 1, delay: 1, usingSpringWithDamping: 1, initialSpringVelocity: 1, options: .curveEaseInOut, animations: {
                    self.moviesCollectionView?.alpha = 1
                    self.moviesCollectionView?.reloadData()
                    fadeView.removeFromSuperview()
                    self.activityView.stopAnimating()
                }, completion: nil)
            }
        }
    }
    
    
    private let activityView = UIActivityIndicatorView(activityIndicatorStyle: .whiteLarge)
    
    private let defaultUrl = "https://api.themoviedb.org/3/search/movie?api_key=da6a802deae18b6cb48f6972a67fa9ed&language=en-US&query=A&page=1&include_adult=false"

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        moviesCollectionView.dataSource = self
        moviesCollectionView.delegate = self
        searchInput.delegate = self
        
        loadMovies(url: defaultUrl, append:false)
        
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    // Spinner
    override func viewDidAppear(_ animated: Bool) {
        
        super.viewDidAppear(animated)
        
    }
    
    // if scrolled to bottom, load 20 more movies (creative)
    func collectionView(_ collectionView: UICollectionView, willDisplay cell: UICollectionViewCell, forItemAt indexPath: IndexPath) {
        if indexPath.row == movies.count - 1 {  //numberofitem count
            pageNum = pageNum + 1
            // Load more movies into array
            let url = "https://api.themoviedb.org/3/search/movie?api_key=da6a802deae18b6cb48f6972a67fa9ed&language=en-US&query="+currentQuery+"&page=" + String(pageNum) + "&include_adult=false"
            loadMovies(url: url, append:true)
        }
    }
    
    // Following UICollectionViewDelegate protocol
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 1
    }

    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return movies.count
    }

    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let myCell = collectionView.dequeueReusableCell(withReuseIdentifier: "MovieCell", for: indexPath) as! MovieCell
        //print("image Cache count: " + String(imageCache.count))
        //print("IndexPath: " + String(indexPath.row))
        myCell.backgroundView = UIImageView(image: imageCache[indexPath.row])
        myCell.title?.text = self.movies[indexPath.row].title
       
        return myCell
    }
    
    // Functions for collection cell clicks
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        performSegue(withIdentifier: "MovieDetailVC", sender: indexPath.row)
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if  segue.identifier == "MovieDetailVC" {
            let detailsVC = segue.destination as! MovieDetailsViewController
            let index = sender as! Int
            let selectedPost = self.movies[index]
            detailsVC.movie = selectedPost // send over movie
        }
    }
    
    // on search button clicked
    func searchBarSearchButtonClicked(_ searchInput: UISearchBar) {
        pageNum = 1; // reset upon new search
        var url = ""
        if (searchInput.text! != "") {
            // build query url
            currentQuery = searchInput.text!
            url = "https://api.themoviedb.org/3/search/movie?api_key=da6a802deae18b6cb48f6972a67fa9ed&language=en-US&query=" + currentQuery + "&page=1&include_adult=false"
        } else {
             url = "https://api.themoviedb.org/3/search/movie?api_key=da6a802deae18b6cb48f6972a67fa9ed&language=en-US&query=A&page=1&include_adult=false"
        }
        loadMovies(url: url, append:false)
        searchInput.resignFirstResponder() //hide keyboard
    }
    
    // search bar cancel button clicked
    func searchBarCancelButtonClicked(_ searchInput: UISearchBar) {
        searchInput.resignFirstResponder() //hide keyboard
    }
    
    private func loadMovies(url: String, append: Bool) {
        // Set spinner over collection view
        let fadeView:UIView = UIView()
        let union = self.moviesCollectionView.frame.union(self.buttonsBar.frame)
        fadeView.frame = union
        fadeView.backgroundColor = UIColor.white
        fadeView.alpha = 0.6
        
        self.view.addSubview(fadeView)
        
        self.view.addSubview(activityView)
        activityView.hidesWhenStopped = true
        activityView.center = self.moviesCollectionView.center
        activityView.startAnimating()

        // start loading in background
        DispatchQueue.global(qos: .userInitiated).async {
            self.getMovieJSON(url:url, append:append)
            
            // render UI in main async
            DispatchQueue.main.async {
                // print("Finished loading")
                self.cacheImages()
                self.moviesCollectionView.reloadData()
                
                // remove spinner from Collection view upon finish load
                UIView.animate(withDuration: 1, delay: 1, usingSpringWithDamping: 1, initialSpringVelocity: 1, options: .curveEaseInOut, animations: {
                    self.moviesCollectionView?.alpha = 1
                    self.moviesCollectionView?.reloadData()
                    fadeView.removeFromSuperview()
                    self.activityView.stopAnimating()
                }, completion: nil)
            }
        }
    }
    
    // function for caching Images so prevent heavy loading times from image retrieval
    private func cacheImages() {
        //print("caching Images")
        // print("Num Movies: " + String(movies.count))
        if imageCache.count != 0 {
            imageCache.removeAll()
        }
        
        for movie in movies {
            if movie.poster_path == nil {
                self.imageCache.append(UIImage(named: "poster-not-available.jpg")!)
            } else {
                let url = URL(string: "https://image.tmdb.org/t/p/w500" + movie.poster_path!)!
                // print("https://image.tmdb.org/t/p/w500" + movie.poster_path!)
                let data = try? Data(contentsOf: url)
                if (data == nil) {
                    self.imageCache.append(UIImage(named: "poster-not-available.jpg")!)
                } else {
                    self.imageCache.append(UIImage(data: data!)!)
                }
            }
        }
        //print("Finished caching")
    }
    

    // returns JSON data from query and fills movies array
    private func getMovieJSON(url: String, append: Bool) {
        //Implementing URLSession to get raw JSON data from url
        guard let queryUrl = URL(string: url) else { return }
        let data = try? Data(contentsOf: queryUrl)
        if (data == nil) {
            return
        } else {
            guard let movieResults = try? JSONDecoder().decode(APIResults.self, from: data!) else {
                //print("No results")
                return
            }
            if append == true {
                // merge two arrays
                self.movies.append(contentsOf: movieResults.results)
               
            } else {
                self.movies = movieResults.results
            }
            
        }
    }
    
}

