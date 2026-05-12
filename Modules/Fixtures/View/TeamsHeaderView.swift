//
//  File.swift
//  Sporta
//
//  Created by Mohamed Ayman on 10/05/2026.
//

import UIKit

class TeamsHeaderView: UICollectionReusableView {
    
    private let titleLabel: UILabel = {
        let label = UILabel()
        label.text      = "Teams"
        label.font      = UIFont.systemFont(ofSize: 18, weight: .bold)
        label.textColor = UIColor(red: 0.078, green: 0.156, blue: 0.313, alpha: 1.0)
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        backgroundColor = .clear
        addSubview(titleLabel)
        NSLayoutConstraint.activate([
            titleLabel.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 6),
            titleLabel.centerYAnchor.constraint(equalTo: centerYAnchor)
        ])
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func setText(_ text: String) {
        titleLabel.text = text
    }
}
