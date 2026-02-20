//
//  HomeViewController.swift
//  Pipocando
//
//  Created by Andre  Haas on 11/02/26.
//

import UIKit
import SnapKit

final class HomeViewController: UIViewController {
  
  private let viewModel: HomeViewModel
  weak var delegate: (any HomeViewControllerDelegate)?
  
  private let scrollView: UIScrollView = {
    let scrollView = UIScrollView()
    scrollView.contentInsetAdjustmentBehavior = .never
    scrollView.showsVerticalScrollIndicator = false
    return scrollView
  }()
  
  private let mainStackView: UIStackView = {
    let stackView = UIStackView()
    stackView.axis = .vertical
    stackView.spacing = 32
    return stackView
  }()
  
  private let posterMovies: PosterCollectionView = {
    let poster = PosterCollectionView(viewModel: PosterViewModel())
    return poster
  }()
  
  private let continueWatchingLabel = Utilits.createSectionLabel("CONTINUAR ASSISTINDO")
  private let continueWatchingStackView: UIStackView = {
    let stack = UIStackView()
    stack.axis = .vertical
    stack.spacing = 12
    return stack
  }()
  
  private let trendingLabel = Utilits.createSectionLabel("TENDÊNCIAS DA SEMANA")
  
  private let carrosselMoviesLancamento: CarrosselCollectionView = {
    let carrossel = CarrosselCollectionView(viewModel: CarrosselViewModel())
    return carrossel
  }()
  
  
  required init?(coder: NSCoder) {
    fatalError("init(coder:) has not been implemented")
  }
  
  init(viewModel: HomeViewModel) {
    self.viewModel = viewModel
    super.init(nibName: nil, bundle: nil)
  }
  
  override func viewDidLoad() {
    super.viewDidLoad()
    setupTheme()
    setupUI()
    setupBindings()
    viewModel.fetchData()
    posterMovies.viewModel.fetchData()
    carrosselMoviesLancamento.viewModel.fetchData()
    posterMovies.delegate = self.delegate
  }
  
  private func setupTheme(){
    view.backgroundColor = Color.backgroundDark

    let appearance = UINavigationBarAppearance()
    appearance.configureWithTransparentBackground()
    appearance.backgroundColor = Color.backgroundDark.withAlphaComponent(0.8)
    appearance.backgroundEffect = UIBlurEffect(style: .dark)
    appearance.titleTextAttributes = [.foregroundColor: UIColor.white]

    navigationController?.navigationBar.standardAppearance = appearance
    navigationController?.navigationBar.scrollEdgeAppearance = appearance

    title = "Pipocando"

    if #available(iOS 13.0, *) {
        let searchItem = UIBarButtonItem(image: UIImage(systemName: "magnifyingglass"), style: .plain, target: nil, action: nil)
        let notifyItem = UIBarButtonItem(image: UIImage(systemName: "bell"), style: .plain, target: nil, action: nil)
        searchItem.tintColor = .white.withAlphaComponent(0.4)
        notifyItem.tintColor = .white.withAlphaComponent(0.4)
        navigationItem.rightBarButtonItems = [notifyItem, searchItem]

        let logoItem = UIBarButtonItem(image: UIImage(systemName: "movieclapper"), style: .plain, target: nil, action: nil)
        logoItem.tintColor = Color.teal
        navigationItem.leftBarButtonItem = logoItem
    }
  }
  
  private func setupUI(){
    view.addSubview(scrollView)
    scrollView.snp.makeConstraints { make in
      make.top.equalTo(view.snp_topMargin)
      make.leading.equalTo(view.snp_leadingMargin)
      make.trailing.equalTo(view.snp_trailingMargin)
      make.bottom.equalTo(view.snp_bottomMargin)
    }
    
    scrollView.addSubview(mainStackView)
    mainStackView.snp.makeConstraints { make in
      make.top.leading.trailing.bottom.equalTo(scrollView.contentLayoutGuide)
      make.width.equalTo(scrollView.frameLayoutGuide)
    }
    
    mainStackView.addArrangedSubview(posterMovies)
    
    posterMovies.snp.makeConstraints { make in
      make.height.equalTo(view.snp.width).multipliedBy(1.25)
    }
    let continueSection = Utilits.createSectionStack(label: continueWatchingLabel, content: continueWatchingStackView)
    mainStackView.addArrangedSubview(continueSection)
    
    let trendingSection = Utilits.createSectionStack(label: trendingLabel, content: carrosselMoviesLancamento)
    mainStackView.addArrangedSubview(trendingSection)
    carrosselMoviesLancamento.snp.makeConstraints { make in
      make.height.equalTo(300)
    }
  }
  
  private func setupBindings() {
    viewModel.screenState.bind {[weak self] state in
      guard let state = state else {return}
      switch state {
      case .loading(isLoading: _):
        break
      case .success(let movies):
        self?.updateContinueWatching(movies)
      case .failure(_):
        break
      }
    }
  }
  
  private func updateContinueWatching(_ items: [Movie]) {
    continueWatchingStackView.arrangedSubviews.forEach { $0.removeFromSuperview() }
    for item in items {
      let cell = ContinueWatchingCell()
      cell.configure(title: item.title, info: item.overview, progress: Float.random(in: 30...100), imageURL: item.posterPath)
      cell.snp.makeConstraints { make in make.height.equalTo(88) }
      continueWatchingStackView.addArrangedSubview(cell)
    }
  }
  
}
