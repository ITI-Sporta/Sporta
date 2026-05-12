//
//  PlayerCell.swift
//  Sporta
//
//  Created by Hossam on 12/05/2026.
//

import UIKit

class PlayerCell: UICollectionViewCell {

    @IBOutlet weak var cardView: UIView!
    @IBOutlet weak var playerImageV: UIImageView!
    @IBOutlet weak var playerNameLabel: UILabel!
    @IBOutlet weak var playerNumberLabel: UILabel!
    override func awakeFromNib() {
        super.awakeFromNib()
        setupCardStyle()
    }
    
    private func setupCardStyle() {
        cardView.layer.cornerRadius  = 12
        cardView.layer.shadowColor   = UIColor.black.cgColor
        cardView.layer.shadowOpacity = 0.1
        cardView.layer.shadowOffset  = CGSize(width: 0, height: 2)
        cardView.layer.shadowRadius  = 4
        cardView.layer.masksToBounds = false
        contentView.backgroundColor  = .clear
        backgroundColor              = .clear
    }

    func configure(with player: Player) {

        playerImageV.setImage(player.image ?? "")
        playerNameLabel.text = player.name ?? "-"
        playerNumberLabel.text = player.number ?? "-"

    }
}
