//
//  ViewController.swift
//  flix
//
//  Created by Auster Chen on 9/12/17.
//  Copyright © 2017 Auster Chen. All rights reserved.
//

import UIKit
import AFNetworking

class ViewController: UIViewController,
UITableViewDataSource,
UITableViewDelegate {

    var movies: [Movie] = []
    @IBOutlet weak var tableView: UITableView!

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        Movie.fetchMovies(successCallBack: {
            (movies: [Movie]) -> Void in
            self.movies = movies
            self.tableView.reloadData()
        }, errorCallBack: nil)
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return movies.count
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let movieCell = tableView.dequeueReusableCell(withIdentifier: "MovieCell") as! MovieTableViewCell
        movieCell.updateCellContentWithMovie(movie: movies[indexPath.row])
        return movieCell
    }

    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        let cell = sender as! UITableViewCell
        let indexPath = tableView.indexPath(for: cell)
        let movie = movies[indexPath!.row]

        let moviesDetailsViewController = segue.destination as! MovieDetailsViewController
        moviesDetailsViewController.movie = movie
    }
}
