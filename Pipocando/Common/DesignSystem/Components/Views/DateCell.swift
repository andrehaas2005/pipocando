//
//  DateCell.swift
//  Pipocando
//
//  Created by Andre  Haas on 19/02/26.
//
import UIKit
import SnapKit

class DateCell: UICollectionViewCell {
    private let dayLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.systemFont(ofSize: 10, weight: .bold)
        label.textAlignment = .center
        return label
    }()

    private let dateLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.systemFont(ofSize: 16, weight: .bold)
        label.textAlignment = .center
        return label
    }()

    override init(frame: CGRect) {
        super.init(frame: frame)
        contentView.layer.cornerRadius = 12
        contentView.addSubview(dayLabel)
        contentView.addSubview(dateLabel)
        dayLabel.snp.makeConstraints { make in
            make.top.equalToSuperview().offset(12)
            make.leading.trailing.equalToSuperview()
        }
        dateLabel.snp.makeConstraints { make in
            make.top.equalTo(dayLabel.snp.bottom).offset(4)
            make.leading.trailing.equalToSuperview()
        }
    }

    required init?(coder: NSCoder) { fatalError() }

    func configure(day: String, date: String, isSelected: Bool) {
        dayLabel.text = day
        dateLabel.text = date
        contentView.backgroundColor = isSelected ? Color.primary : Color.surface.withAlphaComponent(0.4)
        dayLabel.textColor = isSelected ? .white.withAlphaComponent(0.8) : .gray
        dateLabel.textColor = isSelected ? .white : .white
    }
}
