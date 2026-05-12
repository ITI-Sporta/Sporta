//
//  TeamDetailsViewController.swift
//  Sporta
//
//  Created by Mohamed Ayman on 05/05/2026.
//

import UIKit


class TeamDetailsViewController: UICollectionViewController {
    var teamId: Int!
    var sport: Sport!
    
    var presenter : TeamDetailsPresenterProtocol!
    private let spinner = UIActivityIndicatorView(style: .large)
    
    override func viewDidLoad() {
        super.viewDidLoad()
        presenter = TeamDetailsPresenter(view: self)
        setupCollectionView()
        setupSpinner()
        presenter.fetchData(sport: sport, teamId: teamId)
    }
    
    func setupCollectionView() {
        collectionView.setCollectionViewLayout(createLayout(), animated: false)
        collectionView.register(
            UINib(nibName: K.teamDetailCell, bundle: nil),
            forCellWithReuseIdentifier: K.teamDetailCell
        )
        collectionView.register(
            UINib(nibName: K.playerCell, bundle: nil),
            forCellWithReuseIdentifier: K.playerCell
        )
        collectionView.register(
            UINib(nibName: K.matchCell, bundle: nil),
            forCellWithReuseIdentifier: K.matchCell
        )
        collectionView.register(TeamsHeaderView.self, forSupplementaryViewOfKind: UICollectionView.elementKindSectionHeader, withReuseIdentifier: K.header)
    }

    private func setupSpinner() {
        spinner.color = UIColor(red: 255/255, green: 126/255, blue: 33/255, alpha: 1.0)
        spinner.hidesWhenStopped = true
        spinner.center = view.center
        view.addSubview(spinner)
    }
}

extension TeamDetailsViewController {
    
    override func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 3
    }
    
    override func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        switch section {
        case 0 : return presenter.getTeamDetails() != nil ? 1 : 0
        case 1 : return presenter.getPlayersCount()
        default : return presenter.getFixturesCount()
        }
    }
    
    override func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
    
        switch indexPath.section {
        case 0 :
            let teamDetails = presenter.getTeamDetails() ?? TeamDetails.getEmptyTeamDetails()
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: K.teamDetailCell, for: indexPath) as! TeamDetailCell
            cell.configure(with: teamDetails)
            return cell
        
        case 1 :
            let player = presenter.getPlayer(at: indexPath.row)
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: K.playerCell, for: indexPath) as! PlayerCell
            cell.configure(with: player)
            return cell
        
        default :
            let fixture = presenter.getFixture(at: indexPath.row)
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: K.matchCell, for: indexPath) as! MatchCell
            cell.configure(with: fixture)
            return cell
        
        }
    }
    
    func createLayout() -> UICollectionViewCompositionalLayout {
        return UICollectionViewCompositionalLayout { sectionIndex, _ in
            switch sectionIndex {
            case 0 : return self.teamDetailsSection()
            case 1 : return self.playersSection()
            default : return self.fixtureSection()
            }
        }
    }
    
    func teamDetailsSection() -> NSCollectionLayoutSection {
        
        let itemSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(1), heightDimension: .fractionalHeight(1))
        let item = NSCollectionLayoutItem(layoutSize: itemSize)
        let groupSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(1), heightDimension: .absolute(164))
        let group = NSCollectionLayoutGroup.vertical(layoutSize: groupSize, subitems: [item])
    
        let section = NSCollectionLayoutSection(group: group)
        section.contentInsets = NSDirectionalEdgeInsets(top: 8, leading: 8, bottom: 8, trailing: 8)
        return section
        
    }
    
    func playersSection() -> NSCollectionLayoutSection {
        let itemSize = NSCollectionLayoutSize(widthDimension: .absolute(148), heightDimension: .absolute(252))
        let item = NSCollectionLayoutItem(layoutSize: itemSize)
        let group = NSCollectionLayoutGroup.horizontal(layoutSize: itemSize, subitems: [item])
        let section = NSCollectionLayoutSection(group: group)
        section.orthogonalScrollingBehavior = .continuous
        section.contentInsets = NSDirectionalEdgeInsets(top: 8, leading: 8, bottom: 8, trailing: 8)
        return section
    }
    
    func fixtureSection() -> NSCollectionLayoutSection {
        let itemSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(1), heightDimension:.fractionalHeight(1))
        let item = NSCollectionLayoutItem(layoutSize: itemSize)
        let groupSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(1), heightDimension: .estimated(180))
        let group = NSCollectionLayoutGroup.vertical(layoutSize: groupSize, subitems: [item])
        
        let section = NSCollectionLayoutSection(group: group)
        section.contentInsets = NSDirectionalEdgeInsets(top: 8, leading: 8, bottom: 8, trailing: 8)

        return section
    }
    
    override func collectionView(_ collectionView: UICollectionView, viewForSupplementaryElementOfKind kind: String, at indexPath: IndexPath) -> UICollectionReusableView {
        print("header")
        switch indexPath.section {
        case 1:
            let header = collectionView.dequeueReusableSupplementaryView(ofKind: kind, withReuseIdentifier: K.header, for: indexPath) as! TeamsHeaderView
            print("header")
            header.setText("Players")
            return header
            
        case 2:
            let header = collectionView.dequeueReusableSupplementaryView(ofKind: kind, withReuseIdentifier: K.header, for: indexPath) as! TeamsHeaderView
            print("header")
            header.setText("Fixtures")
            return header
            
        default:
            return UICollectionReusableView()
        }
    }

}

extension TeamDetailsViewController: TeamDetailsViewProtocol {
    func reloadData() {
        DispatchQueue.main.async {
            self.collectionView.reloadData()
        }
    }
    
    func showLoading() {
        DispatchQueue.main.async {
            self.spinner.startAnimating()
        }
    }
    
    func hideLoading() {
        DispatchQueue.main.async {
            self.spinner.stopAnimating()
        }
    }
    
    func showError(message: String) {
        let alert = UIAlertController(
            title: "Error",
            message: message,
            preferredStyle: .alert
        )

        let action = UIAlertAction(
            title: "OK",
            style: .default
        )

        alert.addAction(action)

        present(alert, animated: true)
    }
}
