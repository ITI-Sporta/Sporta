//
//  EmptyTableCell.swift
//  Sporta
//
//  Created by Mohamed Ayman on 14/05/2026.
//

import UIKit
import Lottie
class EmptyTableCell: UITableViewCell {

    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var descriptionLabel: UILabel!
    @IBOutlet weak var lottieAnimationContainer: UIView!
    private var animationView: LottieAnimationView?
    
    override func awakeFromNib() {
        super.awakeFromNib()
        setupAnimation()
        titleLabel.text = "No Leagues Found"
        descriptionLabel.text = "There are no leagues available."
    }

    private func setupAnimation() {

        let animation = LottieAnimation.named("empty_state")

        let animationView = LottieAnimationView(animation: animation)

        animationView.frame = lottieAnimationContainer.bounds
        animationView.contentMode = .scaleAspectFit
        animationView.loopMode = .loop

        lottieAnimationContainer.addSubview(animationView)

        animationView.play()

        self.animationView = animationView
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        // Configure the view for the selected state
    }
    
}
