import Foundation

final class MovieDetailsRepositoryImpl: MovieDetailsRepository {
  private let remoteDataSource: any MovieRemoteDataSource

  init(remoteDataSource: any MovieRemoteDataSource) {
    self.remoteDataSource = remoteDataSource
  }

  func fetchMovieDetails(_ movieID: Int) async throws -> MovieDetails {
    try await remoteDataSource.fetchMovieDetails(movieID: movieID)
  }
}
