//
//  SegmentHeaderView.swift
//  Sporta
//
//  Created by Mohamed Ayman on 10/05/2026.
//

import UIKit

class SegmentHeaderView: UICollectionReusableView {
    
    private var segmentControl: UISegmentedControl?
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        backgroundColor = UIColor(
            red: 0.960, green: 0.960, blue: 0.960, alpha: 1.0
        )
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func configure(with segment: UISegmentedControl) {
        segmentControl?.removeFromSuperview()
        segmentControl = segment
        segment.translatesAutoresizingMaskIntoConstraints = false
        addSubview(segment)
        NSLayoutConstraint.activate([
            segment.topAnchor.constraint(equalTo: topAnchor, constant: 8),
            segment.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 16),
            segment.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -16),
            segment.bottomAnchor.constraint(equalTo: bottomAnchor, constant: -8)
        ])
    }
}
