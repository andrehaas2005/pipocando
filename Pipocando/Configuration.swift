//
//  Configuration.swift
//  Pipocando
//
//  Created by Andre  Haas on 12/02/26.
//
import Foundation

public enum Configuration {
  private static let config: NSDictionary? = {
    if let path = Bundle.main.path(forResource: "Config", ofType: "plist"),
       let dict = NSDictionary(contentsOfFile: path) {
      return dict
    }
    return nil
  }()
  
  static var baseAPIURL: String? {
    return config?["URLBase"] as? String ?? ProcessInfo.processInfo.environment["BASE_URL"]
  }
  
  static var apiKey: String? {
    return config?["APIKey"] as? String ?? ProcessInfo.processInfo.environment["API_KEY"]
  }
  
  static var imageBaseURL: String? {
    return config?["URLImageBase"] as? String ?? ProcessInfo.processInfo.environment["IMAGE_BASE_URL"]
  }
  public enum Endpoints {
    static var genres: String {
      return "genre/movie/list"
    }
    public enum Movies {
      static var topRated: String {
        return "movie/top_rated"
      }
      public static var nowPlaying: String {
        return "movie/now_playing"
      }
      static var popular: String {
        return "movie/popular"
      }
      static var upcoming: String {
        return "movie/upcoming"
      }
      static var movie: String {
        return "movie/"
      }
    }
    public enum Series {
      static var airingToday: String {
        return "tv/airing_today"
      }
      static var onTheAir: String {
        return "tv/on_the_air"
      }
      static var popular: String {
        return "tv/popular"
      }
      static var topRated: String {
        return "tv/top_rated"
      }
      static var tv: String {
        return "tv/"
      }
    }
  }
}

/*
 Endpoints currently mapped in this file:
 - genre/movie/list
 - movie/top_rated
 - movie/now_playing
 - movie/popular
 - movie/upcoming
 - movie/{movie_id}
 - tv/airing_today
 - tv/on_the_air
 - tv/popular
 - tv/top_rated
 - tv/{series_id}
 */
