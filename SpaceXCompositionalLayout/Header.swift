//
//  TableViewHeader.swift
//  SpaceX
//

import UIKit

class Header: UICollectionViewCell {
    
    private let imageView: UIImageView = {
        let iv = UIImageView()
        iv.contentMode = .scaleAspectFit
        iv.tintColor = .label
        iv.clipsToBounds = true
        return iv
    }()
    
    private var imageService: ImageService?
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        addSubview(imageView)
        
        imageView.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activate([
            imageView.topAnchor.constraint(equalTo: topAnchor),
            imageView.leadingAnchor.constraint(equalTo: leadingAnchor),
            imageView.trailingAnchor.constraint(equalTo: trailingAnchor),
            imageView.heightAnchor.constraint(equalToConstant: 250)
        ])
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func configure(with rocket: Rocket?, imageService: ImageService) {
        self.imageService = imageService
        
        guard let imageUrlString = rocket?.flickrImages?.first,
              let imageUrl = URL(string: imageUrlString) else {
            return
        }
        
        imageService.loadImage(from: imageUrl) { [weak self] result in
            guard let self = self else { return }
            
            switch result {
            case .success(let image):
                self.imageView.image = image
            case .failure(let error):
                print("\(String(describing: error.localizedDescription))")
            }
        }
    }
}
