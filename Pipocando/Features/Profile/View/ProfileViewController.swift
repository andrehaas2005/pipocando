import UIKit
import SnapKit

final class ProfileViewController: UIViewController {

  private let viewModel: ProfileViewModel
  private var options: [ProfileMenuItem] = []

  private let scrollView = UIScrollView()
  private let contentView = UIView()
  private let loadingView = LoadingView()
  private let errorView = ErrorView()

  private let avatarImageView: UIImageView = {
    let iv = UIImageView()
    iv.contentMode = .scaleAspectFill
    iv.clipsToBounds = true
    iv.layer.cornerRadius = 60
    iv.backgroundColor = Color.surface
    iv.layer.borderWidth = 4
    iv.layer.borderColor = Color.primary.withAlphaComponent(0.2).cgColor
    if #available(iOS 13.0, *) {
      iv.image = UIImage(systemName: "person.fill")
      iv.tintColor = .gray
    }
    return iv
  }()

  private let nameLabel: UILabel = {
    let label = UILabel()
    label.font = UIFont.systemFont(ofSize: 24, weight: .bold)
    label.textColor = .white
    return label
  }()

  private let emailLabel: UILabel = {
    let label = UILabel()
    label.font = UIFont.systemFont(ofSize: 14)
    label.textColor = .gray
    return label
  }()

  private let settingsStackView: UIStackView = {
    let stack = UIStackView()
    stack.axis = .vertical
    stack.spacing = 1
    stack.backgroundColor = UIColor.white.withAlphaComponent(0.05)
    return stack
  }()

  init(viewModel: ProfileViewModel) {
    self.viewModel = viewModel
    super.init(nibName: nil, bundle: nil)
  }

  required init?(coder: NSCoder) {
    fatalError("init(coder:) has not been implemented")
  }

  override func viewDidLoad() {
    super.viewDidLoad()
    view.backgroundColor = Color.backgroundDark
    title = "Perfil"
    setupUI()
    setupBindings()
    viewModel.fetchData()
  }

  private func setupUI() {
    view.addSubview(scrollView)
    scrollView.snp.makeConstraints { make in make.edges.equalToSuperview() }

    scrollView.addSubview(contentView)
    contentView.snp.makeConstraints { make in
      make.edges.width.equalToSuperview()
    }

    contentView.addSubview(avatarImageView)
    contentView.addSubview(nameLabel)
    contentView.addSubview(emailLabel)
    contentView.addSubview(settingsStackView)

    avatarImageView.snp.makeConstraints { make in
      make.top.equalToSuperview().offset(40)
      make.centerX.equalToSuperview()
      make.width.height.equalTo(120)
    }

    nameLabel.snp.makeConstraints { make in
      make.top.equalTo(avatarImageView.snp.bottom).offset(16)
      make.centerX.equalToSuperview()
    }

    emailLabel.snp.makeConstraints { make in
      make.top.equalTo(nameLabel.snp.bottom).offset(4)
      make.centerX.equalToSuperview()
    }

    settingsStackView.snp.makeConstraints { make in
      make.top.equalTo(emailLabel.snp.bottom).offset(40)
      make.leading.trailing.equalToSuperview()
      make.bottom.equalToSuperview().offset(-40)
    }

    view.addSubview(loadingView)
    loadingView.snp.makeConstraints { make in
      make.edges.equalToSuperview()
    }

    view.addSubview(errorView)
    errorView.snp.makeConstraints { make in
      make.edges.equalToSuperview()
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

  private func render(_ state: ProfileState) {
    switch state {
    case .idle:
      loadingView.isHidden = true
      errorView.isHidden = true
      scrollView.isHidden = false
    case .loading:
      loadingView.isHidden = false
      errorView.isHidden = true
      scrollView.isHidden = true
    case .loaded(let name, let email, let options):
      loadingView.isHidden = true
      errorView.isHidden = true
      scrollView.isHidden = false
      nameLabel.text = name
      emailLabel.text = email
      self.options = options
      setupSettings()
    case .error(let error):
      loadingView.isHidden = true
      errorView.isHidden = false
      scrollView.isHidden = true
      errorView.configure(message: error.userMessage)
    }
  }

  private func setupSettings() {
    settingsStackView.arrangedSubviews.forEach { $0.removeFromSuperview() }

    for option in options {
      let row = createSettingRow(option: option)
      settingsStackView.addArrangedSubview(row)
    }
  }

  private func createSettingRow(option: ProfileMenuItem) -> UIView {
    let row = UIView()
    row.backgroundColor = Color.backgroundDark

    let iconView = UIImageView()
    if #available(iOS 13.0, *) {
      iconView.image = UIImage(systemName: option.icon)
    }
    iconView.tintColor = option.isDestructive ? .systemRed : .white
    iconView.contentMode = .scaleAspectFit

    let label = UILabel()
    label.text = option.title
    label.textColor = option.isDestructive ? .systemRed : .white
    label.font = UIFont.systemFont(ofSize: 16)

    let chevron = UIImageView()
    if #available(iOS 13.0, *) {
      chevron.image = UIImage(systemName: "chevron.right")
    }
    chevron.tintColor = .gray
    chevron.contentMode = .scaleAspectFit

    row.addSubview(iconView)
    row.addSubview(label)
    row.addSubview(chevron)

    row.snp.makeConstraints { make in make.height.equalTo(60) }

    iconView.snp.makeConstraints { make in
      make.leading.equalToSuperview().offset(20)
      make.centerY.equalToSuperview()
      make.width.height.equalTo(24)
    }

    label.snp.makeConstraints { make in
      make.leading.equalTo(iconView.snp.trailing).offset(16)
      make.centerY.equalToSuperview()
    }

    chevron.snp.makeConstraints { make in
      make.trailing.equalToSuperview().offset(-20)
      make.centerY.equalToSuperview()
      make.width.height.equalTo(16)
    }

    row.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(didTapRow(_:))))
    row.tag = options.firstIndex(where: { $0.title == option.title }) ?? 0

    return row
  }

  @objc private func didTapRow(_ gesture: UITapGestureRecognizer) {
    guard let row = gesture.view,
          options.indices.contains(row.tag) else { return }
    viewModel.didSelectMenuItem(options[row.tag])
  }
}
