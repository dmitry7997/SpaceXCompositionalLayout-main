//
//  LaunchViewController.swift
//  SpaceXCompositionalLayout
//
//  Created by Not Null on 08.12.2025.
//

import UIKit

class LaunchViewController: UIViewController {

    private let service: LaunchService
    private let launchViewModel: LaunchViewModel
    private var launches: [Launch] = []

    let tableView: UITableView = {
        let table = UITableView()
        table.register(LaunchTableViewCell.self, forCellReuseIdentifier: LaunchTableViewCell.identifier)
        return table
    }()
    
    init(service: LaunchService = LaunchService(), launchViewModel: LaunchViewModel = LaunchViewModel(service: LaunchService())) {
        self.service = service
        self.launchViewModel = launchViewModel
        super.init(nibName: nil, bundle: nil)
    }
    
    convenience override init(nibName nibNameOrNil: String?, bundle nibBundleOrNil: Bundle?) {
        self.init(service: LaunchService(), launchViewModel: LaunchViewModel(service: LaunchService()))
    }
    
    required init?(coder: NSCoder) {
        self.service = LaunchService()
        self.launchViewModel = LaunchViewModel(service: LaunchService())
        super.init(coder: coder)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.dataSource = self
        tableView.delegate = self
        setupUI()
        tableView.backgroundColor = .black

        loadLaunches()
    }
    
    private func loadLaunches() {
        launchViewModel.loadLaunches { [weak self] result in
            switch result {
            case .success(let launches):
                self?.launches = launches
                DispatchQueue.main.async {
                    self?.tableView.reloadData()
               }
            case .failure(let error):
                print("Loading error: \(error.localizedDescription)")
            }
        }
    }

    private func setupUI() {
        view.addSubview(tableView)
        tableView.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activate([
            tableView.topAnchor.constraint(equalTo: view.topAnchor),
            tableView.bottomAnchor.constraint(equalTo: view.bottomAnchor),
            tableView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            tableView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
        ])
    }
}

extension LaunchViewController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return launches.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(
            withIdentifier: LaunchTableViewCell.identifier,
            for: indexPath
        ) as? LaunchTableViewCell else {
            fatalError("The TableView could not dequeue a LaunchTableViewCell")
        }
        let launch = launches[indexPath.row]
        cell.configure(with: launch)
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
    }
}
