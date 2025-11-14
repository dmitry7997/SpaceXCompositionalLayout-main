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
    
    func configure(with rocket: Rocket?) {
        guard let imageUrlString = rocket?.flickrImages?.first,
              let imageUrl = URL(string: imageUrlString) else {
            return
        }
        let task = URLSession.shared.dataTask(with: imageUrl) { [weak self] data, response, error in
            
            guard let self else { return }
            
            if let error = error {
                print("\(error.localizedDescription)")
                return
            }
            
            guard let data else {
                print("\(String(describing: error?.localizedDescription))")
                return
            }
            
            if let image = UIImage(data: data) {
                DispatchQueue.main.async {
                    self.imageView.image = image
                }
            } else {
                print("\(String(describing: error?.localizedDescription))")
            }
        }
        task.resume()
    }
}
