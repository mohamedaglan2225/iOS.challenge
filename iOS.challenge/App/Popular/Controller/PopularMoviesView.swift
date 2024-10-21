//
//  PopularMoviesView.swift
//  iOS.challenge
//
//  Created by Mohamed Aglan on 18/10/2024.
//

import UIKit
import Combine


class PopularMoviesView: BaseViewController {
    
    
    //MARK: - IBOutLets -
    @IBOutlet weak var tableView: UITableView!
    
    
    
    
    //MARK: - Properties -
    private var cancellable: Set<AnyCancellable> = []
    private var viewModel: PopularMoviesViewModel
    
    
    
    //MARK: - LifeCycle Events -
    override func viewDidLoad() {
        super.viewDidLoad()
        registerCell()
        binding()
        viewModel.loadCachedMovies()
        callApis()
    }
    
    
    init(viewModel: PopularMoviesViewModel = PopularMoviesViewModel()) {
        self.viewModel = viewModel
        super.init(nibName: "PopularMoviesView", bundle: nil)
    }
    
    
    required init?(coder: NSCoder) {
        self.viewModel = PopularMoviesViewModel()
        super.init(coder: coder)
    }
    
    
    
    //MARK: - Configure UI -
    private func registerCell() {
        tableView.register(cellType: PopularMoviesCell.self)
        tableView.delegate = self
        tableView.dataSource = self
        tableView.separatorStyle = .none
    }
    
    private func binding() {
        viewModel.isLoading.sinkOnMain { [weak self] isLoading in
            guard let self = self else {return}
            isLoading ? showIndicator() : hideIndicator()
        }.store(in: &cancellable)
        
        viewModel.errorPublisher.sinkOnMain { [weak self] error in
            guard let self = self else {return}
            self.show(errorMessage: error.localizedDescription)
        }.store(in: &cancellable)
        
        viewModel.popularMoviesModel.sinkOnMain { [weak self] data in
            guard let self = self else {return}
            self.tableView.reloadData()
        }.store(in: &cancellable)
        
    }
    
    
    private func callApis() {
        viewModel.popularMoviesApi(page: viewModel.currentPageNumber)
    }
    
    
    
    
}

//MARK: - TableView Delegate & DataSource -
extension PopularMoviesView: UITableViewDataSource, UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return viewModel.popularMoviesModel.value.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(with: PopularMoviesCell.self, for: indexPath)
        cell.configureCell(model: viewModel.popularMoviesModel.value[indexPath.row])
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 250
    }
    
    func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
        if indexPath.row == viewModel.popularMoviesModel.value.count - 1 {
            viewModel.loadNextPage()
        }
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if !NetworkReachability.shared.isConnectedToInternet() {
            // Show alert if there is no internet connection
            let alert = UIAlertController(title: "No Internet Connection", message: "Please check your internet connection and try again.", preferredStyle: .alert)
            alert.addAction(UIAlertAction(title: "OK", style: .default, handler: nil))
            present(alert, animated: true, completion: nil)
            return
        }
        guard let id = viewModel.popularMoviesModel.value[indexPath.row].id else {return}
        let vc = MovieDetailsView.create(movieId: id)
        vc.hidesBottomBarWhenPushed = true
        navigationController?.pushViewController(vc, animated: true)
    }
    
}
