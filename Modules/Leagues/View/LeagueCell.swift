//
//  LeagueCell.swift
//  Sporta
//
//  Created by Hossam on 08/05/2026.
//

import UIKit

class LeagueCell: UITableViewCell {

    @IBOutlet weak var leagueImageView: UIImageView!
    @IBOutlet weak var countryImageView: UIImageView!

    @IBOutlet weak var leagueNameLabel: UILabel!
    @IBOutlet weak var countryNameLabel: UILabel!

    override func awakeFromNib() {
        super.awakeFromNib()

        setupUI()
    }
    
    private func setupUI() {

        selectionStyle = .none
        backgroundColor = .systemBackground

        leagueImageView.layer.cornerRadius = 25
        leagueImageView.clipsToBounds = true
        leagueImageView.contentMode = .scaleAspectFit

        countryImageView.layer.cornerRadius = 15
        countryImageView.clipsToBounds = true
        countryImageView.contentMode = .scaleAspectFill

        leagueNameLabel.font = .boldSystemFont(ofSize: 18)

        countryNameLabel.font = .systemFont(ofSize: 14, weight: .medium)
        countryNameLabel.textColor = .secondaryLabel
    }

    override func prepareForReuse() {
        super.prepareForReuse()

        leagueImageView.image = nil
        countryImageView.image = nil

        leagueNameLabel.text = nil
        countryNameLabel.text = nil
    }

    func configure(with league: League) {
        leagueNameLabel.text = league.name
        countryNameLabel.text = league.country

        leagueImageView.setImage(league.logo ?? "")
        countryImageView.setImage(league.countryLogo ?? "")
    }

    func configure(with league: FavoriteLeague) {
        leagueNameLabel.text = league.name
        countryNameLabel.text = league.country

        leagueImageView.setImage(league.logo)
        countryImageView.setImage(league.countryLogo)
    }
}
