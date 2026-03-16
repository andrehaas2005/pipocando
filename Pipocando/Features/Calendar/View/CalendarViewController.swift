//
//  CalendarViewController.swift
//  AmorPorFilmesSeries
//
//  Created by Jules on 05/06/25.
//

import UIKit
import SnapKit

class CalendarViewController: UIViewController {

  private var listSeries: [Serie] = []
  private var favoritesMap: [Int: Bool] = [:]

  private let viewModel: CalendarViewModel
  private let scrollView: UIScrollView = {
    let scrollView = UIScrollView()
    scrollView.showsVerticalScrollIndicator = false
    return scrollView
  }()

  private let contentView = UIView()

  private let dateSelectorCollectionView: UICollectionView = {
    let layout = UICollectionViewFlowLayout()
    layout.scrollDirection = .horizontal
    layout.minimumInteritemSpacing = Spacing.xs
    let cv = UICollectionView(frame: .zero, collectionViewLayout: layout)
    cv.backgroundColor = .clear
    cv.showsHorizontalScrollIndicator = false
    cv.contentInset = UIEdgeInsets(top: 0, left: Spacing.md, bottom: 0, right: Spacing.md)
    return cv
  }()

  private let timelineTableView: UITableView = {
    let tv = UITableView()
    tv.backgroundColor = .clear
    tv.separatorStyle = .none
    tv.isScrollEnabled = false
    return tv
  }()

  private var timelineTableViewHeightConstraint: Constraint?

  private let dayHeaderLabel: UILabel = {
    let label = UILabel()
    label.text = "Exibições do dia"
    label.font = UIFont.systemFont(ofSize: 18, weight: .bold)
    label.textColor = .white
    return label
  }()

  private let selectedDateLabel: UILabel = {
    let label = UILabel()
    label.font = UIFont.systemFont(ofSize: 14)
    label.textColor = .gray
    return label
  }()

  init(viewModel: CalendarViewModel) {
    self.viewModel = viewModel
    super.init(nibName: nil, bundle: nil)
  }

  required init?(coder: NSCoder) { fatalError() }

  override func viewDidLoad() {
    super.viewDidLoad()
    view.backgroundColor = Color.backgroundDark
    setupNavigation()
    setupUI()
    setupCollections()
    setupBindings()
  }

  override func viewDidLayoutSubviews() {
    super.viewDidLayoutSubviews()
    updateTableViewHeight()
  }

  private func setupNavigation() {
    title = "Calendário"
    if #available(iOS 13.0, *) {
      let searchItem = UIBarButtonItem(image: UIImage(systemName: "magnifyingglass"), style: .plain, target: nil, action: nil)
      let settingsItem = UIBarButtonItem(image: UIImage(systemName: "gearshape"), style: .plain, target: nil, action: nil)
      navigationItem.rightBarButtonItems = [settingsItem, searchItem]
      let profileImage = UIImageView(image: UIImage(systemName: "person.circle.fill"))
      profileImage.tintColor = Color.primary.withAlphaComponent(0.2)
      profileImage.snp.makeConstraints { make in make.width.height.equalTo(32) }
      navigationItem.leftBarButtonItem = UIBarButtonItem(customView: profileImage)
    }
  }

  private func setupUI() {
    view.addSubview(scrollView)
    scrollView.snp.makeConstraints { make in
      make.edges.equalTo(view.safeAreaLayoutGuide)
    }

    scrollView.addSubview(contentView)
    contentView.snp.makeConstraints { make in
      make.edges.width.equalToSuperview()
    }

    let updateNotifLabel = createSectionLabel("NOTIFICAÇÕES DE ATUALIZAÇÃO")
    let updateCount = UILabel()
    updateCount.text = "2"
    updateCount.textColor = .white
    updateCount.backgroundColor = Color.primary
    updateCount.font = Typography.sectionTitle
    updateCount.textAlignment = .center
    updateCount.layer.cornerRadius = 10
    updateCount.clipsToBounds = true

    let notifHeader = UIStackView(arrangedSubviews: [updateNotifLabel, updateCount])
    notifHeader.spacing = Spacing.xs
    updateCount.snp.makeConstraints { make in make.width.height.equalTo(20) }

    contentView.addSubview(notifHeader)
    notifHeader.snp.makeConstraints { make in
      make.top.equalToSuperview().offset(Spacing.md)
      make.leading.equalToSuperview().offset(Spacing.md)
    }

    let notifCard = UIView()
    notifCard.backgroundColor = .clear
    notifCard.layer.cornerRadius = 16
    notifCard.layer.borderWidth = 1
    notifCard.layer.borderColor = UIColor.white.withAlphaComponent(0.1).cgColor

    contentView.addSubview(notifCard)
    notifCard.snp.makeConstraints { make in
      make.top.equalTo(notifHeader.snp.bottom).offset(Spacing.md)
      make.leading.trailing.equalToSuperview().inset(Spacing.md)
      make.height.equalTo(80)
    }

    contentView.addSubview(dateSelectorCollectionView)
    dateSelectorCollectionView.snp.makeConstraints { make in
      make.top.equalTo(notifCard.snp.bottom).offset(24)
      make.leading.trailing.equalToSuperview()
      make.height.equalTo(80)
    }

    contentView.addSubview(dayHeaderLabel)
    contentView.addSubview(selectedDateLabel)

    dayHeaderLabel.snp.makeConstraints { make in
      make.top.equalTo(dateSelectorCollectionView.snp.bottom).offset(24)
      make.leading.equalToSuperview().offset(Spacing.md)
    }

    selectedDateLabel.snp.makeConstraints { make in
      make.top.equalTo(dayHeaderLabel.snp.bottom).offset(4)
      make.leading.equalTo(dayHeaderLabel)
    }

    contentView.addSubview(timelineTableView)
    timelineTableView.snp.makeConstraints { make in
      make.top.equalTo(selectedDateLabel.snp.bottom).offset(24)
      make.leading.trailing.equalToSuperview()
      make.bottom.equalToSuperview().offset(-Spacing.xl)
      self.timelineTableViewHeightConstraint = make.height.equalTo(0).priority(.low).constraint
    }
  }

  private func setupCollections() {
    dateSelectorCollectionView.delegate = self
    dateSelectorCollectionView.dataSource = self
    dateSelectorCollectionView.register(DateCell.self, forCellWithReuseIdentifier: "DateCell")
    timelineTableView.delegate = self
    timelineTableView.dataSource = self
    timelineTableView.register(TimelineCell.self, forCellReuseIdentifier: "TimelineCell")
  }

  private func setupBindings() {
    viewModel.dates.bind { [weak self] _ in
      DispatchQueue.main.async { self?.dateSelectorCollectionView.reloadData() }
    }

    viewModel.selectedDateText.bind { [weak self] dateText in
      self?.selectedDateLabel.text = dateText
    }

    viewModel.releases.bind { [weak self] states in
      DispatchQueue.main.async {
        switch states {
        case .idle, .loading, .error:
          self?.listSeries = []
          self?.timelineTableView.reloadData()
          self?.updateTableViewHeight()
        case .loaded(let series):
          self?.listSeries = series
          self?.timelineTableView.reloadData()
          self?.updateTableViewHeight()
        case .none: break
        }
      }
    }

    viewModel.favoritesMap.bind { [weak self] map in
      self?.favoritesMap = map ?? [:]
      self?.timelineTableView.reloadData()
    }
  }

  private func updateTableViewHeight() {
    timelineTableView.layoutIfNeeded()
    timelineTableViewHeightConstraint?.update(offset: timelineTableView.contentSize.height)
  }

  private func createSectionLabel(_ title: String) -> UILabel {
    let label = UILabel()
    label.text = title
    label.font = Typography.captionStrong
    label.textColor = Color.primary
    return label
  }
}

extension CalendarViewController: UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
  func collectionView(_ collectionView: UICollectionView,
                      numberOfItemsInSection section: Int) -> Int {
    return viewModel.dates.value?.count ?? 0
  }

  func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
    guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "DateCell",
                                                        for: indexPath) as? DateCell else { return UICollectionViewCell() }
    if let item = viewModel.dates.value?[indexPath.item] {
      cell.configure(day: item.day, date: item.date, isSelected: item.isSelected)
    }
    return cell
  }

  func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
    viewModel.didSelectDate(at: indexPath.item)
  }

  func collectionView(_ collectionView: UICollectionView,
                      layout collectionViewLayout: UICollectionViewLayout,
                      sizeForItemAt indexPath: IndexPath) -> CGSize {
    return CGSize(width: 56, height: 72)
  }
}

extension CalendarViewController: UITableViewDataSource, UITableViewDelegate {
  func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
    return listSeries.count
  }

  func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
    guard let cell = tableView.dequeueReusableCell(withIdentifier: "TimelineCell",
                                                   for: indexPath) as? TimelineCell else { return UITableViewCell() }

    let serie = listSeries[indexPath.row]
    let isFavorite = favoritesMap[serie.id] ?? false
    cell.configure(serie, isFirst: indexPath.row == 0, isFavorite: isFavorite)

    return cell
  }

  func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
    return 150
  }

  func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
    viewModel.didSelectSerie(at: indexPath.row)
  }
}
