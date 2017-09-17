//
//  MovieDetailsViewController.swift
//  flix
//
//  Created by Auster Chen on 9/13/17.
//  Copyright © 2017 Auster Chen. All rights reserved.
//

import UIKit

class MovieDetailsViewController: UIViewController {

    @IBOutlet weak var backgroundImageView: UIImageView!
    
    @IBOutlet weak var detailsScrollingContentView: UIScrollView!
    var movie: Movie!
    var movieDetailsView: UIView!
    var movieDetailsViewHeight: CGFloat = CGFloat(0)
    let movieDetailsGutterSize: CGFloat = CGFloat(15)
    let titleLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont(name: label.font.fontName, size: 24.0)
        label.textColor = UIColor.white
        label.text = "Movie Title"
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    let overviewLabel: UILabel = {
        let label = UILabel()
        label.numberOfLines = 8
        label.font = UIFont(name: label.font.fontName, size: 14.0)
        label.textColor = UIColor.white
        label.text = "Movie Overview"
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()

    override func viewDidLoad() {
        super.viewDidLoad()

        movieDetailsViewHeight = detailsScrollingContentView.bounds.height / 3
        let contentWidth = detailsScrollingContentView.bounds.width
        let contentHeight = detailsScrollingContentView.bounds.height + (movieDetailsViewHeight * 0.5)
        detailsScrollingContentView.contentSize = CGSize(width: contentWidth, height: contentHeight)

        if let posterImageUrl = movie.getPosterImageUrl() {
            backgroundImageView.setImageWith(posterImageUrl)
        } else {
            backgroundImageView.image = nil
        }

        addMovieDetailsView()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    func addMovieDetailsView() -> Void {
        movieDetailsView = UIView(frame: CGRect(x: movieDetailsGutterSize, y: detailsScrollingContentView.contentSize.height - movieDetailsViewHeight * 1.5, width: detailsScrollingContentView.contentSize.width - movieDetailsGutterSize * 2, height: movieDetailsViewHeight))
        movieDetailsView.backgroundColor = UIColor(red: 0.0, green:0.0, blue: 0.0, alpha:0.7)
        detailsScrollingContentView.addSubview(movieDetailsView)
        addContentToMovieDetailsView()
    }

    func addContentToMovieDetailsView() -> Void {
        if let title =  movie.title {
            titleLabel.text = title
        }

        if let overview = movie.overview {
            overviewLabel.text = overview
        }
        
        movieDetailsView.addSubview(titleLabel)
        movieDetailsView.addSubview(overviewLabel)
        titleLabel.topAnchor.constraint(equalTo: (titleLabel.superview?.topAnchor)!, constant: 8).isActive = true
        titleLabel.leadingAnchor.constraint(equalTo: (titleLabel.superview?.leadingAnchor)!, constant: 8).isActive = true
        titleLabel.trailingAnchor.constraint(equalTo: (titleLabel.superview?.trailingAnchor)!, constant: -8).isActive = true
        overviewLabel.topAnchor.constraint(equalTo: titleLabel.bottomAnchor, constant: 20).isActive = true
        overviewLabel.leadingAnchor.constraint(equalTo: (overviewLabel.superview?.leadingAnchor)!, constant: 8).isActive = true
        overviewLabel.trailingAnchor.constraint(equalTo: (overviewLabel.superview?.trailingAnchor)!, constant: -8).isActive = true
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
