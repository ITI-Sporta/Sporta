//
//  TeamDetailCell.swift
//  Sporta
//
//  Created by Hossam on 12/05/2026.
//

import UIKit

class TeamDetailCell: UICollectionViewCell {

    @IBOutlet weak var cardView: UIView!
    @IBOutlet weak var logoImageV: UIImageView!
    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var coachLabel: UILabel!
    @IBOutlet weak var playersCountLabel: UILabel!

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

    func configure(with team: TeamDetails) {
        
        logoImageV.setImage(team.logo ?? "")
        nameLabel.text = team.name
        playersCountLabel.text = String(team.players?.count ?? 0)
        guard let coaches = team.coaches else {
            coachLabel.text = "-"
            return
        }
        coachLabel.text = coaches.count > 0 ? coaches[0].name : "-"

    }
}
