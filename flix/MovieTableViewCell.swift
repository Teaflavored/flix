//
//  MovieTableViewCell.swift
//  flix
//
//  Created by Auster Chen on 9/13/17.
//  Copyright © 2017 Auster Chen. All rights reserved.
//

import UIKit

class MovieTableViewCell: UITableViewCell {

    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var overviewLabel: UILabel!
    @IBOutlet weak var posterView: UIImageView!

    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

    func updateCellContentWithMovie(movie: Movie) {
        if let title =  movie.title {
            titleLabel.text = title
        } else {
            titleLabel.text = "No Working Title"
        }

        if let overview = movie.overview {
            overviewLabel.text = overview
        } else {
            overviewLabel.text = "No Summary"
        }
        overviewLabel.sizeToFit()

        if let posterImageUrl = movie.getPosterImageUrl() {
            posterView.setImageWith(posterImageUrl)
        } else {
            posterView.image = nil
        }

    }
}
