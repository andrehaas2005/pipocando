//
//  PosterCollectionView.swift
//  Pipocando
//
//  Created by Andre  Haas on 11/02/26.
//

import Foundation
import UIKit
import SnapKit

class PosterCollectionView: UIView {
  
  let viewModel: any MovieViewModelProtocol
  weak var delegate: (any HomeViewControllerDelegate)?
  private(set) var listMovies: [Movie] = []
  let posterCollection: UICollectionView = {
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
    insertService()
    setupCollectionView()
    setupBindings()
  }
  
  required init?(coder: NSCoder) {
    fatalError("init(coder:) has not been implemented")
  }
  private func insertService() {
    posterCollection.dataSource = self
    posterCollection.delegate = self
  }
  
  func setupCollectionView() {
    posterCollection.register(PosterGrandeCell.self,
                              forCellWithReuseIdentifier: PosterGrandeCell.identifier)
    
    addSubview(posterCollection)
    posterCollection.snp.makeConstraints { (make) in
      make.edges.equalToSuperview()
    }
  }
  
  private func setupBindings() {
    viewModel.screenState.bind { state in
      switch state {
      case .failure(let erro):
        break
      case .loading(isLoading: let _):
        break
      case .success(let movies):
        self.listMovies = movies
        self.posterCollection.reloadData()
      default:
        break
      }
    }
  }
}
extension PosterCollectionView: UICollectionViewDataSource {
  func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
    print("⛔︎ \(listMovies.count)")
    return listMovies.count
    
  }
  
  func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
    guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: PosterGrandeCell.identifier,
                                                        for: indexPath) as? PosterGrandeCell else {
      return UICollectionViewCell()
    }
    
    let movie = listMovies[indexPath.row]
    cell.cellBuilder(poster: movie.posterPath, name: movie.title)
    return cell
  }
}

extension PosterCollectionView: UICollectionViewDelegateFlowLayout {
  func collectionView(_ collectionView: UICollectionView,
                      layout collectionViewLayout: UICollectionViewLayout,
                      sizeForItemAt indexPath: IndexPath) -> CGSize {
    let width = collectionView.bounds.width
    let height = collectionView.bounds.height
    return CGSize(width: width, height: height)
  }
  
  func collectionView(_ collectionView: UICollectionView,
                      layout collectionViewLayout: UICollectionViewLayout,
                      minimumLineSpacingForSectionAt section: Int) -> CGFloat {
    return 0
  }
  
  func collectionView(_ collectionView: UICollectionView,
                      layout collectionViewLayout: UICollectionViewLayout,
                      minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
    return 0
  }
}

extension PosterCollectionView: UICollectionViewDelegate {
  func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
    
    let movieSelected = listMovies[indexPath.row]
    print("🎦 movie_id: \(movieSelected.id) - \(movieSelected.title)")
    delegate?.didSelectMovie(movieSelected)
  }
  
}
