//
//  ActorCell.swift
//  Pipocando
//
//  Created by Andre  Haas on 20/02/26.
//
import UIKit
import SnapKit
import Kingfisher

class ActorCell: UICollectionViewCell {
  private let imageView: UIImageView = {
    let iv = UIImageView()
    iv.contentMode = .scaleAspectFill
    iv.clipsToBounds = true
    iv.layer.cornerRadius = 40
    iv.layer.borderWidth = 2
    iv.layer.borderColor = Color.purple.withAlphaComponent(0.2).cgColor
    iv.backgroundColor = .darkGray
    return iv
  }()
  
  private let nameLabel: UILabel = {
    let label = UILabel()
    label.font = UIFont.systemFont(ofSize: 11, weight: .medium)
    label.textColor = .white
    label.textAlignment = .center
    label.numberOfLines = 2
    return label
  }()
  
  override init(frame: CGRect) {
    super.init(frame: frame)
    contentView.addSubview(imageView)
    contentView.addSubview(nameLabel)
    imageView.snp.makeConstraints { make in
      make.top.centerX.equalToSuperview()
      make.width.height.equalTo(80)
    }
    nameLabel.snp.makeConstraints { make in
      make.top.equalTo(imageView.snp.bottom).offset(8)
      make.leading.trailing.equalToSuperview()
    }
  }
  
  required init?(coder: NSCoder) { fatalError() }
  
  func configure(_ cast: Cast) {
    nameLabel.text = cast.name
    
    if let posterPath = cast.profilePath,
       let imageUrl = Configuration.imageBaseURL,
       let imageURL = URL(string: imageUrl + posterPath) { // Exemplo de base URL
      imageView.kf.setImage(with: imageURL, placeholder: UIImage(named: "placeholder"))
    } else {
      imageView.image = UIImage(named: "placeholder")
    }
  }
}
