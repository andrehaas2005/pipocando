//
//  DetailsViewController.swift
//  AmorPorFilmesSeries
//
//  Created by Andre Haas on 28/05/25.
//

import UIKit
import SnapKit
import Kingfisher
import WebKit

class DetailsViewController: UIViewController {
  
  private let viewModel: DetailsViewModel
  private var detals: MovieDetails?
  private var moviePreference: MoviePreference?
  private var providerButtons: [String: UIButton] = [:]
  private var movieIDForPreferences: Int?
  private var movieTitleForPreferences: String?
  private let scrollView: UIScrollView = {
    let scrollView = UIScrollView()
    scrollView.contentInsetAdjustmentBehavior = .never
    scrollView.showsVerticalScrollIndicator = false
    return scrollView
  }()
  
  private let contentView: UIView = {
    let view = UIView()
    return view
  }()
  
  private let backdropImage: UIImageView = {
    let imageView = UIImageView()
    imageView.contentMode = .scaleAspectFill
    imageView.clipsToBounds = true
    return imageView
  }()
  
  private let gradientView: UIView = {
    let view = UIView()
    let gradient = CAGradientLayer()
    gradient.colors = [UIColor.clear.cgColor, Color.backgroundDark.withAlphaComponent(0.8).cgColor, Color.backgroundDark.cgColor]
    gradient.locations = [0, 0.7, 1]
    view.layer.addSublayer(gradient)
    return view
  }()
  
  private let titleLabel: UILabel = {
    let label = UILabel()
    label.font = UIFont.systemFont(ofSize: 32, weight: .bold)
    label.textColor = .white
    label.numberOfLines = 0
    return label
  }()
  
  private let metadataLabel: UILabel = {
    let label = UILabel()
    label.font = UIFont.systemFont(ofSize: 14, weight: .medium)
    label.textColor = UIColor(hex: "#baba9c")
    return label
  }()
  
  private let actionsStackView: UIStackView = {
    let stack = UIStackView()
    stack.axis = .horizontal
    stack.spacing = 12
    stack.distribution = .fillEqually
    return stack
  }()
  
  private let favoriteButton = createActionButton(title: "Favoritar", icon: "heart.fill")
  private let watchlistButton = createActionButton(title: "Quero Ver", icon: "bookmark.fill")
  
  private let watchedButton: UIButton = {
    let btn = UIButton()
    btn.setTitle(" Marcar como Assistido", for: .normal)
    if #available(iOS 13.0, *) {
      btn.setImage(UIImage(systemName: "checkmark.circle.fill"), for: .normal)
    }
    btn.titleLabel?.font = UIFont.systemFont(ofSize: 18, weight: .bold)
    btn.backgroundColor = UIColor.darkGray.withAlphaComponent(0.35)
    btn.layer.borderColor = UIColor.gray.withAlphaComponent(0.55).cgColor
    btn.layer.borderWidth = 1
    btn.layer.cornerRadius = 12
    btn.tintColor = UIColor.gray
    btn.setTitleColor(UIColor.lightGray, for: .normal)
    return btn
  }()
  
  private let progressSection = createSectionTitle("Seu Progresso")
  private let progressContainer: UIView = {
    let view = UIView()
    view.backgroundColor = Color.primary.withAlphaComponent(0.1)
    view.layer.cornerRadius = 16
    view.layer.borderWidth = 1
    view.layer.borderColor = Color.primary.withAlphaComponent(0.2).cgColor
    return view
  }()
  
  private let seasonsSection = createSectionTitle("Temporadas")
  private let seasonsSegmentedControl: UISegmentedControl = {
    let sc = UISegmentedControl(items: ["Temporada 1", "Temporada 2", "Temporada 3"])
    sc.selectedSegmentIndex = 0
    sc.selectedSegmentTintColor = Color.primary
    let normalAttr: [NSAttributedString.Key: Any] = [.foregroundColor: UIColor.gray]
    let selectedAttr: [NSAttributedString.Key: Any] = [.foregroundColor: UIColor.white]
    sc.setTitleTextAttributes(normalAttr, for: .normal)
    sc.setTitleTextAttributes(selectedAttr, for: .selected)
    return sc
  }()
  
  private let episodesStackView: UIStackView = {
    let stack = UIStackView()
    stack.axis = .vertical
    stack.spacing = 16
    return stack
  }()
  
  private let providersSection = createSectionTitle("Onde Assistir")
  private let providersStackView: UIStackView = {
    let stack = UIStackView()
    stack.axis = .vertical
    stack.spacing = 12
    return stack
  }()
  
  private let synopsisSection = createSectionTitle("Sinopse")
  private let synopsisLabel: UILabel = {
    let label = UILabel()
    label.font = UIFont.systemFont(ofSize: 16)
    label.textColor = UIColor(hex: "#baba9c")
    label.numberOfLines = 0
    label.lineBreakMode = .byWordWrapping
    return label
  }()
  
  private let castSection = createSectionTitle("Elenco")
  private let castCollectionView: UICollectionView = {
    let layout = UICollectionViewFlowLayout()
    layout.scrollDirection = .horizontal
    let cv = UICollectionView(frame: .zero, collectionViewLayout: layout)
    cv.backgroundColor = .clear
    cv.showsHorizontalScrollIndicator = false
    return cv
  }()
  
  private let trailerSection = createSectionTitle("Trailer")
  private let trailerContainer: UIView = {
    let view = UIView()
    view.layer.cornerRadius = 16
    view.clipsToBounds = true
    view.backgroundColor = .black.withAlphaComponent(0.4)
    return view
  }()
  private let trailerThumbnail: UIImageView = {
    let imageView = UIImageView()
    imageView.contentMode = .scaleAspectFill
    imageView.clipsToBounds = true
    return imageView
  }()
  private  let overlay: WKWebView = {
    let webView = WKWebView()
    webView.configuration.allowsInlineMediaPlayback = true
    webView.configuration.mediaTypesRequiringUserActionForPlayback = []
    return webView
  }()
  
  
  
  private let ratingSection = createSectionTitle("Sua Nota")
  private let ratingContainer: UIView = {
    let view = UIView()
    view.backgroundColor = .black
    view.layer.cornerRadius = 12
    view.layer.borderColor = Color.purple.withAlphaComponent(0.2).cgColor
    view.layer.borderWidth = 1
    return view
  }()
  
  init(viewModel: DetailsViewModel) {
    self.viewModel = viewModel
    super.init(nibName: nil, bundle: nil)
  }
  
  required init?(coder: NSCoder) {
    fatalError("init(coder:) has not been implemented")
  }
  
  override func viewDidLoad() {
    super.viewDidLoad()
    view.backgroundColor = Color.backgroundDark
    setupUI()
    setupBindings()
    setupNavigation()
    updateSectionVisibility()
    updateButtonLayout()
    setupActionHandlers()
  }
  
  override func viewDidLayoutSubviews() {
    super.viewDidLayoutSubviews()
    gradientView.layer.sublayers?.first?.frame = gradientView.bounds
  }
  
  private func setupNavigation() {
    navigationController?.navigationBar.tintColor = .white
    navigationItem.largeTitleDisplayMode = .never
    if #available(iOS 13.0, *) {
      let shareItem = UIBarButtonItem(image: UIImage(systemName: "square.and.arrow.up"), style: .plain, target: nil, action: nil)
      navigationItem.rightBarButtonItem = shareItem
    }
  }
  
  private func setupUI() {
    view.addSubview(scrollView)
    scrollView.snp.makeConstraints { make in
      make.top.equalTo(view.snp_topMargin)
      make.leading.equalTo(view.snp_leadingMargin)
      make.trailing.equalTo(view.snp_trailingMargin)
      make.bottom.equalTo(view.snp_bottomMargin)
    }
    
    scrollView.addSubview(contentView)
    contentView.snp.makeConstraints { make in
      make.top.leading.trailing.bottom.equalToSuperview()
      make.width.equalToSuperview()
    }
    
    contentView.addSubview(backdropImage)
    backdropImage.snp.makeConstraints { make in
      make.top.leading.trailing.equalToSuperview()
      make.height.equalTo(550)
    }
    
    backdropImage.addSubview(gradientView)
    gradientView.snp.makeConstraints { make in
      make.edges.equalToSuperview()
    }
    
    contentView.addSubview(titleLabel)
    titleLabel.snp.makeConstraints { make in
      make.bottom.equalTo(backdropImage).offset(-40)
      make.leading.trailing.equalToSuperview().inset(16)
    }
    
    contentView.addSubview(metadataLabel)
    metadataLabel.snp.makeConstraints { make in
      make.top.equalTo(titleLabel.snp.bottom).offset(8)
      make.leading.trailing.equalTo(titleLabel)
    }
    
    contentView.addSubview(actionsStackView)
    actionsStackView.addArrangedSubview(favoriteButton)
    actionsStackView.addArrangedSubview(watchlistButton)
    
    actionsStackView.snp.makeConstraints { make in
      make.top.equalTo(backdropImage.snp.bottom).offset(16)
      make.leading.trailing.equalToSuperview().inset(16)
      make.height.equalTo(56)
    }
    
    contentView.addSubview(watchedButton)
    watchedButton.snp.makeConstraints { make in
      make.top.equalTo(actionsStackView.snp.bottom).offset(12)
      make.leading.trailing.equalToSuperview().inset(16)
      make.height.equalTo(56)
    }
    
    let mainContentStack = UIStackView(arrangedSubviews: [
      providersSection, providersStackView,
      synopsisSection, synopsisLabel,
      progressSection, progressContainer,
      seasonsSection, seasonsSegmentedControl,
      episodesStackView,
      castSection, castCollectionView,
      trailerSection, trailerContainer,
      ratingSection, ratingContainer
    ])
    mainContentStack.axis = .vertical
    mainContentStack.spacing = 16
    mainContentStack.setCustomSpacing(24, after: providersStackView)
    mainContentStack.setCustomSpacing(24, after: synopsisLabel)
    mainContentStack.setCustomSpacing(24, after: progressContainer)
    mainContentStack.setCustomSpacing(24, after: seasonsSegmentedControl)
    mainContentStack.setCustomSpacing(32, after: episodesStackView)
    mainContentStack.setCustomSpacing(24, after: castCollectionView)
    mainContentStack.setCustomSpacing(24, after: trailerContainer)
    
    contentView.addSubview(mainContentStack)
    mainContentStack.snp.makeConstraints { make in
      make.top.equalTo(watchedButton.snp.bottom).offset(32)
      make.leading.trailing.equalToSuperview().inset(16)
      make.bottom.equalToSuperview().offset(-40)
    }
    
    castCollectionView.snp.makeConstraints { make in
      make.height.equalTo(120)
    }
    castCollectionView.register(ActorCell.self, forCellWithReuseIdentifier: "CastCell")
    castCollectionView.dataSource = self
    castCollectionView.delegate = self
    
    ratingContainer.snp.makeConstraints { make in
      make.height.equalTo(100)
    }
    
    progressContainer.snp.makeConstraints { make in
      make.height.equalTo(160)
    }
    
    trailerContainer.snp.makeConstraints { make in
      make.height.equalTo(200)
    }
    
    setupRatingView()
    setupProgressView()
    setupTrailerView()
  }
  
  private func setupProgressView() {
    let lastEpLabel = UILabel()
    lastEpLabel.text = "ÚLTIMO EPISÓDIO VISTO"
    lastEpLabel.font = UIFont.systemFont(ofSize: 10, weight: .bold)
    lastEpLabel.textColor = Color.primary
    
    let epCodeLabel = UILabel()
    epCodeLabel.text = "T02E05"
    epCodeLabel.font = UIFont.systemFont(ofSize: 20, weight: .bold)
    epCodeLabel.textColor = .white
    
    let progressBar = UIProgressView(progressViewStyle: .default)
    progressBar.progress = 0.45
    progressBar.progressTintColor = Color.primary
    progressBar.trackTintColor = .white.withAlphaComponent(0.1)
    
    let nextButton = UIButton()
    nextButton.setTitle("Próximo Episódio: T02E06", for: .normal)
    nextButton.titleLabel?.font = UIFont.systemFont(ofSize: 14, weight: .bold)
    nextButton.backgroundColor = Color.primary
    nextButton.layer.cornerRadius = 12
    
    progressContainer.addSubview(lastEpLabel)
    progressContainer.addSubview(epCodeLabel)
    progressContainer.addSubview(progressBar)
    progressContainer.addSubview(nextButton)
    
    lastEpLabel.snp.makeConstraints { make in
      make.top.leading.equalToSuperview().offset(16)
    }
    epCodeLabel.snp.makeConstraints { make in
      make.top.equalTo(lastEpLabel.snp.bottom).offset(4)
      make.leading.equalTo(lastEpLabel)
    }
    progressBar.snp.makeConstraints { make in
      make.top.equalTo(epCodeLabel.snp.bottom).offset(16)
      make.leading.trailing.equalToSuperview().inset(16)
      make.height.equalTo(4)
    }
    nextButton.snp.makeConstraints { make in
      make.top.equalTo(progressBar.snp.bottom).offset(16)
      make.leading.trailing.equalToSuperview().inset(16)
      make.height.equalTo(44)
    }
  }
  
  private func setupTrailerView() {
    
    trailerContainer.addSubview(trailerThumbnail)
    trailerThumbnail.snp.makeConstraints { make in
      make.edges.equalToSuperview()
    }
    
    overlay.backgroundColor = .black.withAlphaComponent(0.4)
    trailerContainer.addSubview(overlay)
    overlay.snp.makeConstraints { make in
      make.edges.equalToSuperview()
    }
    
//    let playButton = UIView()
//    playButton.backgroundColor = Color.primary.withAlphaComponent(0.9)
//    playButton.layer.cornerRadius = 32
    
//    let playIcon = UIImageView(image: UIImage(systemName: "play.fill"))
//    playIcon.tintColor = .white
//    playButton.addSubview(playIcon)
//
//    playIcon.snp.makeConstraints { make in
//      make.center.equalToSuperview()
//      make.width.height.equalTo(32)
//    }
    
//    trailerContainer.addSubview(playButton)
//    playButton.snp.makeConstraints { make in
//      make.center.equalToSuperview()
//      make.width.height.equalTo(64)
//    }
  }
  
  @objc
  func openYoutube(){
    
    guard let codYoutube = detals?.videos?.results.first?.key else { return }
    print("Tap ---> Aqui---> \(codYoutube)")
    let urlBaseYouTube = "https://www.youtube.com/watch?v=\(codYoutube)"
    guard let url = URL(string: urlBaseYouTube) else {return}
    
    let request = URLRequest(url: url)
    overlay.load(request)
    
  }
  
  private func updateButtonLayout() {
    switch viewModel.detailType {
    case .movie:
      // Movies have 2 buttons in action stack + watchedButton below
      // This is the default layout in setupUI
      actionsStackView.addArrangedSubview(favoriteButton)
      actionsStackView.addArrangedSubview(watchlistButton)
      contentView.addSubview(watchedButton)
      watchedButton.isHidden = false
      watchedButton.snp.remakeConstraints { make in
        make.top.equalTo(actionsStackView.snp.bottom).offset(12)
        make.leading.trailing.equalToSuperview().inset(16)
        make.height.equalTo(56)
      }
      
    case .serie:
      // Series have 3 buttons in a single row
      actionsStackView.addArrangedSubview(favoriteButton)
      actionsStackView.addArrangedSubview(watchedButton)
      actionsStackView.addArrangedSubview(watchlistButton)
      
      // Adjust watchedButton appearance for stack view
      watchedButton.isHidden = false
      watchedButton.snp.remakeConstraints { make in
        // Height is handled by stack view
      }
      
    case .actor:
      actionsStackView.isHidden = true
      watchedButton.isHidden = true
    }
  }
  
  private func updateSectionVisibility() {
    switch viewModel.detailType {
    case .movie:
      progressSection.isHidden = true
      progressContainer.isHidden = true
      seasonsSection.isHidden = true
      seasonsSegmentedControl.isHidden = true
      episodesStackView.isHidden = true
      
      ratingSection.isHidden = false
      ratingContainer.isHidden = false
      trailerSection.isHidden = false
      trailerContainer.isHidden = false
      
    case .serie:
      progressSection.isHidden = false
      progressContainer.isHidden = false
      seasonsSection.isHidden = false
      seasonsSegmentedControl.isHidden = false
      episodesStackView.isHidden = false
      
      ratingSection.isHidden = true
      ratingContainer.isHidden = true
      trailerSection.isHidden = true
      trailerContainer.isHidden = true
      
    case .actor:
      progressSection.isHidden = true
      progressContainer.isHidden = true
      seasonsSection.isHidden = true
      seasonsSegmentedControl.isHidden = true
      episodesStackView.isHidden = true
      ratingSection.isHidden = true
      ratingContainer.isHidden = true
      trailerSection.isHidden = true
      trailerContainer.isHidden = true
    }
  }
  
  private func setupRatingView() {
    let starsStack = UIStackView()
    starsStack.axis = .horizontal
    starsStack.spacing = 8
    for i in 0..<5 {
      let star = UIImageView(image: UIImage(systemName: i < 4 ? "star.fill" : "star"))
      star.tintColor = i < 4 ? Color.purple : .darkGray
      starsStack.addArrangedSubview(star)
    }
    
    let scoreLabel = UILabel()
    scoreLabel.text = "4 / 5"
    scoreLabel.font = UIFont.systemFont(ofSize: 24, weight: .bold)
    scoreLabel.textColor = .white
    
    let ratingStack = UIStackView(arrangedSubviews: [starsStack, scoreLabel])
    ratingStack.axis = .vertical
    ratingStack.alignment = .center
    ratingStack.spacing = 8
    
    ratingContainer.addSubview(ratingStack)
    ratingStack.snp.makeConstraints { make in
      make.center.equalToSuperview()
    }
  }
  

  private func setupActionHandlers() {
    favoriteButton.addTarget(self, action: #selector(toggleFavorite), for: .touchUpInside)
    watchlistButton.addTarget(self, action: #selector(toggleWantToWatch), for: .touchUpInside)
    watchedButton.addTarget(self, action: #selector(toggleWatched), for: .touchUpInside)
  }

  private func loadPreferencesIfPossible() {
    guard let movieIDForPreferences, let movieTitleForPreferences else { return }
    MoviePreferenceStore.shared.fetch(movieID: movieIDForPreferences, movieTitle: movieTitleForPreferences) { [weak self] preference in
      DispatchQueue.main.async {
        self?.moviePreference = preference
        self?.renderPreferenceState()
      }
    }
  }

  private func persistPreference() {
    guard let preference = moviePreference else { return }
    MoviePreferenceStore.shared.save(preference)
  }

  private func renderPreferenceState() {
    let favorite = moviePreference?.isFavorite ?? false
    let wantToWatch = moviePreference?.wantToWatch ?? false
    let watched = moviePreference?.isWatched ?? false

    applySelectionStyle(for: favoriteButton, selected: favorite)
    applySelectionStyle(for: watchlistButton, selected: wantToWatch)
    applySelectionStyle(for: watchedButton, selected: watched)

    providerButtons.forEach { provider, button in
      let selected = moviePreference?.whereToWatch[provider] ?? false
      applySelectionStyle(for: button, selected: selected, selectedTextColor: .white)
    }
  }

  private func applySelectionStyle(for button: UIButton, selected: Bool, selectedTextColor: UIColor = .white) {
    if selected {
      button.backgroundColor = Color.purple.withAlphaComponent(0.22)
      button.layer.borderColor = Color.purple.cgColor
      button.tintColor = Color.purple
      button.setTitleColor(selectedTextColor, for: .normal)
    } else {
      button.backgroundColor = UIColor.darkGray.withAlphaComponent(0.35)
      button.layer.borderColor = UIColor.gray.withAlphaComponent(0.55).cgColor
      button.tintColor = UIColor.gray
      button.setTitleColor(UIColor.lightGray, for: .normal)
    }
  }

  @objc
  private func toggleFavorite() {
    guard var preference = moviePreference else { return }
    preference.isFavorite.toggle()
    preference = MoviePreference(
      movieID: preference.movieID,
      movieTitle: preference.movieTitle,
      isFavorite: preference.isFavorite,
      wantToWatch: preference.wantToWatch,
      isWatched: preference.isWatched,
      whereToWatch: preference.whereToWatch,
      userKey: preference.userKey,
      updatedAt: Date().timeIntervalSince1970
    )
    moviePreference = preference
    renderPreferenceState()
    persistPreference()
  }

  @objc
  private func toggleWantToWatch() {
    guard var preference = moviePreference else { return }
    preference.wantToWatch.toggle()
    preference = MoviePreference(
      movieID: preference.movieID,
      movieTitle: preference.movieTitle,
      isFavorite: preference.isFavorite,
      wantToWatch: preference.wantToWatch,
      isWatched: preference.isWatched,
      whereToWatch: preference.whereToWatch,
      userKey: preference.userKey,
      updatedAt: Date().timeIntervalSince1970
    )
    moviePreference = preference
    renderPreferenceState()
    persistPreference()
  }

  @objc
  private func toggleWatched() {
    guard var preference = moviePreference else { return }
    preference.isWatched.toggle()
    preference = MoviePreference(
      movieID: preference.movieID,
      movieTitle: preference.movieTitle,
      isFavorite: preference.isFavorite,
      wantToWatch: preference.wantToWatch,
      isWatched: preference.isWatched,
      whereToWatch: preference.whereToWatch,
      userKey: preference.userKey,
      updatedAt: Date().timeIntervalSince1970
    )
    moviePreference = preference
    renderPreferenceState()
    persistPreference()
  }

  @objc
  private func toggleProvider(_ sender: UIButton) {
    guard let provider = sender.accessibilityIdentifier, var preference = moviePreference else { return }
    var whereToWatch = preference.whereToWatch
    whereToWatch[provider] = !(whereToWatch[provider] ?? false)
    preference = MoviePreference(
      movieID: preference.movieID,
      movieTitle: preference.movieTitle,
      isFavorite: preference.isFavorite,
      wantToWatch: preference.wantToWatch,
      isWatched: preference.isWatched,
      whereToWatch: whereToWatch,
      userKey: preference.userKey,
      updatedAt: Date().timeIntervalSince1970
    )
    moviePreference = preference
    renderPreferenceState()
    persistPreference()
  }

  private func setupBindings() {
    viewModel.title.bind { [weak self] text in
      
      guard let text = text else {return}
      self?.titleLabel.text = text
    }
    viewModel.imageUrl.bind { [weak self] url in
      guard let url = url else {return}
      self?.backdropImage.kf.setImage(with: url, placeholder: UIImage(named: "placeholder"))
    }
    viewModel.description.bind { [weak self] text in
      guard let text = text else {return}
      self?.synopsisLabel.text = text
    }
    viewModel.providers.bind { [weak self] providers in
      guard let providers = providers else {return}
      self?.updateProviders(providers)
    }
    viewModel.cast.bind { [weak self] _ in
      self?.castCollectionView.reloadData()
    }
    viewModel.episodes.bind { [weak self] episodes in
      guard let episodes = episodes else { return }
      self?.updateEpisodes(episodes)
    }
    viewModel.trailerImageUrl.bind { [weak self] url in
      guard let url = url else {return}
      self?.trailerThumbnail.kf.setImage(with: url, placeholder: UIImage(named: "placeholder"))
      
    }
    viewModel.metadata.bind { [weak self] text in
      guard let text = text else { return }
      self?.metadataLabel.text = text
    }
    
    viewModel.screenState.bind { [weak self] state in
      switch state {
      case .loaded(let movieDetails):
        self?.detals = movieDetails
        self?.movieIDForPreferences = movieDetails.id
        self?.movieTitleForPreferences = movieDetails.title
        self?.loadPreferencesIfPossible()
        self?.openYoutube()
      case .idle, .loading, .error:
        break
      case nil:
        break
      }
    }
  }
  
  private func updateProviders(_ providers: [(name: String, color: String)]) {
    providersStackView.arrangedSubviews.forEach { $0.removeFromSuperview() }
    providerButtons.removeAll()

    var normalized = providers
    if !normalized.contains(where: { $0.name.lowercased() == "cinema" }) {
      normalized.append(("Cinema", "#5A2EA6"))
    }

    let chunks = stride(from: 0, to: normalized.count, by: 2).map {
      Array(normalized[$0..<min($0 + 2, normalized.count)])
    }

    for chunk in chunks {
      let row = UIStackView()
      row.axis = .horizontal
      row.spacing = 12
      row.distribution = .fillEqually
      chunk.forEach { provider in
        let button = createProviderView(name: provider.name, color: UIColor(hex: provider.color))
        providerButtons[provider.name] = button
        row.addArrangedSubview(button)
      }
      providersStackView.addArrangedSubview(row)
    }

    renderPreferenceState()
  }

  private func updateEpisodes(_ episodes: [(code: String, title: String, desc: String)]) {
    episodesStackView.arrangedSubviews.forEach { $0.removeFromSuperview() }
    for ep in episodes {
      episodesStackView.addArrangedSubview(createEpisodeView(code: ep.code, title: ep.title, desc: ep.desc))
    }
  }
  
  private func createEpisodeView(code: String, title: String, desc: String) -> UIView {
    let view = UIView()
    let thumb = UIView()
    thumb.backgroundColor = .darkGray
    thumb.layer.cornerRadius = 8
    thumb.clipsToBounds = true
    let playIcon = UIImageView(image: UIImage(systemName: "play.circle"))
    playIcon.tintColor = .white.withAlphaComponent(0.6)
    thumb.addSubview(playIcon)
    playIcon.snp.makeConstraints { make in make.center.equalToSuperview(); make.width.height.equalTo(32) }
    
    let codeLabel = UILabel()
    codeLabel.text = code
    codeLabel.font = UIFont.systemFont(ofSize: 10, weight: .bold)
    codeLabel.textColor = Color.primary
    
    let titleLabel = UILabel()
    titleLabel.text = title
    titleLabel.font = UIFont.systemFont(ofSize: 14, weight: .bold)
    titleLabel.textColor = .white
    
    let descLabel = UILabel()
    descLabel.text = desc
    descLabel.font = UIFont.systemFont(ofSize: 12)
    descLabel.textColor = .gray
    descLabel.numberOfLines = 2
    
    view.addSubview(thumb)
    view.addSubview(codeLabel)
    view.addSubview(titleLabel)
    view.addSubview(descLabel)
    
    thumb.snp.makeConstraints { make in
      make.top.leading.equalToSuperview()
      make.width.equalTo(120)
      make.height.equalTo(80)
      make.bottom.lessThanOrEqualToSuperview()
    }
    codeLabel.snp.makeConstraints { make in
      make.top.equalTo(thumb)
      make.leading.equalTo(thumb.snp.trailing).offset(12)
    }
    titleLabel.snp.makeConstraints { make in
      make.top.equalTo(codeLabel.snp.bottom).offset(2)
      make.leading.equalTo(codeLabel)
      make.trailing.equalToSuperview()
    }
    descLabel.snp.makeConstraints { make in
      make.top.equalTo(titleLabel.snp.bottom).offset(4)
      make.leading.equalTo(codeLabel)
      make.trailing.equalToSuperview()
      make.bottom.lessThanOrEqualToSuperview()
    }
    return view
  }
  
  private static func createActionButton(title: String, icon: String) -> UIButton {
    let btn = UIButton()
    btn.setTitle(" " + title, for: .normal)
    if #available(iOS 13.0, *) {
      btn.setImage(UIImage(systemName: icon), for: .normal)
    }
    btn.titleLabel?.font = UIFont.systemFont(ofSize: 16, weight: .semibold)
    btn.backgroundColor = UIColor.darkGray.withAlphaComponent(0.35)
    btn.layer.borderColor = UIColor.gray.withAlphaComponent(0.55).cgColor
    btn.layer.borderWidth = 1
    btn.layer.cornerRadius = 12
    btn.tintColor = UIColor.gray
    btn.setTitleColor(UIColor.lightGray, for: .normal)
    return btn
  }
  
  private static func createSectionTitle(_ title: String) -> UILabel {
    let label = UILabel()
    label.text = title
    label.font = UIFont.systemFont(ofSize: 18, weight: .bold)
    label.textColor = .white
    return label
  }
  
  private func createProviderView(name: String, color: UIColor) -> UIButton {
    let button = UIButton(type: .system)
    button.setTitle(name, for: .normal)
    button.titleLabel?.font = UIFont.systemFont(ofSize: 14, weight: .bold)
    button.layer.cornerRadius = 12
    button.layer.borderWidth = 1
    button.layer.borderColor = color.withAlphaComponent(0.8).cgColor
    button.accessibilityIdentifier = name
    button.addTarget(self, action: #selector(toggleProvider(_:)), for: .touchUpInside)
    button.snp.makeConstraints { make in make.height.equalTo(48) }
    applySelectionStyle(for: button, selected: false, selectedTextColor: .white)
    return button
  }
}

extension DetailsViewController: UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
  func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
    return viewModel.cast.value?.count ?? 0
  }
  
  func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
    guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "CastCell",
                                                        for: indexPath) as? ActorCell else { return UICollectionViewCell()}
    
    if let cast = viewModel.cast.value?[indexPath.item] {
      cell.configure(cast)
    }
    return cell
  }
  
  func collectionView(_ collectionView: UICollectionView,
                      layout collectionViewLayout: UICollectionViewLayout,
                      sizeForItemAt indexPath: IndexPath) -> CGSize {
    return CGSize(width: 80, height: 110)
  }
}
