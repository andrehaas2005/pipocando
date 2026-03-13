import Foundation

protocol MovieRemoteDataSource {
  func fetchNowPlayingMovies() async throws -> [Movie]
  func fetchMovieDetails(movieID: Int) async throws -> MovieDetails
}

final class DefaultMovieRemoteDataSource: MovieRemoteDataSource {
  private let movieService: any MovieServiceProtocol

  init(movieService: any MovieServiceProtocol) {
    self.movieService = movieService
  }

  func fetchNowPlayingMovies() async throws -> [Movie] {
    try await withCheckedThrowingContinuation { continuation in
      movieService.fetchNowPlayingMovies { result in
        switch result {
        case .success(let movies):
          continuation.resume(returning: movies)
        case .failure(let error):
          continuation.resume(throwing: AppError.map(error))
        }
      }
    }
  }

  func fetchMovieDetails(movieID: Int) async throws -> MovieDetails {
    try await withCheckedThrowingContinuation { continuation in
      movieService.fetchMovieDetails(movieID) { result in
        switch result {
        case .success(let details):
          continuation.resume(returning: details)
        case .failure(let error):
          continuation.resume(throwing: AppError.map(error))
        }
      }
    }
  }
}
