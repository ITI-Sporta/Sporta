//
//  OnboardingViewController.swift
//  Sporta
//
//  Created by Mohamed Ayman on 05/05/2026.
//

import UIKit
import PaperOnboarding
import Lottie

class OnboardingViewController: UIViewController {
    
    // MARK: - Properties
    @IBOutlet weak var onboarding: PaperOnboarding!
    private var lottieView      = LottieAnimationView()
    @IBOutlet weak var getStartedButton: UIButton!
    
    private let animations = ["football_lottie", "league_lottie", "favorite_lottie"]
    private let totalPages = 3
    private var currentIndex = 0
    private var lottieSetup = false
    
    // MARK: - Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        onboarding.dataSource = self
        onboarding.delegate   = self
        setupGetStartedButton()
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        guard !lottieSetup else { return }
        lottieSetup = true
        setupLottie(index: 0)
    }
    
    // MARK: - Setup
    
    private func setupLottie(index: Int) {
        guard index < animations.count else { return }
        
        lottieView.stop()
        lottieView.removeFromSuperview()
        
        lottieView = LottieAnimationView(asset: animations[index])
        lottieView.translatesAutoresizingMaskIntoConstraints = false
        lottieView.contentMode = .scaleAspectFit
        lottieView.loopMode   = .playOnce
        lottieView.alpha      = 0
        
        view.addSubview(lottieView)
        
        NSLayoutConstraint.activate([
            lottieView.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            lottieView.topAnchor.constraint(equalTo: view.topAnchor, constant: 80),
            lottieView.widthAnchor.constraint(equalTo: view.widthAnchor, multiplier: 0.95),
            lottieView.heightAnchor.constraint(equalTo: view.heightAnchor, multiplier: 0.45)
        ])
        
        view.bringSubviewToFront(getStartedButton)
        
        lottieView.play()
        UIView.animate(withDuration: 0.4) {
            self.lottieView.alpha = 1
        }
    }
    
    private func setupGetStartedButton() {
        getStartedButton.backgroundColor  = .white
        getStartedButton.setTitleColor(
            UIColor(red: 255/255, green: 126/255, blue: 33/255, alpha: 1), for: .normal
        )
        getStartedButton.layer.cornerRadius = 25
        getStartedButton.layer.shadowColor   = UIColor.black.cgColor
        getStartedButton.layer.shadowOpacity = 0.15
        getStartedButton.layer.shadowOffset  = CGSize(width: 0, height: 4)
        getStartedButton.layer.shadowRadius  = 8
        getStartedButton.alpha = 0
        
    }
    
    // MARK: - Actions
    @IBAction func getStartedTapped(_ sender: UIButton){
        UserDefaults.standard.set(true, forKey: UserDefaultsKeys.hasSeenOnboarding)
        guard let sceneDelegate = view.window?.windowScene?.delegate as? SceneDelegate else { return }
        sceneDelegate.showMainApp()
    }
    private func showGetStartedIfNeeded(index: Int) {
        let isLast = index == totalPages - 1
        if(isLast){
            UIView.animate(withDuration: 1.0) {
                self.getStartedButton.alpha = 1
            }
        }
        else{
            UIView.animate(withDuration: 0.6) {
                self.getStartedButton.alpha = 0
            }
        }
    }
    
}

// MARK: - PaperOnboardingDataSource
extension OnboardingViewController: PaperOnboardingDataSource {
    
    func onboardingItemsCount() -> Int { totalPages }
    
    func onboardingItem(at index: Int) -> OnboardingItemInfo {
        let colors: [UIColor] = [
            UIColor(red: 232/255, green: 234/255, blue: 238/255, alpha: 1.0),
            UIColor(red: 255/255, green: 240/255, blue: 230/255, alpha: 1.0),
            UIColor(red: 235/255, green: 242/255, blue: 255/255, alpha: 1.0)
        ]
        let titles = ["Discover Sports", "Follow Leagues",  "Save Favorites"]
        let descriptions = [
            "Browse football, basketball, tennis\nand more in one place.",
            "Explore leagues from every country\nand follow upcoming fixtures.",
            "Save your favorite leagues and teams\nfor instant access anytime."
        ]
        
        return OnboardingItemInfo(
            informationImage: UIImage(),
            title: titles[index],
            description: descriptions[index],
            pageIcon: UIImage(systemName: "circle.fill") ?? UIImage(),
            color: colors[index],
            titleColor: UIColor(red: 20/255, green: 20/255, blue: 20/255, alpha: 1.0),
            descriptionColor: UIColor(red: 90/255, green: 90/255, blue: 90/255, alpha: 1.0),
            titleFont: UIFont.systemFont(ofSize: 28, weight: .bold),
            descriptionFont: UIFont.systemFont(ofSize: 16, weight: .regular)
        )
    }
}

// MARK: - PaperOnboardingDelegate
extension OnboardingViewController: PaperOnboardingDelegate {
    
    func onboardingWillTransitonToIndex(_ index: Int) {
        currentIndex = index
        setupLottie(index: index)
        showGetStartedIfNeeded(index: index)
    }
    
    func onboardingDidTransitonToIndex(_ index: Int) {
        lottieView.play()
    }
}
