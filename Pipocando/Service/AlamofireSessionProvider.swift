//
//  AlamofireSessionProvider.swift
//  Pipocando
//
//  Created by Andre  Haas on 11/02/26.
//

import Alamofire
import Foundation


public final class AlamofireSessionProvider {
  public static let shared: Session = {
    let config = URLSessionConfiguration.af.default
    config.timeoutIntervalForRequest = 30
    config.timeoutIntervalForResource = 30
    return Session(configuration: config)
  }()
}
