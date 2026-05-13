//
//  ToastManager.swift
//  Sporta
//
//  Created by Mohamed Ayman on 13/05/2026.
//

import UIKit

enum ToastType {
    case success
    case error
    case info
    case favorite
    
    var backgroundColor: UIColor {
        switch self {
        case .success:  return UIColor(red: 34/255,  green: 197/255, blue: 94/255,  alpha: 1.0)
        case .error:    return UIColor(red: 239/255, green: 68/255,  blue: 68/255,  alpha: 1.0)
        case .info:     return UIColor(red: 20/255,  green: 40/255,  blue: 80/255,  alpha: 0.95)
        case .favorite: return UIColor(red: 255/255, green: 126/255, blue: 33/255,  alpha: 1.0)
        }
    }
    
    var icon: String {
        switch self {
        case .success:  return "checkmark.circle.fill"
        case .error:    return "xmark.circle.fill"
        case .info:     return "info.circle.fill"
        case .favorite: return "heart.fill"
        }
    }
}

final class ToastManager {
    
    // MARK: - Singleton
    static let shared = ToastManager()
    private init() {}
    
    // MARK: - Active toast tracking (prevents stacking)
    private weak var activeToast: UIView?
    
    // MARK: - Show
    func show(
        message: String,
        type: ToastType = .info,
        in view: UIView,
        duration: TimeInterval = 2.0
    ) {
        dismissActive()
        
        let container = UIView()
        container.backgroundColor    = type.backgroundColor
        container.layer.cornerRadius = 16
        container.clipsToBounds      = true
        container.alpha              = 0
        container.translatesAutoresizingMaskIntoConstraints = false
        
        let wrapper = UIView()
        wrapper.translatesAutoresizingMaskIntoConstraints = false
        wrapper.backgroundColor  = .clear
        wrapper.layer.shadowColor   = UIColor.black.cgColor
        wrapper.layer.shadowOpacity = 0.2
        wrapper.layer.shadowOffset  = CGSize(width: 0, height: 4)
        wrapper.layer.shadowRadius  = 12
        wrapper.alpha = 0
        
        let iconView = UIImageView()
        iconView.image               = UIImage(systemName: type.icon)
        iconView.tintColor           = .white
        iconView.contentMode         = .scaleAspectFit
        iconView.translatesAutoresizingMaskIntoConstraints = false
        
        let label = UILabel()
        label.text                = message
        label.textColor           = .white
        label.textAlignment       = .left
        label.font                = UIFont.systemFont(ofSize: 14, weight: .semibold)
        label.numberOfLines       = 2
        label.translatesAutoresizingMaskIntoConstraints = false
        
        wrapper.addSubview(container)
        container.addSubview(iconView)
        container.addSubview(label)
        view.addSubview(wrapper)
        
        NSLayoutConstraint.activate([
            wrapper.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 24),
            wrapper.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -24),
            wrapper.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor, constant: -16),
            
            container.topAnchor.constraint(equalTo: wrapper.topAnchor),
            container.leadingAnchor.constraint(equalTo: wrapper.leadingAnchor),
            container.trailingAnchor.constraint(equalTo: wrapper.trailingAnchor),
            container.bottomAnchor.constraint(equalTo: wrapper.bottomAnchor),
            container.heightAnchor.constraint(greaterThanOrEqualToConstant: 52),
            
            iconView.leadingAnchor.constraint(equalTo: container.leadingAnchor, constant: 16),
            iconView.centerYAnchor.constraint(equalTo: container.centerYAnchor),
            iconView.widthAnchor.constraint(equalToConstant: 22),
            iconView.heightAnchor.constraint(equalToConstant: 22),
            
            label.leadingAnchor.constraint(equalTo: iconView.trailingAnchor, constant: 10),
            label.trailingAnchor.constraint(equalTo: container.trailingAnchor, constant: -16),
            label.topAnchor.constraint(equalTo: container.topAnchor, constant: 14),
            label.bottomAnchor.constraint(equalTo: container.bottomAnchor, constant: -14)
        ])
        
        activeToast = wrapper
        wrapper.transform = CGAffineTransform(translationX: 0, y: 60)
        
        UIView.animate(
            withDuration: 0.4,
            delay: 0,
            usingSpringWithDamping: 0.7,
            initialSpringVelocity: 0.5,
            options: .curveEaseOut
        ) {
            wrapper.alpha     = 1
            container.alpha   = 1
            wrapper.transform = .identity
        } completion: { _ in
            UIView.animate(
                withDuration: 0.3,
                delay: duration,
                options: .curveEaseIn
            ) {
                wrapper.alpha     = 0
                wrapper.transform = CGAffineTransform(translationX: 0, y: 20)
            } completion: { _ in
                wrapper.removeFromSuperview()
            }
        }
    }
    
    // MARK: - Dismiss
    private func dismissActive() {
        activeToast?.removeFromSuperview()
        activeToast = nil
    }
}

