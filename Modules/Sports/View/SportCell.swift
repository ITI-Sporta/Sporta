//
//  SportCell.swift
//  Sporta
//
//  Created by Mohamed Ayman on 06/05/2026.
//

import UIKit

class SportCell: UICollectionViewCell {
    
    @IBOutlet weak var containerView: UIView!
    @IBOutlet weak var sportImage: UIImageView!
    @IBOutlet weak var sportTitle: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        setupUI()
    }
    
    private func setupUI() {
        layer.cornerRadius = 12
        clipsToBounds = true
        containerView.layer.cornerRadius = 12
        containerView.clipsToBounds = true
        sportTitle.font = UIFont.systemFont(ofSize: 14, weight: .semibold)
        sportTitle.textAlignment = .center
        sportTitle.numberOfLines = 2
    }
    
    func configure(with sport: Sport) {
        sportTitle.text = sport.displayName
        
        sportImage.image = UIImage(named: sport.imageName)
            ?? UIImage(systemName: sport.sfSymbol)
    }
}
