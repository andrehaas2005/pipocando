//
//  DetailsViewModel.swift
//  AmorPorFilmesSeries
//

import Foundation
import UIKit

protocol DetailsRouting: AnyObject {}

enum DetailsState {
  case idle
  case loading
  case loaded(MovieDetails)
  case error(AppError)
}

@MainActor
final class DetailsViewModel {
  let detailType: DetailType
  private let fetchMovieDetailsUseCase: any FetchMovieDetailsUseCase
  private var fetchMovieTask: Task<Void, Never>?
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
  let screenState = Observable<DetailsState>(.idle)

  weak var coordinator: (any DetailsRouting)?

  init(
    detailType: DetailType,
    fetchMovieDetailsUseCase: any FetchMovieDetailsUseCase
  ) {
    self.detailType = detailType
    self.fetchMovieDetailsUseCase = fetchMovieDetailsUseCase
    setupDetails(for: detailType)
    setupMockContent()
  }

  func fetchDataMovie(_ movie: Movie) {
    fetchMovieTask?.cancel()
    screenState.value = .loading

    fetchMovieTask = Task { [weak self] in
      guard let self else { return }

      do {
        let details = try await fetchMovieDetailsUseCase.execute(movieID: movie.id)
        guard !Task.isCancelled else { return }

        screenState.value = .loaded(details)
        updateMetadata(details)
        cast.value = details.credits?.cast
      } catch {
        guard !Task.isCancelled else { return }
        screenState.value = .error(AppError.map(error))
      }
    }
  }


  deinit {
    fetchMovieTask?.cancel()
  }

  private func setupDetails(for type: DetailType) {
    switch type {
    case .movie(let movie):
      title.value = movie.title
      description.value = movie.overview
      if let imageURL = Configuration.imageBaseURL {
        imageUrl.value = URL(string: imageURL  + movie.posterPath)
      }
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

  private func updateMetadata(_ detail: MovieDetails) {
    let year = detail.releaseDate.prefix(4)
    let genres = detail.genres.map(\.name).joined(separator: " ")
    let tempo = formatDuration(minutes: detail.runtime)
    metadata.value = "\(year) • \(tempo) • \(genres)"
  }

  func formatDuration(minutes: Int) -> String {
      let hours = minutes / 60
      let remainingMinutes = minutes % 60

      if hours > 0 {
          return "\(hours)h \(remainingMinutes)min"
      } else {
          return "\(remainingMinutes)min"
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
