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
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var overviewLabel: UILabel!
    
    var movie: Movie!

    override func viewDidLoad() {
        super.viewDidLoad()

        if let posterImageUrl = movie.getPosterImageUrl() {
            backgroundImageView.setImageWith(posterImageUrl)
        } else {
            backgroundImageView.image = nil
        }

        if let title = movie.title {
            titleLabel.text = title
        }

        if let overview = movie.overview {
            overviewLabel.text = overview
        }
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
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
