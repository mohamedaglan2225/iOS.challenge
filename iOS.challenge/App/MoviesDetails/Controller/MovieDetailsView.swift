//
//  MovieDetailsView.swift
//  iOS.challenge
//
//  Created by Mohamed Aglan on 18/10/2024.
//

import UIKit
import Combine

class MovieDetailsView: BaseViewController {
    
    
    //MARK: - IBOutLets -
    @IBOutlet weak var scrollView: UIScrollView!
    @IBOutlet weak var posterImage: UIImageView!
    @IBOutlet weak var imagePreview: UIImageView!
    @IBOutlet weak var movieName: UILabel!
    @IBOutlet weak var movieStatus: UILabel!
    @IBOutlet weak var movieDescrption: UILabel!
    @IBOutlet weak var genresCollectionView: UICollectionView!
    @IBOutlet weak var movieRunTime: UILabel!
    @IBOutlet weak var movieReleaseDate: UILabel!
    
    
    
    
    //MARK: - Properties -
    private var viewModel: MovieDetailsViewModel
    private var cancellable: Set<AnyCancellable> = []
    private var movieId: Int?
    private var genreModel: [Genre] = [] {
        didSet {
            genresCollectionView.reloadData()
        }
    }
    
    //MARK: - LifeCycle Events -
    override func viewDidLoad() {
        super.viewDidLoad()
        callMovieDetailsApi()
        binding()
        registerCell()
    }
    
    init(viewModel: MovieDetailsViewModel = MovieDetailsViewModel()) {
        self.viewModel = viewModel
        super.init(nibName: "MovieDetailsView", bundle: nil)
    }
    
    
    required init?(coder: NSCoder) {
        self.viewModel = MovieDetailsViewModel()
        super.init(coder: coder)
    }
    
    
    //MARK: - Creation -
    static func create(movieId: Int) -> MovieDetailsView {
        let vc = MovieDetailsView()
        vc.movieId = movieId
        return vc
    }
    
    
    //MARK: - Register Cell -
    private func registerCell() {
        genresCollectionView.register(cellType: GenresCell.self)
        genresCollectionView.delegate = self
        genresCollectionView.dataSource = self
    }
    
    
    //MARK: - Binding -
    private func binding() {
        viewModel.isLoading.sinkOnMain { [weak self] isLoading in
            guard let self = self else {return}
            isLoading ? (scrollView.alpha = 0) : (scrollView.alpha = 1)
            isLoading ? showIndicator() : hideIndicator()
        }.store(in: &cancellable)
        
        viewModel.errorPublisher.sinkOnMain { [weak self] error in
            guard let self = self else {return}
            self.show(errorMessage: error.localizedDescription)
        }.store(in: &cancellable)
        
        viewModel.genresModel.sinkOnMain { [weak self] data in
            guard let self = self else {return}
            self.genresCollectionView.reloadData()
        }.store(in: &cancellable)
        
        viewModel.movieDetailsModel.sinkOnMain { [weak self] data in
            guard let self = self else {return}
            self.posterImage.setWith("https://image.tmdb.org/t/p/original/\(data.posterPath)")
            self.imagePreview.setWith("https://image.tmdb.org/t/p/original/\(data.backdropPath)")
            self.movieName.text = data.title
            self.movieStatus.text = "Movie Status is : \(data.status)"
            self.movieDescrption.text = data.overview
            self.movieRunTime.text = "Movie Run Time : \(data.runtime)"
            self.movieReleaseDate.text = "Movie Release Data : \(data.releaseDate)"
        }.store(in: &cancellable)
    }
    
    
    //MARK: - Call Api -
    private func callMovieDetailsApi() {
        guard let id = movieId else {return}
        viewModel.getMovieDetailsApi(movieId: id)
    }


}


//MARK: - CollectionView -
extension MovieDetailsView: UICollectionViewDataSource, UICollectionViewDelegate, UICollectionViewDelegateFlowLayout {
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return viewModel.genresModel.value.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let item = collectionView.dequeueReusableCell(with: GenresCell.self, for: indexPath)
        item.configureCell(model: viewModel.genresModel.value[indexPath.row])
        return item
    }
    
    
}
