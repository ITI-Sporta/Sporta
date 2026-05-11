//
//  LeagueHeaderCell.swift
//  Sporta
//
//  Created by Mohamed Ayman on 10/05/2026.
//

import UIKit

class LeagueHeaderCell: UICollectionViewCell {
    
    // MARK: - Outlets
    @IBOutlet weak var leagueImageView:    UIImageView!
    @IBOutlet weak var leagueNameLabel:    UILabel!
    @IBOutlet weak var countrySeasonLabel: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        setupUI()
    }
    
    private func setupUI() {
        backgroundColor = .clear
        
        leagueImageView.layer.cornerRadius = 8
        leagueImageView.clipsToBounds      = true
        leagueImageView.contentMode        = .scaleAspectFit
        
        leagueNameLabel.font = UIFont.systemFont(ofSize: 22, weight: .bold)
        leagueNameLabel.textColor = UIColor(
            red: 0.078, green: 0.156, blue: 0.313, alpha: 1.0
        )
        
        countrySeasonLabel.font      = UIFont.systemFont(ofSize: 16, weight: .medium)
        countrySeasonLabel.textColor = .secondaryLabel
    }
    
    func configure(with league: League) {
        leagueNameLabel.text    = league.name
        countrySeasonLabel.text = league.country ?? ""
        leagueImageView.setImage(league.logo ?? "")
    }
}
