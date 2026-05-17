//
//  SDImageView.swift
//  Sporta
//
//  Created by Hossam on 08/05/2026.
//

import UIKit
import SDWebImage

extension UIImageView {
    func setImage(_ stringUrl: String,_ imageName:String = "logo_icon") {
        sd_setImage(
            with: URL(string: stringUrl),
            placeholderImage: UIImage(named: imageName)
        )
    }
}

extension UIColor {
    static let appBackground = UIColor(
        red: 0.960,
        green: 0.960,
        blue: 0.960,
        alpha: 1.0
    )
}
