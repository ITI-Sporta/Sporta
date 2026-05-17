//
//  PlayerCell.swift
//  Sporta
//
//  Created by Hossam on 12/05/2026.
//

import UIKit

class PlayerCell: UICollectionViewCell {

    // MARK: - Outlets
    @IBOutlet weak var cardView: UIView!
    @IBOutlet weak var playerImageV: UIImageView!
    @IBOutlet weak var playerNameLabel: UILabel!
    @IBOutlet weak var playerNumberLabel: UILabel!
    @IBOutlet weak var posBadge: UIView!
    @IBOutlet weak var lblPosText: UILabel!
    @IBOutlet weak var lblAge: UILabel!
    @IBOutlet weak var numBadge: UIView!
    
    // MARK: - Lifecycle
    override func awakeFromNib() {
        super.awakeFromNib()
        setupCardStyle()
    }
    
    // MARK: - Styling Setup
    private func setupCardStyle() {
        cardView.layer.cornerRadius  = 16
        cardView.layer.shadowColor   = UIColor.black.cgColor
        cardView.layer.shadowOpacity = 0.08
        cardView.layer.shadowOffset  = CGSize(width: 0, height: 4)
        cardView.layer.shadowRadius  = 6
        cardView.layer.masksToBounds = false
        
        contentView.backgroundColor  = .clear
        backgroundColor              = .clear
        
        playerImageV.layer.cornerRadius = 16
        playerImageV.layer.maskedCorners = [.layerMinXMinYCorner, .layerMaxXMinYCorner]
        
        posBadge.layer.cornerRadius = 6
        numBadge.layer.cornerRadius = numBadge.frame.height / 2
        numBadge.clipsToBounds = true
    }

    // MARK: - Configuration
    func configure(with player: Player) {
        playerImageV.setImage(player.image ?? "","person")
        playerNameLabel.text =
            player.name?.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty == false
            ? player.name
            : "Unknown Player"
        playerNumberLabel.text = player.number != nil ? "\(player.number!)" : "-"
        lblAge.text = player.age != nil ? "Age \(player.age!)" : ""
        let position = player.type ?? "Unknown"
        updatePositionBadge(for: position)
    }
    
    private func updatePositionBadge(for position: String) {
        switch position {
        case "Forwards":
            lblPosText.text = "Forward"
            posBadge.backgroundColor = .systemRed.withAlphaComponent(0.15)
            lblPosText.textColor = .systemRed
        case "Midfielders":
            lblPosText.text = "Midfielder"
            posBadge.backgroundColor = .systemBlue.withAlphaComponent(0.15)
            lblPosText.textColor = .systemBlue
        case "Defenders":
            lblPosText.text = "Defender"
            posBadge.backgroundColor = .systemGreen.withAlphaComponent(0.15)
            lblPosText.textColor = .systemGreen
        case "Goalkeepers":
            lblPosText.text = "Goalkeeper"
            posBadge.backgroundColor = .systemOrange.withAlphaComponent(0.15)
            lblPosText.textColor = .systemOrange
        default:
            lblPosText.text = "N/A"
            posBadge.backgroundColor = .systemGray5
            lblPosText.textColor = .systemGray
        }
    }
}
