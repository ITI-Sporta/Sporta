//
//  MatchCell.swift
//  Sporta
//
//  Created by Mohamed Ayman on 08/05/2026.
//

import UIKit

protocol MatchCellDelegate: AnyObject {
    func didTapHomeTeam(in cell: MatchCell)
    func didTapAwayTeam(in cell: MatchCell)
}

class MatchCell: UICollectionViewCell {
    
    // MARK: - Outlets
    @IBOutlet weak var cardView:      UIView!
    @IBOutlet weak var leagueLabel:   UILabel!
    @IBOutlet weak var statusLabel:   UILabel!
    @IBOutlet weak var homeLogo:      UIImageView!
    @IBOutlet weak var homeName:      UILabel!
    @IBOutlet weak var scoreLabel:    UILabel!
    @IBOutlet weak var awayLogo:      UIImageView!
    @IBOutlet weak var awayName:      UILabel!
    @IBOutlet weak var footerLabel:   UILabel!
    @IBOutlet weak var homeTeamContainer: UIStackView!
    @IBOutlet weak var awayTeamContainer: UIStackView!
    // MARK: - Properties
    weak var delegate: MatchCellDelegate?
    
    // MARK: - Lifecycle
    override func awakeFromNib() {
        super.awakeFromNib()
        setupCardStyle()
        setupGestures()
    }
    
    // MARK: - Setup
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
    
    private func setupGestures() {
        let homeTap = UITapGestureRecognizer(target: self, action: #selector(homeTapped))
        let awayTap = UITapGestureRecognizer(target: self, action: #selector(awayTapped))
        homeTeamContainer.isUserInteractionEnabled = true
        awayTeamContainer.isUserInteractionEnabled = true
        homeTeamContainer.addGestureRecognizer(homeTap)
        awayTeamContainer.addGestureRecognizer(awayTap)
    }
    
    // MARK: - Actions
    @objc private func homeTapped() {
        delegate?.didTapHomeTeam(in: self)
    }
    
    @objc private func awayTapped() {
        delegate?.didTapAwayTeam(in: self)
    }
    
    // MARK: - Reuse
    override func prepareForReuse() {
        super.prepareForReuse()
        homeLogo.image    = nil
        awayLogo.image    = nil
        homeName.text     = nil
        awayName.text     = nil
        scoreLabel.text   = nil
        statusLabel.text  = nil
        leagueLabel.text  = nil
        footerLabel.text  = nil
    }
    
    // MARK: - Configure
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
        
        homeLogo.setImage(fixture.homeTeamLogo ?? fixture.eventHomeTeamLogo ?? "")
        awayLogo.setImage(fixture.awayTeamLogo ?? fixture.eventAwayTeamLogo ?? "")
    }
}
