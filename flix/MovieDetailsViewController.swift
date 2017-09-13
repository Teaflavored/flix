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
    
    var movie: Movie!

    override func viewDidLoad() {
        super.viewDidLoad()

        if let posterImageUrl = movie.getPosterImageUrl() {
            backgroundImageView.setImageWith(posterImageUrl)
        } else {
            backgroundImageView.image = nil
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
