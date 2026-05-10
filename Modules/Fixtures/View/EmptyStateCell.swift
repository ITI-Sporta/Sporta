//
//  EmptyStateCell.swift
//  Sporta
//
//  Created by Mohamed Ayman on 10/05/2026.
//

import UIKit

class EmptyStateCell: UICollectionViewCell {
    @IBOutlet weak var emptyImageView: UIImageView!

    override func awakeFromNib() {
        super.awakeFromNib()
        emptyImageView.image = UIImage(named: "empty_state_fixtures")
    }
}
