//
//  Observable.swift
//  Pipocando
//
//  Created by Andre  Haas on 11/02/26.
//

import Foundation
import Combine

public class Observable<T> {
  var value: T? {
    didSet {
      listener?(value)
    }
  }
  private var listener: ((T?) -> Void)?
  init(_ value: T? = nil) {
    self.value = value
  }
  public  func bind(_ listener: @escaping (T?) -> Void) {
    self.listener = listener
    listener(value)
  }
}
