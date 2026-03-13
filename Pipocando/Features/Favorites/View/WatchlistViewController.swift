import UIKit
import SnapKit

final class WatchlistViewController: UIViewController {

  private let viewModel: WatchlistViewModel
  private var items: [WatchlistItem] = []

  private let titleLabel: UILabel = {
    let label = UILabel()
    label.text = "Minha Lista"
    label.font = UIFont.systemFont(ofSize: 20, weight: .semibold)
    label.textColor = .white
    return label
  }()

  private let segmentedControl: UISegmentedControl = {
    let items = ["Assistidos", "Interesse", "Favoritos"]
    let sc = UISegmentedControl(items: items)
    sc.selectedSegmentIndex = 0
    sc.backgroundColor = .clear
    sc.selectedSegmentTintColor = .clear

    let normalAttributes: [NSAttributedString.Key: Any] = [
      .foregroundColor: UIColor.gray,
      .font: UIFont.systemFont(ofSize: 14, weight: .bold)
    ]
    let selectedAttributes: [NSAttributedString.Key: Any] = [
      .foregroundColor: Color.primary,
      .font: UIFont.systemFont(ofSize: 14, weight: .bold)
    ]

    sc.setTitleTextAttributes(normalAttributes, for: .normal)
    sc.setTitleTextAttributes(selectedAttributes, for: .selected)
    sc.setBackgroundImage(UIImage(), for: .normal, barMetrics: .default)
    sc.setDividerImage(UIImage(), forLeftSegmentState: .normal, rightSegmentState: .normal, barMetrics: .default)

    return sc
  }()

  private let collectionView: UICollectionView = {
    let layout = UICollectionViewFlowLayout()
    layout.minimumLineSpacing = 20
    layout.minimumInteritemSpacing = 16
    let cv = UICollectionView(frame: .zero, collectionViewLayout: layout)
    cv.backgroundColor = .clear
    cv.contentInset = UIEdgeInsets(top: 20, left: 16, bottom: 20, right: 16)
    return cv
  }()

  private let loadingView = LoadingView()
  private let errorView = ErrorView()

  init(viewModel: WatchlistViewModel) {
    self.viewModel = viewModel
    super.init(nibName: nil, bundle: nil)
  }

  required init?(coder: NSCoder) {
    fatalError("init(coder:) has not been implemented")
  }

  override func viewDidLoad() {
    super.viewDidLoad()
    view.backgroundColor = Color.primaryDark
    setupNavigation()
    setupUI()
    setupCollectionView()
    setupBindings()
    viewModel.fetchData()
  }

  private func setupNavigation() {
    title = "Pipocando"
    let appearance = UINavigationBarAppearance()
    appearance.configureWithTransparentBackground()
    appearance.backgroundColor = Color.backgroundDark.withAlphaComponent(0.8)
    appearance.backgroundEffect = UIBlurEffect(style: .dark)
    appearance.titleTextAttributes = [.foregroundColor: UIColor.white]

    navigationController?.navigationBar.standardAppearance = appearance
    navigationController?.navigationBar.scrollEdgeAppearance = appearance
  }

  private func setupUI() {
    view.addSubview(titleLabel)
    view.addSubview(segmentedControl)
    view.addSubview(collectionView)

    titleLabel.snp.makeConstraints { make in
      make.top.equalTo(view.safeAreaLayoutGuide).offset(Spacing.md)
      make.leading.equalToSuperview().offset(Spacing.md)
    }

    segmentedControl.snp.makeConstraints { make in
      make.top.equalTo(titleLabel.snp.bottom).offset(Spacing.md)
      make.leading.trailing.equalToSuperview().inset(Spacing.md)
    }

    collectionView.snp.makeConstraints { make in
      make.top.equalTo(segmentedControl.snp.bottom).offset(Spacing.sm)
      make.leading.trailing.bottom.equalToSuperview()
    }

    view.addSubview(loadingView)
    loadingView.snp.makeConstraints { make in
      make.edges.equalTo(collectionView)
    }

    view.addSubview(errorView)
    errorView.snp.makeConstraints { make in
      make.edges.equalTo(collectionView)
    }
  }

  private func setupBindings() {
    errorView.onRetry = { [weak self] in
      self?.viewModel.fetchData()
    }

    viewModel.screenState.bind { [weak self] state in
      guard let state else { return }
      self?.render(state)
    }
  }

  private func render(_ state: WatchlistState) {
    switch state {
    case .idle:
      loadingView.isHidden = true
      errorView.isHidden = true
    case .loading:
      loadingView.isHidden = false
      errorView.isHidden = true
    case .loaded(let items):
      loadingView.isHidden = true
      errorView.isHidden = true
      self.items = items
      collectionView.reloadData()
    case .error(let error):
      loadingView.isHidden = true
      errorView.isHidden = false
      errorView.configure(message: error.userMessage)
    }
  }

  private func setupCollectionView() {
    collectionView.delegate = self
    collectionView.dataSource = self
    collectionView.register(WatchlistPosterCell.self, forCellWithReuseIdentifier: WatchlistPosterCell.identifier)
  }
}

extension WatchlistViewController: UICollectionViewDataSource {
  func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
    items.count
  }

  func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
    guard let cell = collectionView.dequeueReusableCell(
      withReuseIdentifier: WatchlistPosterCell.identifier,
      for: indexPath
    ) as? WatchlistPosterCell else {
      return UICollectionViewCell()
    }

    let item = items[indexPath.row]
    cell.configure(title: item.title, rating: item.rating, imageURL: item.image)
    return cell
  }
}

extension WatchlistViewController: UICollectionViewDelegateFlowLayout {
  func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
    let width = (collectionView.bounds.width - 48) / 2
    return CGSize(width: width, height: width * 1.5)
  }

  func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
    viewModel.didSelectMovie(at: indexPath.row)
  }
}
