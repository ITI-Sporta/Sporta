//
//  SportsViewController.swift
//  Sporta
//
//  Created by Mohamed Ayman on 05/05/2026.
//

import UIKit

class SportsViewController: UIViewController {
    
    // MARK: - Outlets
    @IBOutlet weak var collectionView: UICollectionView!
    @IBOutlet weak var logoImage: UIImageView!
    
    // MARK: - Presenter
    var presenter: SportsPresenterProtocol!
    
    // MARK: - Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        presenter = SportsPresenter(view: self)
        setupCollectionView()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        navigationController?.setNavigationBarHidden(true, animated: false)
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        collectionView.collectionViewLayout = createLayout()
    }
    
    override func viewWillTransition(to size: CGSize,
                                     with coordinator: UIViewControllerTransitionCoordinator) {
        super.viewWillTransition(to: size, with: coordinator)
        coordinator.animate { _ in
            self.collectionView.collectionViewLayout = self.createLayout()
            self.updateScrolling()
        }
    }
    
    // MARK: - Setup
    private func setupCollectionView() {
        let nib = UINib(nibName: "SportCell", bundle: nil)
        collectionView.register(nib, forCellWithReuseIdentifier: "SportCell")
        collectionView.delegate   = self
        collectionView.dataSource = self
        collectionView.isScrollEnabled = false
        collectionView.showsVerticalScrollIndicator = false
        collectionView.backgroundColor = .clear
    }
    
    // MARK: - Layout
    private func createLayout() -> UICollectionViewLayout {
        let outerInset: CGFloat       = 16
        let itemSpacing: CGFloat      = 8
        let minimumRowHeight: CGFloat = 120
        
        let availableHeight  = collectionView.bounds.height - (outerInset * 2)
        let calculatedHeight = availableHeight / 2
        let rowHeight        = max(calculatedHeight, minimumRowHeight)
        
        let itemSize = NSCollectionLayoutSize(
            widthDimension: .fractionalWidth(0.5),
            heightDimension: .absolute(rowHeight)
        )
        let item = NSCollectionLayoutItem(layoutSize: itemSize)
        item.contentInsets = NSDirectionalEdgeInsets(
            top: itemSpacing, leading: itemSpacing,
            bottom: itemSpacing, trailing: itemSpacing
        )
        
        let groupSize = NSCollectionLayoutSize(
            widthDimension: .fractionalWidth(1.0),
            heightDimension: .absolute(rowHeight)
        )
        let group = NSCollectionLayoutGroup.horizontal(
            layoutSize: groupSize,
            subitems: [item, item]
        )
        
        let section = NSCollectionLayoutSection(group: group)
        section.contentInsets = NSDirectionalEdgeInsets(
            top: outerInset, leading: outerInset,
            bottom: outerInset, trailing: outerInset
        )
        
        return UICollectionViewCompositionalLayout(section: section)
    }
    
    private func updateScrolling() {
        let outerInset: CGFloat       = 16
        let minimumRowHeight: CGFloat = 120
        let availableHeight           = collectionView.bounds.height - (outerInset * 2)
        let calculatedHeight          = availableHeight / 2
        collectionView.isScrollEnabled = calculatedHeight < minimumRowHeight
    }
}

// MARK: - UICollectionViewDataSource
extension SportsViewController: UICollectionViewDataSource {
    
    func collectionView(_ collectionView: UICollectionView,
                        numberOfItemsInSection section: Int) -> Int {
        presenter.numberOfSports
    }
    
    func collectionView(_ collectionView: UICollectionView,
                        cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(
            withReuseIdentifier: "SportCell",
            for: indexPath
        ) as! SportCell
        cell.configure(with: presenter.sport(at: indexPath.item))
        return cell
    }
}

// MARK: - UICollectionViewDelegate
extension SportsViewController: UICollectionViewDelegate {
    
    func collectionView(_ collectionView: UICollectionView,
                        didSelectItemAt indexPath: IndexPath) {
        collectionView.deselectItem(at: indexPath, animated: true)
        presenter.didSelectSport(at: indexPath.item)
    }
}

// MARK: - SportsViewProtocol
extension SportsViewController: SportsViewProtocol {
    
    func navigateToLeagues(with sport: Sport) {
        performSegue(withIdentifier: "goToLeagues", sender: sport)
    }
}

// MARK: - Navigation
extension SportsViewController {
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "goToLeagues",
        let leaguesVC = segue.destination as? LeaguesViewController,
        let sport = sender as? Sport {
            leaguesVC.hidesBottomBarWhenPushed = true
            leaguesVC.sport = sport
        }
    }
}
