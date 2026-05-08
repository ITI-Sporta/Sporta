//
//  MatchCell.swift
//  Sporta
//
//  Created by Hossam on 08/05/2026.
//

import UIKit

class MatchCell: UITableViewCell {
    
    // MARK: - Outlets
    @IBOutlet weak var cardView: UIView!
    @IBOutlet weak var leagueLabel: UILabel!
    @IBOutlet weak var statusLabel: UILabel!
    @IBOutlet weak var homeLogo: UIImageView!
    @IBOutlet weak var homeName: UILabel!
    @IBOutlet weak var scoreLabel: UILabel!
    @IBOutlet weak var awayLogo: UIImageView!
    @IBOutlet weak var awayName: UILabel!
    @IBOutlet weak var footerLabel: UILabel!
    
    // MARK: - Lifecycle
    override func awakeFromNib() {
        super.awakeFromNib()
        setupCardStyle()
    }
    
    // MARK: - Setup
    private func setupCardStyle() {
        cardView.layer.cornerRadius = 12
        cardView.layer.shadowColor = UIColor.black.cgColor
        cardView.layer.shadowOpacity = 0.1
        cardView.layer.shadowOffset = CGSize(width: 0, height: 2)
        cardView.layer.shadowRadius = 4
        cardView.layer.masksToBounds = false
        contentView.backgroundColor = .clear
    }
    
    // MARK: - Reuse
    override func prepareForReuse() {
        super.prepareForReuse()
        homeLogo.image = nil
        awayLogo.image = nil
        homeName.text = nil
        awayName.text = nil
        scoreLabel.text = nil
        statusLabel.text = nil
        leagueLabel.text = nil
        footerLabel.text = nil
    }
    
    // MARK: - Configuration
    func configure(with fixture: Fixture) {
        leagueLabel.text = fixture.leagueName
        homeName.text    = fixture.homeTeamName
        awayName.text    = fixture.awayTeamName
        footerLabel.text = "\(fixture.time ?? "--:--") | \(fixture.leagueRound ?? "")"
        
        if fixture.isLive {
            statusLabel.text      = fixture.status
            statusLabel.textColor = .systemRed
            scoreLabel.text       = fixture.homeScore ?? "0 - 0"
        } else if fixture.isFinished {
            statusLabel.text      = fixture.status
            statusLabel.textColor = .systemOrange
            scoreLabel.text       = fixture.homeScore ?? "0 - 0"
        } else {
            statusLabel.text      = fixture.status
            statusLabel.textColor = .secondaryLabel
            scoreLabel.text       = "VS"
        }
        
        homeLogo.setImage(fixture.homeTeamLogo ?? "")
        awayLogo.setImage(fixture.awayTeamLogo ?? "")
    }
}
