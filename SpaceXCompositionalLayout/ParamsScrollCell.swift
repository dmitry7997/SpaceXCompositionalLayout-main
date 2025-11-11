//
//  ParamsScrollCell.swift
//  SpaceXCompositionalLayout
//

import UIKit

class ParamsScrollCell: UICollectionViewCell {
        
    lazy var titleLabel: UILabel = {
        let titleLabel = UILabel()
        titleLabel.textAlignment = .center
        titleLabel.font = .systemFont(ofSize: 14, weight: .medium)
        titleLabel.textColor = .systemGray
        titleLabel.numberOfLines = 1
        return titleLabel
    }()
    
    lazy var valueLabel: UILabel = {
        let valueLabel = UILabel()
        valueLabel.textColor = .white
        valueLabel.font = .systemFont(ofSize: 16, weight: .semibold)
        valueLabel.textAlignment = .center
        valueLabel.numberOfLines = 1
        return valueLabel
    }()
    
    lazy var stack: UIStackView = {
        let stack = UIStackView()
        stack.axis = .vertical
        stack.spacing = 1
        stack.alignment = .center
        stack.distribution = .fill
        return stack
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        configure()
    }
    
    required init?(coder: NSCoder) {
        fatalError("not implemented")
    }
}

extension ParamsScrollCell {
    func configure() {
        stack.addArrangedSubview(valueLabel)
        stack.addArrangedSubview(titleLabel)
        
        contentView.addSubview(stack)
        stack.translatesAutoresizingMaskIntoConstraints = false
        titleLabel.translatesAutoresizingMaskIntoConstraints = false
        valueLabel.translatesAutoresizingMaskIntoConstraints = false
        
        contentView.backgroundColor = .black
        contentView.layer.cornerRadius = 12
        contentView.layer.masksToBounds = true
        
        NSLayoutConstraint.activate([
            stack.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 16),
            stack.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -16),
            stack.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 8),
            stack.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -8)
        ])
    }
    
    func configure(with value: String, title: String) {
        valueLabel.text = value
        titleLabel.text = title
    }
}
