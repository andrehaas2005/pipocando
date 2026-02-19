//
//  CarrosselView.swift
//  Pipocando
//
//  Created by Andre  Haas on 13/02/26.
//

import Foundation
import UIKit
import SnapKit

class CarrosselCollectionView: UIView {
  
  var viewModel: any MovieViewModelProtocol
  private(set) var listMovies: [Movie] = []
  
  let carrosselCollection: UICollectionView = {
    let collectionViewLayout = UICollectionViewFlowLayout()
    collectionViewLayout.scrollDirection = .horizontal
    let collectionView = UICollectionView(frame: .zero,
                                          collectionViewLayout: collectionViewLayout)
    collectionView.backgroundColor = .clear
    collectionView.showsHorizontalScrollIndicator = false
    collectionView.translatesAutoresizingMaskIntoConstraints = false
    return collectionView
  }()
  
  init(viewModel: any MovieViewModelProtocol) {
    self.viewModel = viewModel
    super.init(frame: .zero)
    setupCarrossel()
  }
  
  required init?(coder: NSCoder) {
    fatalError("init(coder:) has not been implemented")
  }
 
  private func setupCarrossel(){
    configureCollectionView()
    setupView()
    setupBindings()
  }
  private func configureCollectionView() {
    carrosselCollection.delegate = self
    carrosselCollection.dataSource = self
    carrosselCollection.register(MovieCarouselCell.self,
                              forCellWithReuseIdentifier: MovieCarouselCell.identifier)
  }
  
  private func setupView() {
    addSubview(carrosselCollection)
    carrosselCollection.snp.makeConstraints { (make) in
      make.edges.equalToSuperview()
    }
  }
  
  private func setupBindings() {
    viewModel.screenState.bind { [weak self] state in
      switch state {
      case .failure(let _):
        break
      case .loading(isLoading: let _):
        break
      case .success(let movies):
        self?.listMovies = movies
        self?.carrosselCollection.reloadData()
      case .none:
        break
      }
    }
  }
}

extension CarrosselCollectionView: UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
  func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
    listMovies.count
  }
  
  func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
    guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: MovieCarouselCell.identifier,
                                                        for: indexPath) as? MovieCarouselCell
    else { return UICollectionViewCell() }
    
    let movie = listMovies[indexPath.item]
    cell.configure(with: movie)
    
    return cell
  }
  
  func collectionView(_ collectionView: UICollectionView,
                      layout collectionViewLayout: UICollectionViewLayout,
                      sizeForItemAt indexPath: IndexPath) -> CGSize {
    return CGSize(width: 110, height: 250)
    
  }
}
