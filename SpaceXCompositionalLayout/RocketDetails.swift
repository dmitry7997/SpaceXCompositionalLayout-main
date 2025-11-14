//
//  RocketDetails.swift
//  SpaceXCompositionalLayout
//

import UIKit

class RocketDetails: UICollectionViewCell {
    
    private let mainStackView: UIStackView = {
        let stack = UIStackView()
        stack.axis = .vertical
        stack.spacing = 12
        stack.alignment = .fill
        stack.distribution = .fill
        return stack
    }()
    
    private let firstRocketTitleLabel: UILabel = {
        let label = UILabel()
        label.text = "Первый запуск:"
        label.textColor = .lightGray
        label.font = UIFont.systemFont(ofSize: 14, weight: .regular)
        label.numberOfLines = 1
        label.textAlignment = .left
        return label
    }()
    
    private let firstRocketValueLabel: UILabel = {
        let label = UILabel()
        label.textColor = .white
        label.font = UIFont.systemFont(ofSize: 14, weight: .medium)
        label.numberOfLines = 1
        label.textAlignment = .right
        return label
    }()
    
    private let firstRocketRow: UIStackView = {
        let stack = UIStackView()
        stack.axis = .horizontal
        stack.spacing = 8
        stack.alignment = .center
        stack.distribution = .fillProportionally
        return stack
    }()
    
    private let countryTitleLabel: UILabel = {
        let label = UILabel()
        label.text = "Страна:"
        label.textColor = .lightGray
        label.font = UIFont.systemFont(ofSize: 14, weight: .regular)
        label.numberOfLines = 1
        label.textAlignment = .left
        return label
    }()
    
    private let countryValueLabel: UILabel = {
        let label = UILabel()
        label.textColor = .white
        label.font = UIFont.systemFont(ofSize: 14, weight: .medium)
        label.numberOfLines = 1
        label.textAlignment = .right
        return label
    }()
    
    private let countryRow: UIStackView = {
        let stack = UIStackView()
        stack.axis = .horizontal
        stack.spacing = 8
        stack.alignment = .center
        stack.distribution = .fillProportionally
        return stack
    }()
    
    private let costTitleLabel: UILabel = {
        let label = UILabel()
        label.text = "Стоимость запуска:"
        label.textColor = .lightGray
        label.font = UIFont.systemFont(ofSize: 14, weight: .regular)
        label.numberOfLines = 1
        label.textAlignment = .left
        return label
    }()
    
    private let costValueLabel: UILabel = {
        let label = UILabel()
        label.textColor = .white
        label.font = UIFont.systemFont(ofSize: 14, weight: .medium)
        label.numberOfLines = 1
        label.textAlignment = .right
        return label
    }()
    
    private let costRow: UIStackView = {
        let stack = UIStackView()
        stack.axis = .horizontal
        stack.spacing = 8
        stack.alignment = .center
        stack.distribution = .fillProportionally
        return stack
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupViews()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func setupViews() {
        contentView.layer.cornerRadius = 25
        contentView.clipsToBounds = true
        
        mainStackView.addArrangedSubview(firstRocketRow)
        mainStackView.addArrangedSubview(countryRow)
        mainStackView.addArrangedSubview(costRow)
        
        firstRocketRow.addArrangedSubview(firstRocketTitleLabel)
        firstRocketRow.addArrangedSubview(firstRocketValueLabel)
        
        countryRow.addArrangedSubview(countryTitleLabel)
        countryRow.addArrangedSubview(countryValueLabel)
        
        costRow.addArrangedSubview(costTitleLabel)
        costRow.addArrangedSubview(costValueLabel)
        
        mainStackView.translatesAutoresizingMaskIntoConstraints = false
        firstRocketRow.translatesAutoresizingMaskIntoConstraints = false
        countryRow.translatesAutoresizingMaskIntoConstraints = false
        costRow.translatesAutoresizingMaskIntoConstraints = false
        
        contentView.addSubview(mainStackView)
        
        NSLayoutConstraint.activate([
            mainStackView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 16),
            mainStackView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -16),
            mainStackView.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 12),
            mainStackView.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -12),
            
            firstRocketRow.heightAnchor.constraint(equalToConstant: 20),
            countryRow.heightAnchor.constraint(equalToConstant: 20),
            costRow.heightAnchor.constraint(equalToConstant: 20)
        ])
    }
    
    func configure(with rocket: Rocket?) {
        firstRocketValueLabel.text = rocket?.firstFlight
        countryValueLabel.text = rocket?.country
        costValueLabel.text = String(rocket?.costPerLaunch ?? 0)
    }
}
