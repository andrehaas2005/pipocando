//
//  TimelineCell.swift
//  Pipocando
//
//  Created by Andre  Haas on 14/02/26.
//

import UIKit
import SnapKit

class TimelineCell: UITableViewCell {
  private let timeLabel: UILabel = {
    let label = UILabel()
    label.font = UIFont.systemFont(ofSize: 12, weight: .medium)
    label.textColor = .gray
    return label
  }()
  
  private let chapterView: ChapterView = {
    let view = ChapterView()
    return view
  }()
  
  private let dotView: UIView = {
    let view = UIView()
    view.layer.cornerRadius = 18
    view.backgroundColor = .darkGray
    return view
  }()
  
  private let lineView: UIView = {
    let view = UIView()
    view.backgroundColor = UIColor.white.withAlphaComponent(0.1)
    return view
  }()
  
  private let cardView: UIView = {
    let view = UIView()
    view.backgroundColor = Color.surface.withAlphaComponent(0.4)
    view.layer.cornerRadius = 16
    view.layer.borderWidth = 1
    view.layer.borderColor = UIColor.white.withAlphaComponent(0.1).cgColor
    return view
  }()
  
  
  
  override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
    super.init(style: style, reuseIdentifier: reuseIdentifier)
    backgroundColor = .clear
    selectionStyle = .none
    setupUI()
  }
  
  required init?(coder: NSCoder) { fatalError() }
  
  private func setupUI() {
    contentView.addSubview(lineView)
    contentView.addSubview(dotView)
    contentView.addSubview(timeLabel)
    cardView.addSubview(chapterView)
    contentView.addSubview(cardView)
    
    
    
    dotView.snp.makeConstraints { make in
      make.top.equalToSuperview().offset(8)
      make.leading.equalToSuperview().offset(16)
      make.width.height.equalTo(36)
    }
    
    lineView.snp.makeConstraints { make in
      make.centerX.equalTo(dotView)
      make.top.bottom.equalToSuperview()
      make.width.equalTo(2)
    }
    
    timeLabel.snp.makeConstraints { make in
      make.top.equalTo(dotView).offset(8)
      make.leading.equalTo(dotView.snp.trailing).offset(16)
    }
    
    cardView.snp.makeConstraints { make in
      make.top.equalTo(timeLabel.snp.bottom).offset(12)
      make.leading.equalTo(timeLabel)
      make.trailing.equalToSuperview().offset(-16)
      make.bottom.equalToSuperview().offset(-24)
    }
    
    chapterView.snp.makeConstraints { make in
      make.edges.equalToSuperview()
    }
  }
  
  func configure(_ serie: Serie, isFirst: Bool) {
    chapterView.configure(with: serie)
    timeLabel.text = "timeLabel"
    if isFirst {
      dotView.backgroundColor = Color.primary
      if #available(iOS 13.0, *) {
        let icon = UIImageView(image: UIImage(systemName: "bell.fill"))
        icon.tintColor = .white
        dotView.addSubview(icon)
        icon.snp.makeConstraints { make in make.center.equalToSuperview(); make.width.height.equalTo(18) }
      }
    }
  }
}
