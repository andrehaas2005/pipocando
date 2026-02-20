//
//  DetailsViewModel.swift
//  AmorPorFilmesSeries
//

import Foundation
import UIKit

enum StateMovieDetails {
  case success(MovieDetails)
  case fails(String)
  case loading(Bool)
}


class DetailsViewModel {
  let detailType: DetailType
  let title = Observable<String?>(nil)
  let description = Observable<String?>(nil)
  let imageUrl = Observable<URL?>(nil)
  let trailerImageUrl = Observable<URL?>(nil)
  let metadata = Observable<String?>(nil)
  
  // Mock data for UI components
  let providers = Observable<[(name: String, color: String)]>([])
  let cast = Observable<[Cast]>([])
  let episodes = Observable<[(code: String, title: String, desc: String)]>([])
  let rating = Observable<Double>(4.0)
  let screenState = Observable<StateMovieDetails>(.loading(false))
  
  weak var coordinator: DetailsCoordinator?
  
  init(detailType: DetailType) {
    self.detailType = detailType
    setupDetails(for: detailType)
    setupMockContent()
  }
  
  func fetchDataMovie(_ movie: Movie) {
    let service = MovieService.shared
    service.fetchMovieDetails(movie.id) { [weak self] result in
      switch result {
      case .success(let details):
        self?.screenState.value = .success(details)
        self?.cast.value = details.credits?.cast
      case .failure(let error):
        self?.screenState.value = .fails(error.localizedDescription)
      }
    }
  }
  
  private func setupDetails(for type: DetailType) {
    switch type {
    case .movie(let movie):
      title.value = movie.title
      description.value = movie.overview
      if let imageURL = Configuration.imageBaseURL {
        imageUrl.value = URL(string: imageURL  + movie.posterPath)
      }
      // Example metadata: "2024 • 2h 46m • Ficção Científica, Ação"
      let year = movie.releaseDate.prefix(4)
      metadata.value = "\(year) • 2h 46m • Ficção Científica, Ação"
      fetchDataMovie(movie)
    case .serie(let serie):
      title.value = serie.name
      description.value = serie.overview
      imageUrl.value =  URL(string: serie.posterPath)
      metadata.value = "2023 • 2 Temporadas • Drama, Sci-Fi"
    case .actor(let actor):
      title.value = actor.name
      description.value = "Informações detalhadas sobre o ator."
      imageUrl.value = actor.name.isEmpty ? nil : URL(string: "https://image.tmdb.org/t/p/w500/\(actor.profilePath)")
    }
  }
  
  private func setupMockContent() {
    providers.value = [
      ("Netflix", "#E50914"),
      ("Max", "#002be7"),
      ("Prime Video", "#00052d"),
      ("Apple TV", "#f5f5f7")
    ]
    
    trailerImageUrl.value = URL(string: "https://shre.ink/5mLr")
    
    
    episodes.value = [
      ("E01", "O Horizonte de Eventos", "A tripulação descobre os primeiros sinais de vida no planeta Miller."),
      ("E02", "Congelamento Profundo", "Uma tempestade inesperada coloca em risco a base principal de exploração.")
    ]
  }
}
