//
//  TableViewFooter.swift
//  SpaceX
//

import UIKit

class Footer: UICollectionViewCell {
    
    private let pageControl: UIPageControl = {
        let pc = UIPageControl()
        pc.numberOfPages = 4
        pc.currentPage = 0
        pc.currentPageIndicatorTintColor = .white
        pc.pageIndicatorTintColor = .systemGray4
        return pc
    }()
    
    private let button: UIButton = {
        let button = UIButton()
        button.setTitle("Посмотреть запуски", for: .normal)
        button.backgroundColor = .darkGray
        button.setTitleColor(.white, for: .normal)
        button.titleLabel?.font = .systemFont(ofSize: 16, weight: .semibold)
        button.layer.cornerRadius = 12
        return button
    }()
    
    var currentPage: Int = 0 {
        didSet {
            pageControl.currentPage = currentPage
        }
    }
    
    var totalPages: Int = 4 {
        didSet {
            pageControl.numberOfPages = totalPages
        }
    }
    
    var onPageChange: ((Int) -> Void)?
    var onButtonTap: (() -> Void)?
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupViews()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func setupViews() {
        addSubview(button)
        addSubview(pageControl)
        
        pageControl.translatesAutoresizingMaskIntoConstraints = false
        button.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activate([
            button.topAnchor.constraint(equalTo: topAnchor, constant: 16),
            button.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 20),
            button.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -20),
            button.heightAnchor.constraint(equalToConstant: 44),
            
            pageControl.topAnchor.constraint(equalTo: button.bottomAnchor, constant: 20),
            pageControl.bottomAnchor.constraint(equalTo: bottomAnchor, constant: -12),
            pageControl.centerXAnchor.constraint(equalTo: centerXAnchor),
            pageControl.heightAnchor.constraint(equalToConstant: 20)
        ])
        
        self.backgroundColor = .black
        
        button.addTarget(self, action: #selector(buttonTapped), for: .touchUpInside)
    }
    
    func configure(currentPage: Int, totalPages: Int, onPageChange: @escaping (Int) -> Void, onButtonTap: @escaping () -> Void) {
        self.currentPage = currentPage
        self.totalPages = totalPages
        self.onPageChange = onPageChange
        self.onButtonTap = onButtonTap
    }
    
    @objc private func pageControlChanged(_ sender: UIPageControl) {
        onPageChange?(sender.currentPage)
    }
    
    @objc private func buttonTapped() {
        onButtonTap?()
    }
}
