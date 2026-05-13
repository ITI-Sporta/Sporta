//
//  EmptyStateCell.swift
//  Sporta
//
//  Created by Mohamed Ayman on 10/05/2026.
//

import UIKit

import UIKit
import Lottie

class EmptyStateCell: UICollectionViewCell {

    @IBOutlet weak var animationContainerView: UIView!
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var descriptionLabel: UILabel!

    private var animationView: LottieAnimationView?

    override func awakeFromNib() {
        super.awakeFromNib()
        setupAnimation()
        titleLabel.text = "No Fixtures Yet"
        descriptionLabel.text = "There are no matches available right now."
    }

    private func setupAnimation() {

        let animation = LottieAnimation.named("empty_state")

        let animationView = LottieAnimationView(animation: animation)

        animationView.frame = animationContainerView.bounds
        animationView.contentMode = .scaleAspectFit
        animationView.loopMode = .loop

        animationContainerView.addSubview(animationView)

        animationView.play()

        self.animationView = animationView
    }
}
