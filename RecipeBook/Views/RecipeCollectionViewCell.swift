//
//  RecipeCollectionViewCell.swift
//  RecipeBook
//
//  Created by AVISHKA RAVISHAN on 2023-06-18.
//

import Foundation
import UIKit

class RecipeCollectionViewCell: UICollectionViewCell {
    static let reuseIdentifier = "RecipeCell"
    
    private let titleLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.font = UIFont.systemFont(ofSize: 16, weight: .bold)
        label.textColor = .black
        return label
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupViews()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func setupViews() {
        // Add and configure subviews
        addSubview(titleLabel)
        
        // Add constraints
        NSLayoutConstraint.activate([
            titleLabel.topAnchor.constraint(equalTo: topAnchor, constant: 8),
            titleLabel.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 8),
            titleLabel.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -8),
            titleLabel.bottomAnchor.constraint(equalTo: bottomAnchor, constant: -8)
        ])
    }
    
    func configure(with recipe: Recipe) {
        titleLabel.text = recipe.title
        // Configure other UI elements with recipe data as needed
    }
}
