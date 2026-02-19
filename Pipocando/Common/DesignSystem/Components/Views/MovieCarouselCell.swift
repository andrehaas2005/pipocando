//
//  MovieCarouselCell.swift
//  AmorPorFilmesSeries
//
//  Created by Andre  Haas on 29/05/25.
//


// MovieCarouselCell.swift
import Kingfisher
import UIKit
import SnapKit

class MovieCarouselCell: UICollectionViewCell {
  
  static let identifier = "MovieCell"
  
  private let cellBox: UIView = {
    let view = UIView(frame: .zero) //UIView(frame: CGRect(x: 0, y: 0, width: 150, height: 200))
    view.backgroundColor = .black
    return view
  }()
  
  private let movieImageView: UIImageView = {
    let imageView = UIImageView()
    imageView.contentMode = .scaleAspectFill
    imageView.layer.cornerRadius = 8
    imageView.clipsToBounds = true
    return imageView
  }()
  
  private let titleLabel: UILabel = {
    let label = UILabel()
    label.textColor = .white
    label.font = .boldSystemFont(ofSize: 16)
    label.numberOfLines = 3
    return label
  }()
  
  override init(frame: CGRect) {
    super.init(frame: frame)
    setupUI()
  }
  
  required init?(coder: NSCoder) {
    fatalError("init(coder:) has not been implemented")
  }
  
  private func setupUI() {
    
    cellBox.addSubview(movieImageView)
    cellBox.addSubview(titleLabel)
    
    movieImageView.snp.makeConstraints { make in
      make.leading.equalTo(cellBox.snp.leading)
      make.trailing.equalTo(cellBox.snp.trailing)
      make.height.equalTo(160)
      make.width.equalTo(110)
      make.top.equalTo(cellBox.snp.top)
    }
    
    titleLabel.snp.makeConstraints { make in
      make.leading.equalTo(cellBox.snp.leading).inset(8)
      make.trailing.equalTo(cellBox.snp.trailing).inset(8)
      make.bottom.equalTo(cellBox.snp.bottom).inset(8)
      make.top.equalTo(movieImageView.snp.bottom).offset(8)
    }
    
    // Adiciona um gradiente para melhorar a legibilidade do título
    let gradientLayer = CAGradientLayer()
    gradientLayer.colors = [UIColor.clear.cgColor, UIColor.blue.withAlphaComponent(0.5).cgColor]
    gradientLayer.locations = [0.5, 1.0]
    cellBox.layer.addSublayer(gradientLayer)
    
    gradientLayer.frame = bounds
    gradientLayer.masksToBounds = true
    contentView.addSubview(cellBox)
    cellBox.snp.makeConstraints { make in
      make.edges.equalToSuperview()
    }
  }
  
  override func layoutSubviews() {
    super.layoutSubviews()
    if let gradientLayer = layer.sublayers?.first as? CAGradientLayer {
      gradientLayer.frame = bounds
    }
  }
  
  override func prepareForReuse() {
    super.prepareForReuse()
    movieImageView.kf.cancelDownloadTask()
    movieImageView.image = nil
    titleLabel.text = nil
  }
  
  func configure(with movie: Movie) {
    titleLabel.text = movie.title
    
    if !movie.posterPath.isEmpty {
      if let imageURL = Configuration.imageBaseURL {
        let imageURL = URL(string: imageURL + movie.posterPath)
        movieImageView.kf.setImage(with: imageURL)
      }
    } else {
      movieImageView.image = UIImage(named: "placeholder")
    }
  }
}
