//
//  FlixViewController.swift
//  flix
//
//  Created by Auster Chen on 9/14/17.
//  Copyright © 2017 Auster Chen. All rights reserved.
//

import UIKit
import AFNetworking
import VHUD

class FlixViewController: UIViewController,
    UITableViewDataSource,
UITableViewDelegate,
UISearchResultsUpdating {
    
    let refreshControl = UIRefreshControl()
    let searchController = UISearchController(searchResultsController: nil)
    var content = VHUDContent(.loop(3.0))

    var tableViewTopToLayoutGuideConstraint: NSLayoutConstraint?
    var tableViewTopToErrorViewConstraint: NSLayoutConstraint?
    var errorViewHeightConstraint: NSLayoutConstraint?
    var errorViewToTopLayoutGuideConstraint: NSLayoutConstraint?
    var movies: [Movie] = []
    var filteredMovies: [Movie] = []
    var searchText: String? = ""
    var endpoint: String = "now_playing"
    let errorView: UIView! = {
        let view = UIView()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.backgroundColor = UIColor.gray
        
        return view
    }()
    @IBOutlet weak var tableView: UITableView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.

        // Setting up loader
        content.loadingText =  "Loading..."
        content.shape = .circle
        content.background = .color(#colorLiteral(red: 0.937254902, green: 0.937254902, blue: 0.9568627451, alpha: 0.7))
        content.style = .light

        searchController.searchResultsUpdater = self
        searchController.dimsBackgroundDuringPresentation = false
        tableView.tableHeaderView = searchController.searchBar

        // Setting up pull to refresh
        refreshControl.layer.zPosition += 1
        refreshControl.backgroundColor = UIColor.groupTableViewBackground
        refreshControl.addTarget(self, action: #selector(refreshControlAction(_:)), for: UIControlEvents.valueChanged)
        tableView.insertSubview(refreshControl, at: 0)
        tableView.backgroundView?.layer.zPosition -= 1;

        let errorLabel = UILabel()
        errorLabel.text = "Could not fetch movies"
        errorView.addSubview(errorLabel)
        errorLabel.translatesAutoresizingMaskIntoConstraints = false
        errorLabel.leadingAnchor.constraint(equalTo: (errorLabel.superview?.leadingAnchor)!).isActive = true
        errorLabel.topAnchor.constraint(equalTo: (errorLabel.superview?.topAnchor)!).isActive = true
        errorLabel.bottomAnchor.constraint(equalTo: (errorLabel.superview?.bottomAnchor)!).isActive = true
        errorLabel.trailingAnchor.constraint(equalTo: (errorLabel.superview?.trailingAnchor)!).isActive = true
        errorLabel.textAlignment = NSTextAlignment.center
        view.addSubview(errorView)

        tableViewTopToErrorViewConstraint = tableView.topAnchor.constraint(equalTo: errorView.bottomAnchor)
        tableViewTopToLayoutGuideConstraint = tableView.topAnchor.constraint(equalTo: topLayoutGuide.bottomAnchor)
        errorViewHeightConstraint = errorView.heightAnchor.constraint(equalToConstant: 30.0)
        errorViewToTopLayoutGuideConstraint = errorView.topAnchor.constraint(equalTo: topLayoutGuide.bottomAnchor)
        errorView.leadingAnchor.constraint(equalTo: (errorView.superview?.leadingAnchor)!).isActive = true
        errorView.trailingAnchor.constraint(equalTo: (errorView.superview?.trailingAnchor)!).isActive = true

        // Initial movie fetch
        fetchMovies()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    func refreshControlAction(_ refreshControl: UIRefreshControl) {
        fetchMovies()
    }

    func fetchMovies() -> Void {
        VHUD.show(content)
        hideErrorMessage()
        Movie.fetchMovies(endpoint, successCallBack: {
            (movies: [Movie]) -> Void in
            self.movies = movies
            self.tableView.reloadData()
            self.refreshControl.endRefreshing()
            VHUD.dismiss(1.0)
        }, {
            error in
            self.tableView.reloadData()
            self.refreshControl.endRefreshing()
            VHUD.dismiss(1.0)
            self.showErrorMessage()
        })
    }

    func showErrorMessage() -> Void {
        errorView.isHidden = false
        tableViewTopToLayoutGuideConstraint?.isActive = false
        errorViewToTopLayoutGuideConstraint?.isActive = true
        tableViewTopToErrorViewConstraint?.isActive = true
        errorViewHeightConstraint?.isActive = true
    }

    func hideErrorMessage() -> Void {
        errorViewHeightConstraint?.isActive = false
        errorViewToTopLayoutGuideConstraint?.isActive = false
        tableViewTopToErrorViewConstraint?.isActive = false
        tableViewTopToLayoutGuideConstraint?.isActive = true
        errorView.isHidden = true
        view.layoutIfNeeded()
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return getMoviesToDisplay().count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let moviesListToUse = getMoviesToDisplay()
        let movieCell = tableView.dequeueReusableCell(withIdentifier: "MovieCell") as! MovieTableViewCell
        movieCell.updateCellContentWithMovie(movie: moviesListToUse[indexPath.row])
        return movieCell
    }

    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
    }

    func updateSearchResults(for: UISearchController) {
        searchText = searchController.searchBar.text
        tableView.reloadData()
    }

    func getMoviesToDisplay() -> [Movie] {
        let searchTextNSString = searchText! as NSString
        if searchTextNSString.length > 0{
            return movies.filter({
                (movie: Movie) in
                var isMatching = false

                if let title = movie.title {
                    isMatching = title.lowercased().range(of:searchText!.lowercased()) != nil
                }
                
                if (!isMatching) {
                    if let overview = movie.overview {
                        isMatching = overview.lowercased().range(of: searchText!.lowercased()) != nil
                    }
                }
                
                return isMatching
            })
        }

        return movies
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        let cell = sender as! UITableViewCell
        let indexPath = tableView.indexPath(for: cell)
        let movie = getMoviesToDisplay()[(indexPath?.row)!]
        searchController.dismiss(animated: true, completion: nil)

        let moviesDetailsViewController = segue.destination as! MovieDetailsViewController
        moviesDetailsViewController.movie = movie
    }
}
