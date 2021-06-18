//
//  MoviesCollectionView.swift
//  iOS_Exercise
//
//  Created by Leonardo Cid on 6/18/21.
//  Copyright © 2021. All rights reserved.
//

import UIKit
import AlamofireImage
import UICircularProgressRing

class MoviesCollectionViewCell: UICollectionViewCell {
    @IBOutlet weak var imgPoster: UIImageView!
    @IBOutlet weak var approval: UICircularProgressRing!
    
    static let identifier = "movieCell"
    
    //MARK: Lifecycle
    
    override func awakeFromNib() {
        super.awakeFromNib()
        approval.font = UIFont.systemFont(ofSize: 10)
        approval.superview?.layer.cornerRadius = 20
    }
    
    //MARK: Public
    
    func config(movie: Movie) {
        let placeHolder = UIImage(named: "MovieLogo")
        imgPoster.contentMode = .scaleAspectFit
        imgPoster?.af_setImage(withURL: URL(string: movie.imageUrl)!, placeholderImage: placeHolder, filter: nil, progress: nil, progressQueue: DispatchQueue.main, imageTransition: UIImageView.ImageTransition.crossDissolve(0.35), runImageTransitionIfCached: false, completion:{ [unowned self] (response) in
            self.imgPoster.contentMode = .scaleAspectFill
        })
        approval.value = CGFloat(movie.voteAverage!*10.0)
        
    }
}
//
