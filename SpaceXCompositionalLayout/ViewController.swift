//
//  ViewController.swift
//  SpaceXCompositionalLayout
//

import UIKit

class ViewController: UIViewController, UICollectionViewDelegate {
    
    enum Section {
        case header
        case title
        case carousel
        case info
        case stage
        case footer
    }
    
    private let service: RocketService
    private let imageService: ImageService
    private let rocketViewModel: RocketViewModel
    
    init(rocketService: RocketService, imageService: ImageService, rocketViewModel: RocketViewModel) {
        self.imageService = imageService
        self.service = rocketService
        self.rocketViewModel = rocketViewModel
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        self.imageService = ImageService()
        self.service = RocketService()
        self.rocketViewModel = RocketViewModel(service: service)
        super.init(coder: coder)
    }
    
    private var rockets: [Rocket] = []
    
    var dataSource: UICollectionViewDiffableDataSource<Section, Int>! = nil
    var collectionView: UICollectionView! = nil
    
    override func viewDidLoad() {
        super.viewDidLoad()
        configureHierarchy()
        configureDataSource()
        
        rocketViewModel.loadRockets { [weak self] result in
            guard let self = self else { return }
            
            DispatchQueue.main.async {
                switch result {
                case .success:
                    self.configureDataSource()
                    
                case .failure(let error):
                    print("\(error.localizedDescription)")
                }
            }
        }
        
        let swipeLeft = UISwipeGestureRecognizer(target: self, action: #selector(swipeToNextRocket))
        swipeLeft.direction = .left
        collectionView.addGestureRecognizer(swipeLeft)

        let swipeRight = UISwipeGestureRecognizer(target: self, action: #selector(swipeToPreviousRocket))
        swipeRight.direction = .right
        collectionView.addGestureRecognizer(swipeRight)
    }
    
    func configureHierarchy() {
        collectionView = UICollectionView(frame: view.bounds, collectionViewLayout: createLayout())
        collectionView.autoresizingMask = [.flexibleWidth, .flexibleHeight]
        collectionView.backgroundColor = .black
        
        view.addSubview(collectionView)
        
        collectionView.delegate = self
    }
    
    func configureDataSource() {
        let rocket = rocketViewModel.currentRocket

        let carouselCount = 4
        let infoCount = 3
        let stageCount = 2
        
        let headerRegistration = UICollectionView.SupplementaryRegistration<Header>(elementKind: UICollectionView.elementKindSectionHeader) { (headerView, _, indexPath) in
            headerView.configure(with: rocket, imageService: self.imageService)
            headerView.isHidden = false
        }
        
        let titleRegistration = UICollectionView.SupplementaryRegistration<TitleHeader>(elementKind: UICollectionView.elementKindSectionHeader) { (titleView, _, indexPath) in
            titleView.configure(with: rocket)
            titleView.isHidden = false
        }
        
        let carouselRegistration = UICollectionView.CellRegistration<ParamsScrollCell, Int> { (cell, indexPath, identifier) in
            cell.contentView.backgroundColor = .darkGray
            cell.contentView.layer.cornerRadius = 25
            cell.contentView.layer.masksToBounds = true
            
            let data = self.rocketViewModel.carouselData
            if indexPath.item < data.count {
                let itemData = data[indexPath.item]
                cell.configure(with: itemData.value, title: itemData.title)
            }
            cell.isHidden = false
        }
        
        let rocketDetailsRegistration = UICollectionView.CellRegistration<RocketDetails, Int> {
            (cell, indexPath, identifier) in
            cell.configure(with: rocket)
            cell.isHidden = false
        }
        
        let stagesRegistration = UICollectionView.CellRegistration<RocketStages, Int> { (cell, indexPath, identifier) in
            let data = self.rocketViewModel.stageData
            if indexPath.item < data.count {
                let itemData = data[indexPath.item]
                cell.configure(with: itemData.stage, stageType: itemData.title)
            }
            cell.isHidden = false
        }
        
        let footerRegistration = UICollectionView.SupplementaryRegistration<Footer>(elementKind: UICollectionView.elementKindSectionHeader) { (footerView, _, indexPath) in
            
            footerView.configure(
                currentPage: self.rocketViewModel.currentPage,
                totalPages: self.rocketViewModel.totalRockets,
                onPageChange: { [weak self] newPage in
                    self?.rocketViewModel.selectRocket(at: newPage)
                    self?.configureDataSource()
                }
            )
        }
        
        dataSource = UICollectionViewDiffableDataSource<Section, Int>(collectionView: collectionView) { collectionView, indexPath, itemID in
            let section = self.dataSource.snapshot().sectionIdentifiers[indexPath.section]
            switch section {
            case .header, .title, .footer:
                return nil
            case .carousel:
                return collectionView.dequeueConfiguredReusableCell(using: carouselRegistration, for: indexPath, item: itemID)
            case .info:
                return collectionView.dequeueConfiguredReusableCell(using: rocketDetailsRegistration, for: indexPath, item: itemID)
            case .stage:
                return collectionView.dequeueConfiguredReusableCell(using: stagesRegistration, for: indexPath, item: itemID)
            }
        }
        
        dataSource.supplementaryViewProvider = { collectionView, kind, indexPath in
            if kind == UICollectionView.elementKindSectionHeader {
                let section = self.dataSource.snapshot().sectionIdentifiers[indexPath.section]
                switch section {
                case .header:
                    return collectionView.dequeueConfiguredReusableSupplementary(using: headerRegistration, for: indexPath)
                case .title:
                    return collectionView.dequeueConfiguredReusableSupplementary(using: titleRegistration, for: indexPath)
                case .carousel:
                    return nil
                case .info:
                    return nil
                case .stage:
                    return nil
                case .footer:
                    return collectionView.dequeueConfiguredReusableSupplementary(using: footerRegistration, for: indexPath)
                }
            }
            return nil
        }
        
        var snapshot = NSDiffableDataSourceSnapshot<Section, Int>()
        snapshot.appendSections([.header, .title, .carousel, .info, .stage, .footer])
        
        let carouselItems: [Int] = Array(0..<carouselCount)
        snapshot.appendItems(carouselItems, toSection: .carousel)
        
        let infoItems: [Int] = Array(6..<carouselCount + infoCount) // этот "костыль" из "6" нужно как-то пофиксить
        snapshot.appendItems(infoItems, toSection: .info)
        
        let stageItems: [Int] = Array(carouselCount + infoCount..<carouselCount + infoCount + stageCount)
        snapshot.appendItems(stageItems,toSection: .stage)
        
        dataSource.apply(snapshot)
    }
    
    func createLayout() -> UICollectionViewLayout {
        let layout = UICollectionViewCompositionalLayout {
            (sectionIndex: Int, layoutEnvironment: NSCollectionLayoutEnvironment) -> NSCollectionLayoutSection? in
            let section = self.dataSource.snapshot().sectionIdentifiers[sectionIndex]
            
            switch section {
            case .header:
                let invisibleItem = NSCollectionLayoutItem(layoutSize: NSCollectionLayoutSize(widthDimension: .absolute(0), heightDimension: .absolute(0)))
                let group = NSCollectionLayoutGroup.vertical(layoutSize: NSCollectionLayoutSize(widthDimension: .fractionalWidth(1.0), heightDimension: .estimated(300)), subitems: [invisibleItem])
                let section = NSCollectionLayoutSection(group: group)
                
                let headerSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(1.0), heightDimension: .estimated(300))
                let headerItem = NSCollectionLayoutBoundarySupplementaryItem(layoutSize: headerSize, elementKind: UICollectionView.elementKindSectionHeader, alignment: .top)
                section.boundarySupplementaryItems = [headerItem]
                
                return section
                
            case .title:
                let invisibleItem = NSCollectionLayoutItem(layoutSize: NSCollectionLayoutSize(widthDimension: .absolute(0), heightDimension: .absolute(0))) // невидимый чтобы избежать ошибки (пока без сетевого слоя)
                let group = NSCollectionLayoutGroup.vertical(layoutSize: NSCollectionLayoutSize(widthDimension: .fractionalWidth(1.0), heightDimension: .estimated(60)), subitems: [invisibleItem])
                let section = NSCollectionLayoutSection(group: group)
                
                let titleSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(1.0), heightDimension: .estimated(60))
                let titleItem = NSCollectionLayoutBoundarySupplementaryItem(layoutSize: titleSize, elementKind: UICollectionView.elementKindSectionHeader, alignment: .top)
                section.boundarySupplementaryItems = [titleItem]
                
                section.contentInsets = NSDirectionalEdgeInsets(top: 0, leading: 0, bottom: 16, trailing: 0)
                return section
                
            case .carousel:
                let item = NSCollectionLayoutItem(layoutSize: NSCollectionLayoutSize(widthDimension: .fractionalWidth(1.0), heightDimension: .fractionalHeight(1.0)))
                item.contentInsets = NSDirectionalEdgeInsets(top: 5, leading: 5, bottom: 5, trailing: 5)
                
                let group = NSCollectionLayoutGroup.horizontal(layoutSize: NSCollectionLayoutSize(widthDimension: .fractionalWidth(0.25), heightDimension: .fractionalHeight(0.10)), subitems: [item])
                
                let section = NSCollectionLayoutSection(group: group)
                section.orthogonalScrollingBehavior = .continuous
                section.interGroupSpacing = 12
                return section
                
            case .info:
                let item = NSCollectionLayoutItem(layoutSize: NSCollectionLayoutSize(widthDimension: .fractionalWidth(1.0), heightDimension: .fractionalHeight(1.0)))
                item.contentInsets = NSDirectionalEdgeInsets(top: 8, leading: 16, bottom: 8, trailing: 16)
                
                let group = NSCollectionLayoutGroup.vertical(layoutSize: NSCollectionLayoutSize(widthDimension: .fractionalWidth(1.0), heightDimension: .absolute(120)), subitems: [item])
                
                let section = NSCollectionLayoutSection(group: group)
                return section
            
            case .stage:
                let item = NSCollectionLayoutItem(layoutSize: NSCollectionLayoutSize(widthDimension: .fractionalWidth(1.0), heightDimension: .fractionalHeight(1.0)))
                item.contentInsets = NSDirectionalEdgeInsets(top: 8, leading: 16, bottom: 8, trailing: 16)
                
                let group = NSCollectionLayoutGroup.vertical(layoutSize: NSCollectionLayoutSize(widthDimension: .fractionalWidth(1.0), heightDimension: .absolute(120)), subitems: [item])
                
                let section = NSCollectionLayoutSection(group: group)
                return section
            
            case .footer:
                let invisibleItem = NSCollectionLayoutItem(layoutSize: NSCollectionLayoutSize(widthDimension: .absolute(0), heightDimension: .absolute(0)))
                let group = NSCollectionLayoutGroup.vertical(layoutSize: NSCollectionLayoutSize(widthDimension: .fractionalWidth(1.0), heightDimension: .estimated(80)), subitems: [invisibleItem])
                let section = NSCollectionLayoutSection(group: group)
                
                let footerSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(1.0), heightDimension: .estimated(80))
                
                let footerItem = NSCollectionLayoutBoundarySupplementaryItem(layoutSize: footerSize, elementKind: UICollectionView.elementKindSectionHeader, alignment: .top)
                section.boundarySupplementaryItems = [footerItem]
                
                return section
            }
        }
        return layout
    }
    
    @objc func swipeToNextRocket() {
        rocketViewModel.selectNextRocket()
        configureDataSource()
    }
    
    @objc func swipeToPreviousRocket() {
        rocketViewModel.selectPreviousRocket()
        configureDataSource()
    }
}
