//
//  SDImageView.swift
//  Sporta
//
//  Created by Hossam on 08/05/2026.
//

import UIKit
import SDWebImage

extension UIImageView {
    func setImage(_ stringUrl: String) {
        sd_setImage(
            with: URL(string: stringUrl),
            placeholderImage: UIImage(systemName: "photo.fill")
        )
    }
}
