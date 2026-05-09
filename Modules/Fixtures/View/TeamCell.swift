//
//  TeamCell.swift
//  Sporta
//
//  Created by Mohamed Ayman on 09/05/2026.
//

import UIKit

class TeamCell: UICollectionViewCell {
    
    // MARK: - Outlets
    @IBOutlet weak var teamImageView: UIImageView!
    @IBOutlet weak var teamNameLabel: UILabel!
    
    // MARK: - Lifecycle
    override func awakeFromNib() {
        super.awakeFromNib()
        setupUI()
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        teamImageView.layer.cornerRadius = teamImageView.frame.width / 2
    }
    
    // MARK: - Setup
    private func setupUI() {
        teamImageView.clipsToBounds = true
        teamImageView.contentMode = .scaleAspectFill
        teamImageView.layer.borderWidth = 2
        teamImageView.layer.borderColor = UIColor(
            red: 255/255, green: 126/255, blue: 33/255, alpha: 1.0
        ).cgColor
        
        teamNameLabel.font = UIFont.systemFont(ofSize: 11, weight: .medium)
        teamNameLabel.textColor = .label
        teamNameLabel.textAlignment = .center
        teamNameLabel.numberOfLines = 2
    }
    
    // MARK: - Reuse
    override func prepareForReuse() {
        super.prepareForReuse()
        teamImageView.image = nil
        teamNameLabel.text = nil
    }
    
    // MARK: - Configure
    func configure(with team: Team) {
        teamNameLabel.text = team.name
        teamImageView.setImage(team.logo ?? "")
    }
}
