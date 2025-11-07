//
//  RocketStages.swift
//  SpaceXCompositionalLayout
//

import UIKit

class RocketStages: UICollectionViewCell {
    
    private let titleLabel: UILabel = {
            let label = UILabel()
            label.textColor = .white
            label.textAlignment = .left
            label.text = "ПЕРВАЯ СТУПЕНЬ"
            label.font = .systemFont(ofSize: 22, weight: .bold)
            label.numberOfLines = 1
            return label
        }()
        
        private let detailsStackView: UIStackView = {
            let stack = UIStackView()
            stack.axis = .vertical
            stack.spacing = 8
            stack.distribution = .fill
            stack.alignment = .fill
            return stack
        }()
        
        private let mainStackView: UIStackView = {
            let stack = UIStackView()
            stack.axis = .vertical
            stack.spacing = 12
            stack.alignment = .leading
            return stack
        }()
        
        private let engineLabel: UILabel = {
            let label = UILabel()
            label.text = "Количество двигателей:"
            label.textColor = .lightGray
            label.numberOfLines = 1
            label.textAlignment = .left
            return label
        }()
        
        private let fuelLabel: UILabel = {
            let label = UILabel()
            label.text = "Количество топлива:"
            label.textColor = .lightGray
            label.numberOfLines = 1
            label.textAlignment = .left
            return label
        }()
        
        private let burningTime: UILabel = {
            let label = UILabel()
            label.text = "Время сгорания в секундах:"
            label.textColor = .lightGray
            label.numberOfLines = 1
            label.textAlignment = .left
            return label
        }()
        
        private let engineValueLabel: UILabel = {
            let label = UILabel()
            label.text = "9"
            label.textColor = .white
            label.numberOfLines = 1
            label.textAlignment = .right
            return label
        }()
        
        private let fuelValueLabel: UILabel = {
            let label = UILabel()
            label.text = "385"
            label.textColor = .white
            label.numberOfLines = 1
            label.textAlignment = .right
            return label
        }()
        
        private let burningValueLabel: UILabel = {
            let label = UILabel()
            label.text = "1"
            label.textColor = .white
            label.numberOfLines = 1
            label.textAlignment = .right
            return label
        }()
        
        private let engineRow: UIStackView = {
            let stack = UIStackView()
            stack.axis = .horizontal
            stack.spacing = 8
            stack.alignment = .center
            stack.distribution = .fill
            return stack
        }()
        
        private let fuelRow: UIStackView = {
            let stack = UIStackView()
            stack.axis = .horizontal
            stack.spacing = 8
            stack.alignment = .center
            stack.distribution = .fill
            return stack
        }()
        
        private let burningRow: UIStackView = {
            let stack = UIStackView()
            stack.axis = .horizontal
            stack.spacing = 8
            stack.alignment = .center
            stack.distribution = .fill
            return stack
        }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupUI()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func setupUI() {
        contentView.backgroundColor = .black
        
        engineRow.addArrangedSubview(engineLabel)
        engineRow.addArrangedSubview(engineValueLabel)
        
        fuelRow.addArrangedSubview(fuelLabel)
        fuelRow.addArrangedSubview(fuelValueLabel)
        
        burningRow.addArrangedSubview(burningTime)
        burningRow.addArrangedSubview(burningValueLabel)
        
        detailsStackView.addArrangedSubview(engineRow)
        detailsStackView.addArrangedSubview(fuelRow)
        detailsStackView.addArrangedSubview(burningRow)
        
        mainStackView.addArrangedSubview(titleLabel)
        mainStackView.addArrangedSubview(detailsStackView)
        
        contentView.addSubview(mainStackView)
        
        mainStackView.translatesAutoresizingMaskIntoConstraints = false
        engineRow.translatesAutoresizingMaskIntoConstraints = false
        fuelRow.translatesAutoresizingMaskIntoConstraints = false
        burningRow.translatesAutoresizingMaskIntoConstraints = false
        detailsStackView.translatesAutoresizingMaskIntoConstraints = false
        
        engineLabel.translatesAutoresizingMaskIntoConstraints = false
        engineValueLabel.translatesAutoresizingMaskIntoConstraints = false
        fuelLabel.translatesAutoresizingMaskIntoConstraints = false
        fuelValueLabel.translatesAutoresizingMaskIntoConstraints = false
        burningTime.translatesAutoresizingMaskIntoConstraints = false
        burningValueLabel.translatesAutoresizingMaskIntoConstraints = false

        NSLayoutConstraint.activate([
            mainStackView.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 8),
            mainStackView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 16),
            mainStackView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -16),
            mainStackView.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -8)
        ])
    }
    
    public func configure(with title: String, engine: String, fuel: String, burning: String) {
        titleLabel.text = title
        engineValueLabel.text = engine
        fuelValueLabel.text = fuel
        burningValueLabel.text = burning
    }
}
