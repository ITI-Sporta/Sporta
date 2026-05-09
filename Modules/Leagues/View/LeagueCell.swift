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

        leagueImageView.layer.cornerRadius = 25
        leagueImageView.clipsToBounds = true

        countryImageView.layer.cornerRadius = 15
        countryImageView.clipsToBounds = true
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
