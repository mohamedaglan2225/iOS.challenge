//
//  UpcomingMoviesCell.swift
//  iOS.challenge
//
//  Created by Mohamed Aglan on 18/10/2024.
//

import UIKit

class UpcomingMoviesCell: UITableViewCell {
    
    //MARK: - IBOutLets -
    @IBOutlet weak var posterImage: UIImageView!
    @IBOutlet weak var movieNameTitle: UILabel!
    @IBOutlet weak var movieReleaseDate: UILabel!
    

    override func awakeFromNib() {
        super.awakeFromNib()
        selectionStyle = .none
    }
    
    
    //MARK: - Configure Cell -
    func configureCell(model: UpcomingMoviesResult) {
        posterImage.setWith("https://image.tmdb.org/t/p/original/\(model.posterPath)")
        movieNameTitle.text = model.title
        movieReleaseDate.text = "Release Date \(model.releaseDate)"
    }
    
}
