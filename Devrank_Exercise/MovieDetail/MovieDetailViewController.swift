//
//  MovieDetailViewController.swift
//  iOS_Exercise
//
//  Created by Leonardo Cid on 4/11/19.
//  Copyright © 2019 iTexico. All rights reserved.
//

import UIKit
import SVProgressHUD

class MovieDetailViewController: UIViewController {
    
    @IBOutlet weak var tblTrailers: UITableView!
    @IBOutlet weak var lblDate: UILabel!
    @IBOutlet weak var lblRating: UILabel!
    @IBOutlet weak var lblTitle: UILabel!
    @IBOutlet weak var lblDuration: UILabel!
    @IBOutlet weak var lblOverview: UILabel!
    @IBOutlet weak var imgPoster: UIImageView!
    @IBOutlet weak var imgBackdrop: UIImageView!
    @IBOutlet weak var closeButton: UIButton!
    
    var movieId: Int = 0
    var movieDetail: MovieDetail?
    
    private lazy var viewModel: MovieDetailViewModel = {
        return MovieDetailViewModel()
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupVM()
        
        // Do any additional setup after loading the view, typically from a nib.
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        viewModel.setMovie(id: movieId)
        self.navigationController?.setNavigationBarHidden(false, animated: true)
    }
    
    func setupVM() {
        viewModel.movieDetailFetched = { [unowned self] (movieDetail) in
            self.movieDetail = movieDetail
            self.populateInfo()
        }
        
        viewModel.onError = { (error) in
            SVProgressHUD.showError(withStatus: error.localizedDescription)
        }
    }
    
    func populateInfo() {
        let placeHolder = UIImage(named: "MovieLogo")
        imgPoster.contentMode = .scaleAspectFit
        imgPoster?.af_setImage(withURL: URL(string: (movieDetail?.imageUrl)!)!, placeholderImage: placeHolder, filter: nil, progress: nil, progressQueue: DispatchQueue.main, imageTransition: UIImageView.ImageTransition.crossDissolve(0.35), runImageTransitionIfCached: false, completion:{ [unowned self] (response) in
            self.imgPoster.contentMode = .scaleAspectFill
        })
        
        imgBackdrop.contentMode = .scaleAspectFit
        imgBackdrop?.af_setImage(withURL: (URL(string: (movieDetail?.backdropUrl)!) ?? URL(string:"/"))!, placeholderImage: placeHolder, filter: nil, progress: nil, progressQueue: DispatchQueue.main, imageTransition: UIImageView.ImageTransition.crossDissolve(0.35), runImageTransitionIfCached: false, completion:{ [unowned self] (response) in
            self.imgPoster.contentMode = .scaleAspectFill
        })
        
        
        let duration = "\((movieDetail?.runtime)! / 60)h \((movieDetail?.runtime)! % 60)m"
        let dateAndDurationInfo = "\((movieDetail?.releaseDate)!) - \(duration)"
    
        lblTitle.text = movieDetail?.title!
        lblOverview.text = movieDetail?.overView
        lblDate.text = dateAndDurationInfo
        lblRating.text = "\(movieDetail?.voteAverage ?? 0)/10"
        
    }
    
    
    @IBAction func close(_ sender: Any) {
        self.dismiss(animated: true, completion: nil)
    }
}
