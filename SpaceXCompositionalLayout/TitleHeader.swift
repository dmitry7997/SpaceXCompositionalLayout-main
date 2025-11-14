//
//  TitleHeader.swift
//  SpaceXCompositionalLayout
//

import UIKit

class TitleHeader: UICollectionReusableView {
    
    private let rocketNameLabel: UILabel = {
        let label = UILabel()
        label.textColor = .white
        label.font = .boldSystemFont(ofSize: 28)
        label.numberOfLines = 1
        label.text = "Falcon Heavy"
        return label
    }()
    
    private let gearIcon: UIImageView = {
        let iv = UIImageView(image: UIImage(systemName: "gear"))
        iv.tintColor = .systemGray
        iv.contentMode = .scaleAspectFit
        return iv
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupViews()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func setupViews() {
        addSubview(gearIcon)
        addSubview(rocketNameLabel)
        
        rocketNameLabel.translatesAutoresizingMaskIntoConstraints = false
        gearIcon.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activate([
            rocketNameLabel.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 16),
            rocketNameLabel.centerYAnchor.constraint(equalTo: centerYAnchor),
            
            gearIcon.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -16),
            gearIcon.centerYAnchor.constraint(equalTo: centerYAnchor),
            gearIcon.widthAnchor.constraint(equalToConstant: 30),
            gearIcon.heightAnchor.constraint(equalToConstant: 30)
        ])
    }
    
    func configure(with rocket: Rocket?) {
            if let name = rocket?.name, !name.isEmpty {
                rocketNameLabel.text = name
            } else {
                rocketNameLabel.text = "Rocket"
            }
        }
}
