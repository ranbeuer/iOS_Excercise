//
//  ViewController.swift
//  Devrank_Exercise
//
//  Created by Jose Leonardo Cid Fabila on 17/06/21.
//

import UIKit
import Alamofire
import AlamofireImage
import SVProgressHUD

class ViewController: UIViewController, UICollectionViewDataSource, UICollectionViewDelegate, UICollectionViewDelegateFlowLayout {
    @IBOutlet weak var collectionView: UICollectionView?

    private lazy var viewModel: MoviesViewModel = {
        return MoviesViewModel()
    }()
    
    private lazy var cellSizes: MoviesCollectionViewSizes = {
        return MoviesCollectionViewSizes()
    }()
    private var movies = [Movie]()
    
    var gettingMore: Bool = true
    var selectedMovie: Movie!
    
    override var shouldAutorotate: Bool {
        return true
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        collectionView?.dataSource = self
        collectionView?.delegate = self
        collectionView?.register(UINib(nibName: MovieListCollectionViewCell.nibName, bundle: Bundle.main), forCellWithReuseIdentifier: LayoutType.List.rawValue)
        cellSizes.onLayoutUpdated = onLayoutUpdated;
        setUpVM()
        self.navigationController?.hidesBarsOnSwipe = true
        self.title = "PopularMovies".localized()
        cellSizes.updateSizes(self.view.bounds.size)
        
    }
    
    override func viewWillTransition(to size: CGSize, with coordinator: UIViewControllerTransitionCoordinator) {
        super.viewWillTransition(to: size, with: coordinator)
        cellSizes.updateSizes(size)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        viewModel.getGenres{ [unowned self] in
            self.getMovies()
        }
    }

    func setUpVM() {
        viewModel.moviesChanged = {[weak self] (movies) -> Void in
            guard let self = self else {
                return;
            }
            self.gettingMore = false
            self.movies.removeAll()
            self.movies.append(contentsOf: movies)
            if (self.cellSizes.cellSize == CGSize.zero) {
                Alamofire.request((self.movies.first?.imageUrl)!).responseImage { [weak self] response in
                    guard let self = self else {
                        return
                    }
                    if let image = response.result.value {
                        self.cellSizes.setupInitialValues(size: image.size)
                    }
                    self.reloadData(animated: false)
                }
            } else {
                self.reloadData(animated: false)
            }
        }
        viewModel .onError = { (error) -> Void in
            SVProgressHUD.showError(withStatus: error.localizedDescription)
        }
    }
    
    func reloadData(animated: Bool = true) {
        if (animated) {
            self.collectionView?.performBatchUpdates(
              {
                self.collectionView?.reloadSections(IndexSet(integer: 0) as IndexSet)
              }, completion: { (finished:Bool) -> Void in
            })
        } else {
            self.collectionView?.reloadData()
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return movies.count + (gettingMore ? 1 : 0)
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let identifier = (gettingMore && indexPath.row == collectionView.numberOfItems(inSection: indexPath.section) - 1 ? LoadingMoreCollectionViewCell.identifier : cellSizes.layoutType.rawValue)
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: identifier, for: indexPath)
        switch(cell) {
            case is MoviesCollectionViewCell:
                let movieCell = cell as! MoviesCollectionViewCell
                let movie = movies[indexPath.row]
                movieCell.config(movie: movie)
            case is LoadingMoreCollectionViewCell:
                let loadingCell = cell as! LoadingMoreCollectionViewCell
                loadingCell.loadingView.startAnimating()
            case is MovieListCollectionViewCell:
                let movieCell = cell as! MovieListCollectionViewCell
                let movie = movies[indexPath.row]
                movieCell.config(movie: movie)
                print("")
            default:
                print("")
            
        }
        
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        if (gettingMore && indexPath.row == collectionView.numberOfItems(inSection: indexPath.section) - 1) {
            return CGSize(width: (self.collectionView?.bounds.width)!, height: 60)
        }
        return cellSizes.cellSize
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return cellSizes.lineSpace
    }
    
    func collectionView(_ collectionView: UICollectionView, willDisplay cell: UICollectionViewCell, forItemAt indexPath: IndexPath) {
        guard allGenres != nil else {
            return
        }
        gettingMore = viewModel.checkForMore(movieIndex: indexPath.row)
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        selectedMovie = movies[indexPath.row]
        gotoDetail()
    }
    
    func gotoDetail() {
        performSegue(withIdentifier: "detail", sender: nil)
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if let controller = segue.destination as? MovieDetailViewController, let movie = selectedMovie {
            controller.movieId = movie.id!
        }
    }
    
    @IBAction func toggleMovies() {
        viewModel.toggleMovies()
        updateMoviesButton(viewModel.lastType)
        updateTitle(viewModel.lastType)
    }
    
    @IBAction func toggleLayout() {
        cellSizes.toggleCellTypes()
    }
    
    func getMovies() {
        if (viewModel.lastType == .TopRated) {
            viewModel.getTopMovies()
        } else {
            viewModel.getPopularMovies()
        }
    }
    
    func onLayoutUpdated() {
        updateLayoutButton(cellSizes.layoutType)
        self.reloadData()
    }
    
    func updateMoviesButton(_ type: MoviesType) {
        var image: UIImage!
        if (type == .TopRated) {
            image = UIImage(named: "popular")
        } else {
            image = UIImage(named: "top")
        }
        let lastItemColor = self.navigationItem.rightBarButtonItem?.tintColor
        let buttonItem = UIBarButtonItem(image: image, style: .plain, target: self, action: #selector(ViewController.toggleMovies))
        buttonItem.tintColor = lastItemColor
        self.navigationItem.rightBarButtonItem = buttonItem
    }
    
    func updateLayoutButton(_ type: LayoutType) {
        var image: UIImage!
        if (type == .List) {
            image = UIImage(named: "Grid")
        } else {
            image = UIImage(named: "List")
        }
        let lastItemColor = self.navigationItem.leftBarButtonItem?.tintColor
        let buttonItem = UIBarButtonItem(image: image, style: .plain, target: self, action: #selector(ViewController.toggleLayout))
        buttonItem.tintColor = lastItemColor
        self.navigationItem.leftBarButtonItem = buttonItem
    }
    
    func updateTitle(_ type: MoviesType) {
        let locString = (type == .Popular ? "PopularMovies" : "TopRatedMovies")
        self.title = locString.localized()
    }
}

class MoviesCollectionViewSizes {
    var cellSize = CGSize.zero
    var cellWidth: CGFloat = 0
    var ratio: CGFloat = 0
    var onLayoutUpdated: (() -> Void)?
    private var viewsize: CGSize = CGSize.zero
    var layoutType: LayoutType = .Grid
    var lineSpace: CGFloat {
        return layoutType == .Grid ? 0 : 10
    }
    
    func updateSizes(_ size: CGSize) {
        viewsize = size;
        calculateSizes()
    }
    
    func toggleCellTypes() {
        if (layoutType == .Grid) {
            layoutType = .List
        } else {
            layoutType = .Grid
        }
        calculateSizes()
        onLayoutUpdated?()
    }
    
    func calculateSizes() {
        let isIpad = UIDevice.current.userInterfaceIdiom == .pad
        let isPortrait = UIApplication.shared.statusBarOrientation.isPortrait
        
        let numberOfColumns = isIpad ? (isPortrait ?  4 : 8) : (isPortrait ? 3 : 6)
        cellWidth = layoutType == .Grid ? viewsize.width / CGFloat(numberOfColumns) : viewsize.width - 30
        if (ratio != 0) {
            let height = layoutType == .Grid ? cellWidth * self.ratio : 120
            self.cellSize = CGSize(width: cellWidth, height: height)
        }
    }
    
    func setupInitialValues(size: CGSize) {
        self.ratio = size.height / size.width
        var newSize = CGSize(width: self.cellWidth, height: 0)
        newSize.height = newSize.width * size.height / size.width
        self.cellSize = newSize
    }
}

enum LayoutType: String {
    case Grid = "movieCell"
    case List = "MovieListCell"
}





