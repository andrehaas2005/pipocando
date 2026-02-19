import UIKit
import SnapKit
import Kingfisher

final class ChapterView: UIView {
    
    // MARK: - UI Components
    
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
    
    private let titleLabel: UILabel = {
        let label = UILabel()
        label.font = .systemFont(ofSize: 14, weight: .bold)
        label.textColor = .white
        label.numberOfLines = 2
        return label
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
    
    // MARK: - Init
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupHierarchy()
        setupConstraints()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - Setup
    
    private func setupHierarchy() {
        addSubview(mainStackView)
        
        mainStackView.addArrangedSubview(imageContainer)
        mainStackView.addArrangedSubview(textStackView)
        
        imageContainer.addSubview(serieImageView)
        
        textStackView.addArrangedSubview(titleLabel)
        textStackView.addArrangedSubview(episodeLabel)
        textStackView.addArrangedSubview(streamerLabel)
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
    }
    
    // MARK: - Configuration
    
    func configure(with serie: Serie) {
        titleLabel.text = serie.name
        episodeLabel.text = "Episode: \(serie.id)"
        streamerLabel.text = serie.firstAirDate
        
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
