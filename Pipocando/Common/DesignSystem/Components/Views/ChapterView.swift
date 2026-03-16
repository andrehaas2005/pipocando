import UIKit
import SnapKit
import Kingfisher

final class ChapterView: UIView {

  private let mainStackView: UIStackView = {
    let stack = UIStackView()
    stack.axis = .horizontal
    stack.spacing = 12
    stack.alignment = .top
    return stack
  }()

  private let imageContainer: UIView = {
    let view = UIView()
    return view
  }()

  private let serieImageView: UIImageView = {
    let imageView = UIImageView()
    imageView.contentMode = .scaleAspectFill
    imageView.layer.cornerRadius = 8
    imageView.clipsToBounds = true
    return imageView
  }()

  private let textStackView: UIStackView = {
    let stack = UIStackView()
    stack.axis = .vertical
    stack.spacing = 6
    return stack
  }()

  private let titleRowStackView: UIStackView = {
    let stack = UIStackView()
    stack.axis = .horizontal
    stack.spacing = 6
    stack.alignment = .center
    return stack
  }()

  private let titleLabel: UILabel = {
    let label = UILabel()
    label.font = .systemFont(ofSize: 14, weight: .bold)
    label.textColor = .white
    label.numberOfLines = 2
    return label
  }()

  private let favoriteIconView: UIImageView = {
    let imageView = UIImageView()
    if #available(iOS 13.0, *) {
      imageView.image = UIImage(systemName: "star.fill")
    }
    imageView.tintColor = Color.primary
    imageView.isHidden = true
    return imageView
  }()

  private let episodeLabel: UILabel = {
    let label = UILabel()
    label.font = .systemFont(ofSize: 12)
    label.textColor = .gray
    return label
  }()

  private let streamerLabel: UILabel = {
    let label = UILabel()
    label.font = .systemFont(ofSize: 12)
    label.textColor = .lightGray
    return label
  }()

  override init(frame: CGRect) {
    super.init(frame: frame)
    setupHierarchy()
    setupConstraints()
  }

  required init?(coder: NSCoder) {
    fatalError("init(coder:) has not been implemented")
  }

  private func setupHierarchy() {
    addSubview(mainStackView)

    mainStackView.addArrangedSubview(imageContainer)
    mainStackView.addArrangedSubview(textStackView)

    imageContainer.addSubview(serieImageView)

    textStackView.addArrangedSubview(titleRowStackView)
    textStackView.addArrangedSubview(episodeLabel)
    textStackView.addArrangedSubview(streamerLabel)

    titleRowStackView.addArrangedSubview(titleLabel)
    titleRowStackView.addArrangedSubview(favoriteIconView)
  }

  private func setupConstraints() {

    mainStackView.snp.makeConstraints {
      $0.edges.equalToSuperview().inset(16)
    }

    imageContainer.snp.makeConstraints {
      $0.size.equalTo(CGSize(width: 100, height: 130))
    }

    serieImageView.snp.makeConstraints {
      $0.edges.equalToSuperview()
    }

    favoriteIconView.snp.makeConstraints {
      $0.width.height.equalTo(14)
    }
  }

  func configure(with serie: Serie, isFavorite: Bool = false) {
    titleLabel.text = serie.name
    episodeLabel.text = "Episode: \(serie.id)"
    streamerLabel.text = serie.firstAirDate
    favoriteIconView.isHidden = !isFavorite

    guard !serie.posterPath.isEmpty,
          let baseURL = Configuration.imageBaseURL,
          let url = URL(string: baseURL + serie.posterPath)
    else {
      serieImageView.image = UIImage(named: "placeholder")
      return
    }

    serieImageView.kf.setImage(with: url)
  }
}
