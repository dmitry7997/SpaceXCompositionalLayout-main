//
//  ViewController.swift
//  SpaceXCompositionalLayout
//

import UIKit

class ViewController: UIViewController, UICollectionViewDelegate {
    
    enum Section {
        case header
        case title //  для названия и настроек
        case carousel // для горизонтального скрола
        case info // for info
        case stage // для ступеней
        case footer
    }
    
    var dataSource: UICollectionViewDiffableDataSource<Section, Int>! = nil
    var collectionView: UICollectionView! = nil
    
    let params: [(value: String, title: String)] = [
        ("229", "Высота"),
        ("39.9", "Диаметр"),
        ("1,322,575", "Масса"),
        ("100", "Leo")
    ]
    
    let rocketParams: [(value: String, title: String)] = [
        ("7 февраля 2018", "Первый запуск"),
        ("США", "Страна"),
        ("$90 млн", "Стоимость запуска")
    ]
    
    let stagesParams: [(title: String, engine: String, fuel: String, burning: String)] = [
        (
            title: "ПЕРВАЯ СТУПЕНЬ",
            engine: "9",
            fuel: "385",
            burning: "1"
        ),
        (
            title: "ВТОРАЯ СТУПЕНЬ",
            engine: "1",
            fuel: "107",
            burning: "397"
        )
    ]
    
    override func viewDidLoad() {
        super.viewDidLoad()
        configureHierarchy()
        configureDataSource()
    }
    
    func configureHierarchy() {
        collectionView = UICollectionView(frame: view.bounds, collectionViewLayout: createLayout())
        collectionView.autoresizingMask = [.flexibleWidth, .flexibleHeight]
        collectionView.backgroundColor = .black
        
        view.addSubview(collectionView)
        
        collectionView.delegate = self
    }
    
    func configureDataSource() { // здесь регаем разные типы ячеек для разных секций
        
        let carouselCount = params.count
        let infoCount = rocketParams.count
        let stageCount = stagesParams.count
        
        let headerRegistration = UICollectionView.SupplementaryRegistration<Header>(elementKind: UICollectionView.elementKindSectionHeader) { (headerView, _, indexPath) in
            headerView.configure(with: "falconHeavyImage")
        }
        
        let titleRegistration = UICollectionView.SupplementaryRegistration<TitleHeader>(elementKind: UICollectionView.elementKindSectionHeader) { (titleView, _, indexPath) in
            titleView.configure(with: "Falcon Heavy", gearImage: "gearIcon")
        }

        let carouselRegistration = UICollectionView.CellRegistration<ParamsScrollCell, Int> { (cell, indexPath, identifier) in
            cell.contentView.backgroundColor = .darkGray
            cell.contentView.layer.cornerRadius = 25
            cell.contentView.layer.masksToBounds = true
            cell.configure(with: self.params[identifier].value, title: self.params[identifier].title)
        }
        
        let rocketDetailsRegistration = UICollectionView.CellRegistration<RocketDetails, Int> { [weak self] (cell, indexPath, identifier) in
            guard let self = self else { return }
            
            cell.configure(
                firstLaunch: self.rocketParams[0].value,
                country: self.rocketParams[1].value,
                cost: self.rocketParams[2].value
            )
        }
        
        let stagesRegistration = UICollectionView.CellRegistration<RocketStages, Int> { [weak self] (cell, indexPath, identifier) in
            guard let self = self else { return }
            
            let index = identifier - carouselCount - infoCount
            let params = self.stagesParams[index]
            cell.configure(
                with: params.title,
                engine: params.engine,
                fuel: params.fuel,
                burning: params.burning
            )
        }
        
        let footerRegistration = UICollectionView.SupplementaryRegistration<Footer>(elementKind: UICollectionView.elementKindSectionHeader) { (footerView, _, indexPath) in
            footerView.configure()
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
        
        // здесь добавляем секции
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
}
