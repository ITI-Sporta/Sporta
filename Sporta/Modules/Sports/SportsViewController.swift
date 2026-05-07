//
//  SportsViewController.swift
//  Sporta
//
//  Created by Mohamed Ayman on 05/05/2026.
//

import UIKit

class SportsViewController: UIViewController {
    
    @IBOutlet weak var collectionView: UICollectionView!
    @IBOutlet weak var logoImage: UIImageView!
   
    // MARK: - Data
    private let sports: [Sport] = Sport.allCases
    
    // MARK: - Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        navigationController?.setNavigationBarHidden(true, animated: false)
        setupCollectionView()
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        collectionView.collectionViewLayout = createLayout()
    }
    
    // MARK: - Setup
    private func setupCollectionView() {
        let nib = UINib(nibName: "SportCell", bundle: nil)
        collectionView.register(nib, forCellWithReuseIdentifier: "SportCell")
        collectionView.delegate = self
        collectionView.dataSource = self
        collectionView.isScrollEnabled = false
        collectionView.showsVerticalScrollIndicator = false
        collectionView.backgroundColor = .clear
    }
    
    // MARK: - Layout
    private func createLayout() -> UICollectionViewLayout {
        let outerInset: CGFloat  = 16
        let itemSpacing: CGFloat = 8
        let minimumRowHeight: CGFloat = 240
        
        let totalHeight     = collectionView.bounds.height
        let availableHeight = totalHeight - (outerInset * 2)
        let calculatedRowHeight = availableHeight / 2
        
        let rowHeight = max(calculatedRowHeight, minimumRowHeight)
        
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
    
}

// MARK: - UICollectionViewDataSource
extension SportsViewController: UICollectionViewDataSource {
    
    func collectionView(_ collectionView: UICollectionView,
                        numberOfItemsInSection section: Int) -> Int {
        sports.count
    }
    
    func collectionView(_ collectionView: UICollectionView,
                        cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(
            withReuseIdentifier: "SportCell",
            for: indexPath
        ) as! SportCell
        cell.configure(with: sports[indexPath.item])
        return cell
    }
}

// MARK: - UICollectionViewDelegate
extension SportsViewController: UICollectionViewDelegate {
    
    func collectionView(_ collectionView: UICollectionView,
                        didSelectItemAt indexPath: IndexPath) {
        collectionView.deselectItem(at: indexPath, animated: true)
        performSegue(withIdentifier: "goToLeagues", sender: sports[indexPath.item])
    }
}

// MARK: - Navigation
extension SportsViewController {
    
//    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
//        if segue.identifier == "goToLeagues",
//           let leaguesVC = segue.destination as? LeaguesViewController,
//           let sport = sender as? Sport {
//            leaguesVC.sport = sport
//        }
//    }
}
