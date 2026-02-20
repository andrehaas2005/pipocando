//
//  MovieDetails.swift
//  Pipocando
//
//  Created by Andre  Haas on 20/02/26.
//


// This file was generated from JSON Schema using quicktype, do not modify it directly.
// To parse the JSON, add this file to your project and do:
//
//   let movieDetails = try? JSONDecoder().decode(MovieDetails.self, from: jsonData)

import Foundation

// MARK: - MovieDetails
public struct MovieDetails: Codable {
  let adult: Bool
  let backdropPath: String
  let belongsToCollection: BelongsoCollection?
  let budget: Int
  let genres: [Genre]
  let homepage: String
  let id: Int
  let imdbID: String
  let originCountry: [String]
  let originalLanguage: String
  let originalTitle: String
  let overview: String
  let popularity: Double
  let posterPath: String
  let productionCompanies: [ProductionCompany]
  let productionCountries: [ProductionCountry]
  let releaseDate: String
  let revenue: Int
  let runtime: Int
  let spokenLanguages: [SpokenLanguage]
  let status: String
  let tagline: String
  let title: String
  let video: Bool
  let voteAverage: Double
  let voteCount: Int
  let videos: Videos?
  let credits: Credits?
  
  enum CodingKeys: String, CodingKey {
    case adult
    case backdropPath = "backdrop_path"
    case belongsToCollection = "belongs_to_collection"
    case budget
    case genres
    case homepage
    case id
    case imdbID = "imdb_id"
    case originCountry = "origin_country"
    case originalLanguage = "original_language"
    case originalTitle = "original_title"
    case overview
    case popularity
    case posterPath = "poster_path"
    case productionCompanies = "production_companies"
    case productionCountries = "production_countries"
    case releaseDate = "release_date"
    case revenue
    case runtime
    case spokenLanguages = "spoken_languages"
    case status
    case tagline
    case title
    case video
    case voteAverage = "vote_average"
    case voteCount = "vote_count"
    case videos
    case credits
  }
}

struct BelongsoCollection: Codable {
  let id: Int
  let name: String
  let posterPath: String
  let backdropPath: String
  
  enum CodingKeys: String, CodingKey {
    case id
    case name
    case posterPath = "poster_path"
    case backdropPath = "backdrop_path"
  }
}
