//
//  NowPlayingMoviesViewModel.swift
//  iOS.challenge
//
//  Created by Mohamed Aglan on 18/10/2024.
//

import Foundation
import Combine

final class NowPlayingMoviesViewModel: BaseViewModel {
    
    //MARK: - Properties -
    private(set) var isLoading: PassthroughSubject<Bool, Never> = .init()
    private(set) var errorPublisher: PassthroughSubject<Error, Never> = .init()
    private(set) var nowPlayingMoviesModel: CurrentValueSubject<[NowPlayingModelResult] , Never> = .init([])
    private var isLastPage: Bool = false
    private var currentPage: Int = 1
    private var isFetching: Bool = false
    private let cacheKey = "NowPlayingMoviesCache"
    var currentPageNumber: Int {
        return currentPage
    }
    
    //MARK: - Networking -
    func nowPlayingMoviesApi(page: Int) {
        guard !isFetching && !isLastPage else { return }
        isFetching = true
        isLoading.send(true)
        Task {
            do {
                let request = NowPlayingNetwork.nowPlayingMoviesApi(page: page)
                let data = try await self.requestGeneralResponse(request)
                
                if let moviesData = data.results {
                    self.nowPlayingMoviesModel.value.append(contentsOf: moviesData)
                    saveToCache(movies: self.nowPlayingMoviesModel.value)
                }
                
                self.isLastPage = data.page >= data.totalPages
                self.currentPage = data.page
                
            } catch {
                errorPublisher.send(error)
            }
            isFetching = false
            isLoading.send(false)
        }
    }
    
    
    // MARK: - Helper Functions -
    func loadNextPage() {
        nowPlayingMoviesApi(page: currentPage + 1)
    }
    
    
    func loadCachedMovies() {
        if let cachedMovies = loadFromCache() {
            self.nowPlayingMoviesModel.value = cachedMovies
        }
    }
    
    
    private func saveToCache(movies: [NowPlayingModelResult]) {
        let encoder = JSONEncoder()
        if let encoded = try? encoder.encode(movies) {
            UserDefaults.standard.set(encoded, forKey: cacheKey)
        }
    }
    
    private func loadFromCache() -> [NowPlayingModelResult]? {
        if let savedMovies = UserDefaults.standard.object(forKey: cacheKey) as? Data {
            let decoder = JSONDecoder()
            if let loadedMovies = try? decoder.decode([NowPlayingModelResult].self, from: savedMovies) {
                return loadedMovies
            }
        }
        return nil
    }
    
}
