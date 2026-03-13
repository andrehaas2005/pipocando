import Foundation

final class MoviesRepositoryImpl: MoviesRepository {
  private let remoteDataSource: any MovieRemoteDataSource

  init(remoteDataSource: any MovieRemoteDataSource) {
    self.remoteDataSource = remoteDataSource
  }

  func fetchNowPlayingMovies() async throws -> [Movie] {
    try await remoteDataSource.fetchNowPlayingMovies()
  }
}
