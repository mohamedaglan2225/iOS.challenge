//
//  MovieDetailsViewModel.swift
//  iOS.challenge
//
//  Created by Mohamed Aglan on 18/10/2024.
//

import Combine

final class MovieDetailsViewModel: BaseViewModel {
    
    //MARK: - Properties -
    private(set) var isLoading: PassthroughSubject<Bool, Never> = .init()
    private(set) var errorPublisher: PassthroughSubject<Error, Never> = .init()
    private(set) var movieDetailsModel: PassthroughSubject<MovieDetailsModel, Never> = .init()
    private(set) var genresModel: CurrentValueSubject<[Genre], Never> = .init([])
    
    
    //MARK: - Networking -
    func getMovieDetailsApi(movieId: Int) {
        Task {
            isLoading.send(true)
            do {
                let request = MovieDetailsNetwork.movieDetailsApi(movieId: movieId)
                let data = try await self.requestGeneralResponse(request)
                self.movieDetailsModel.send(data)
                self.genresModel.value.append(contentsOf: data.genres ?? [])
            }catch {
                errorPublisher.send(error)
            }
            isLoading.send(false)
        }
    }
    
    
    
}
