//
//  DetailsVC.swift
//  FakeJSONTestTask
//
//  Created by Stanislav Makushov on 19.02.2023.
//

import UIKit

struct DetailsViewModel {
    
    let title: String?
    let firstImage: UIImage
    let secondImage: UIImage
    let thirdImage: UIImage
    let details: String?
}

final class DetailsVC: UIViewController {
    
    var viewModel: DetailsViewModel?
    
    private let descriptionLabel = UILabel()
    private let firstImageView = UIImageView()
    private let secondImageView = UIImageView()
    private let thirdImageView = UIImageView()
    private let scrollView = UIScrollView()
    private let imagesStack = UIStackView()
    
    override func viewDidLoad() {
        setupViews()
        setData()
    }
    
    private func setupViews() {
        addViews()
        setupLayout()
        setupStyle()
    }
    
    private func addViews() {
        view.addSubview(scrollView)
        
        scrollView.addSubviews(
            descriptionLabel,
            imagesStack
        )
        
        imagesStack.addArrangedSubview(firstImageView)
        imagesStack.addArrangedSubview(secondImageView)
        imagesStack.addArrangedSubview(thirdImageView)
    }
    
    private func setupLayout() {
        scrollView.layout(in: self.view)
        
        descriptionLabel.layout {
            $0.leading.equal(to: scrollView.leadingAnchor, offsetBy: 16)
            $0.top.equal(to: scrollView.topAnchor)
            $0.trailing.equal(to: scrollView.trailingAnchor, offsetBy: -16)
        }
        
        imagesStack.layout {
            $0.top.equal(to: descriptionLabel.bottomAnchor, offsetBy: 16)
            $0.leading.equal(to: scrollView.leadingAnchor, offsetBy: 16)
            $0.trailing.equal(to: scrollView.trailingAnchor, offsetBy: -16)
            $0.bottom.equal(to: scrollView.bottomAnchor, offsetBy: -16)
        }
        
        let imageSideSize: CGFloat = (UIScreen.main.bounds.size.width - 48) / 3
        
        [firstImageView, secondImageView, thirdImageView].forEach({ imageView in
            imageView.layout {
                $0.width.equal(to: imageSideSize)
                $0.height.equal(to: imageSideSize)
            }
        })
    }
    
    private func setupStyle() {
        view.backgroundColor = UIColor.white
        
        descriptionLabel.numberOfLines = 0
        descriptionLabel.font = UIFont.systemFont(ofSize: 15)
        
        imagesStack.axis = .horizontal
        imagesStack.spacing = 8
        imagesStack.distribution = .fillEqually
        
        [firstImageView, secondImageView, thirdImageView].forEach({
            $0.contentMode = .scaleAspectFill
            $0.clipsToBounds = true
        })
    }
    
    private func setData() {
        navigationItem.title = viewModel?.title
        
        descriptionLabel.text = viewModel?.details
        firstImageView.image = viewModel?.firstImage
        secondImageView.image = viewModel?.secondImage
        thirdImageView.image = viewModel?.thirdImage
    }
}
