//
//  FlixViewController.swift
//  flix
//
//  Created by Auster Chen on 9/14/17.
//  Copyright © 2017 Auster Chen. All rights reserved.
//

import UIKit
import AFNetworking

class FlixViewController: UIViewController,
    UITableViewDataSource,
UITableViewDelegate {
    
    let refreshControl = UIRefreshControl()
    var movies: [Movie] = []
    @IBOutlet weak var tableView: UITableView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        refreshControl.addTarget(self, action: #selector(refreshControlAction(_:)), for: UIControlEvents.valueChanged)
        tableView.insertSubview(refreshControl, at: 0)
        Movie.fetchMovies(successCallBack: {
            (movies: [Movie]) -> Void in
            self.movies = movies
            self.tableView.reloadData()
        }, nil)
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    func refreshControlAction(_ refreshControl: UIRefreshControl) {
        Movie.fetchMovies(successCallBack: {
            (movies: [Movie]) -> Void in
            self.movies = movies
            self.tableView.reloadData()
            self.refreshControl.endRefreshing()
        }, nil)
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return movies.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let movieCell = tableView.dequeueReusableCell(withIdentifier: "MovieCell") as! MovieTableViewCell
        movieCell.updateCellContentWithMovie(movie: movies[indexPath.row])
        return movieCell
    }

    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        let cell = sender as! UITableViewCell
        let indexPath = tableView.indexPath(for: cell)
        let movie = movies[indexPath!.row]
        
        let moviesDetailsViewController = segue.destination as! MovieDetailsViewController
        moviesDetailsViewController.movie = movie
    }
}
