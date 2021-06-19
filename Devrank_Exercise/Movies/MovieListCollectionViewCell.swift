//
//  MovieListCollectionViewCell.swift
//  iOS_Exercise
//
//  Created by Jose Leonardo Cid Fabila on 18/06/21.
//  Copyright © 2021 iTexico. All rights reserved.
//

import UIKit
import AlamofireImage
import UICircularProgressRing

class MovieListCollectionViewCell: UICollectionViewCell {
    static let identifier = "MovieListCell"
    static let nibName: String = "MovieListCollectionViewCell"
    @IBOutlet weak var imgPoster: UIImageView!
    @IBOutlet weak var lblTitle: UILabel!
    @IBOutlet weak var lblGenre: UILabel!
    @IBOutlet weak var lblReleaseDate: UILabel!
    @IBOutlet weak var lblDuration: UILabel!
    @IBOutlet weak var approval: UICircularProgressRing!
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        approval.font = UIFont.systemFont(ofSize: 10)
        approval.superview?.layer.cornerRadius = 20
    }
    
    func config(movie: Movie) {
        let placeHolder = UIImage(named: "MovieLogo")
        imgPoster.contentMode = .scaleAspectFit
        imgPoster?.af_setImage(withURL: URL(string: movie.imageUrl)!, placeholderImage: placeHolder, filter: nil, progress: nil, progressQueue: DispatchQueue.main, imageTransition: UIImageView.ImageTransition.crossDissolve(0.35), runImageTransitionIfCached: false, completion:{ [unowned self] (response) in
            self.imgPoster.contentMode = .scaleAspectFill
        })
//        let genres = movie.genres!
//        var genres = movie.genres.map(){$0.name}
        lblTitle.text = movie.title
        lblGenre.text = movie.genresString
        lblDuration.text = "Popularity: \(movie.popularity!)"
        lblReleaseDate.text = "\("ReleaseDate".localized()): \(movie.releaseDate == nil ? "NotYet".localized() : movie.releaseDate!)"
        
        approval.value = CGFloat(movie.voteAverage!*10.0)
        
    }

}
