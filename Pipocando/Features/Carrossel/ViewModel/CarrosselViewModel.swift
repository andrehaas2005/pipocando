//
//  CarrosselViewModel.swift
//  Pipocando
//
//  Created by Andre  Haas on 13/02/26.
//

import Foundation

@MainActor
class CarrosselViewModel: MovieViewModelProtocol {

  private let fetchNowPlayingMoviesUseCase: any FetchNowPlayingMoviesUseCase
  var screenState: Observable<MoviePosterState> = .init(.idle)

  init(fetchNowPlayingMoviesUseCase: any FetchNowPlayingMoviesUseCase) {
    self.fetchNowPlayingMoviesUseCase = fetchNowPlayingMoviesUseCase
  }

  func fetchData() {
    screenState.value = .loading

    Task { [weak self] in
      do {
        let movies = try await fetchNowPlayingMoviesUseCase.execute()
        self?.screenState.value = .loaded(movies)
      } catch {
        self?.screenState.value = .error(AppError.map(error))
      }
    }
  }
}
