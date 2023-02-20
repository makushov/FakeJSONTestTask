//
//  ViewController.swift
//  FakeJSONTestTask
//
//  Created by Stanislav Makushov on 19.02.2023.
//

import UIKit

final class ViewController: UIViewController {
    
    private let dataService: DataServiceProtocol = DataService()
    private let fakeJSONService: FakeJSONServiceProtocol = FakeJSONService()
    private let imageService: RemoteImageServiceProtocol = RemoteImageService()
    
    private let tableView = UITableView()
    private let activityIndicator = UIActivityIndicatorView(style: .large)
    
    private var items = [DataItem]()
    
    private var selectedIndex: Int? = nil

    override func viewDidLoad() {
        super.viewDidLoad()
        setupViews()
        setupTableView()
        loadData()
    }
    
    private func setupTableView() {
        tableView.delegate = self
        tableView.dataSource = self
        tableView.tableFooterView = UIView(frame: .zero)
        tableView.rowHeight = UITableView.automaticDimension
        tableView.registerReusableCell(ItemCell.self)
    }
    
    private func setupViews() {
        addViews()
        setupLayout()
        setupStyle()
    }
    
    private func addViews() {
        view.addSubviews(
            tableView,
            activityIndicator
        )
    }
    
    private func setupLayout() {
        tableView.layout(in: view)
        activityIndicator.layout {
            $0.centerX.equal(to: view.centerXAnchor)
            $0.centerY.equal(to: view.centerYAnchor)
        }
    }
    
    private func setupStyle() {
        activityIndicator.hidesWhenStopped = true
        activityIndicator.color = .black
    }
    
    private func startLoadingAnimation() {
        tableView.isHidden = true
        activityIndicator.startAnimating()
    }
    
    private func stopLoadingAnimation() {
        activityIndicator.stopAnimating()
        tableView.isHidden = false
    }
    
    private func loadData() {
        startLoadingAnimation()
        
        DispatchQueue.global().async { [weak self] in
            let rawData = self?.dataService.loadData()
            
            if let rawData = rawData {
                self?.items = self?.fakeJSONService.parseFakeJSONData(rawData).compactMap({ DataItem(from: $0) }) ?? []
            }
            
            DispatchQueue.main.async {
                self?.stopLoadingAnimation()
                self?.tableView.reloadData()
            }
        }
    }
    
    private func openDetails() {
        guard let selectedIndex = selectedIndex else {
            return
        }
        
        var firstImage: UIImage?
        var secondImage: UIImage?
        var thirdImage: UIImage?
        
        let dispatchGroup = DispatchGroup()
        
        var errors: [Error] = []
        
        if let firstImageUrl = items[selectedIndex].firstImageUrl {
            dispatchGroup.enter()
            imageService.image(for: firstImageUrl) { result in
                switch result {
                case .success(let image): firstImage = image
                case .failure(let error): errors.append(error)
                }
                
                dispatchGroup.leave()
            }
        }
        
        if let secondImageUrl = items[selectedIndex].secondImageUrl {
            dispatchGroup.enter()
            imageService.image(for: secondImageUrl) { result in
                switch result {
                case .success(let image): secondImage = image
                case .failure(let error): errors.append(error)
                }
                
                dispatchGroup.leave()
            }
        }
        
        if let thirdImageUrl = items[selectedIndex].thirdImageUrl {
            dispatchGroup.enter()
            imageService.image(for: thirdImageUrl) { result in
                switch result {
                case .success(let image): thirdImage = image
                case .failure(let error): errors.append(error)
                }
                
                dispatchGroup.leave()
            }
        }
        
        dispatchGroup.notify(queue: .main, execute: { [weak self] in
            guard errors.isEmpty else {
                self?.selectedIndex = nil
                self?.tableView.reloadData()
                
                self?.present(
                    UIAlertController.error(
                        text: errors.first?.localizedDescription ?? "",
                        continueAction: {}),
                    animated: true
                )
                
                return
            }
            
            guard let firstImage = firstImage, let secondImage = secondImage, let thirdImage = thirdImage else {
                self?.selectedIndex = nil
                self?.tableView.reloadData()
                
                self?.present(
                    UIAlertController.error(
                        text: "Error loading one or more images",
                        continueAction: {}),
                    animated: true
                )
                
                return
            }
            
            let detailsVC = DetailsVC()
            detailsVC.viewModel = DetailsViewModel(
                title: self?.items[selectedIndex].title,
                firstImage: firstImage,
                secondImage: secondImage,
                thirdImage: thirdImage,
                details: self?.items[selectedIndex].details
            )
            
            self?.navigationController?.pushViewController(detailsVC, animated: true)
            
            self?.selectedIndex = nil
            self?.tableView.reloadData()
        })
    }
}

extension ViewController: UITableViewDataSource {
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return items.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell: ItemCell = tableView.dequeueReusableCell(indexPath)
        
        cell.titleLabel.text = items[indexPath.row].title
        cell.descriptionLabel.text = items[indexPath.row].details
        
        cell.isAnimating = selectedIndex != nil && selectedIndex == indexPath.row
        
        return cell
    }
}

extension ViewController: UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        
        if selectedIndex == nil {
            selectedIndex = indexPath.row
            tableView.reloadData()
            
            openDetails()
        }
    }
}
