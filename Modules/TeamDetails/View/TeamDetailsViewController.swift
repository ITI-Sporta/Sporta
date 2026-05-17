import UIKit

class TeamDetailsViewController: UICollectionViewController {
    
    enum SectionType: CaseIterable {
        case info
        case players
        case fixtures
    }
    
    private var activeSections: [SectionType] = []
    
    var teamId: Int!
    var sport: Sport!
    
    var presenter : TeamDetailsPresenterProtocol!
    private let spinner = UIActivityIndicatorView(style: .large)
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = UIColor(red: 0.960, green: 0.960, blue: 0.960, alpha: 1.0)
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
    
    private func updateActiveSections() {
        var sections: [SectionType] = []
        
        if presenter.getTeamDetails() != nil {
            sections.append(.info)
        }
        
        if presenter.getPlayersCount() > 0 {
            sections.append(.players)
        }
        
        if presenter.getFixturesCount() > 0 {
            sections.append(.fixtures)
        }
        
        self.activeSections = sections
    }
}

extension TeamDetailsViewController {
    
    override func numberOfSections(in collectionView: UICollectionView) -> Int {
        return activeSections.count
    }
    
    override func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        let currentSectionType = activeSections[section]
        
        switch currentSectionType {
        case .info:
            return 1
        case .players:
            return presenter.getPlayersCount()
        case .fixtures:
            return presenter.getFixturesCount()
        }
    }
    
    override func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let currentSectionType = activeSections[indexPath.section]
        
        switch currentSectionType {
        case .info:
            let teamDetails = presenter.getTeamDetails() ?? TeamDetails.getEmptyTeamDetails()
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: K.teamDetailCell, for: indexPath) as! TeamDetailCell
            cell.configure(with: teamDetails)
            return cell
        
        case .players:
            let player = presenter.getPlayer(at: indexPath.row)
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: K.playerCell, for: indexPath) as! PlayerCell
            cell.configure(with: player)
            return cell
        
        case .fixtures:
            let fixture = presenter.getFixture(at: indexPath.row)
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: K.matchCell, for: indexPath) as! MatchCell
            cell.configure(with: fixture)
            return cell
        }
    }
    
    func createLayout() -> UICollectionViewCompositionalLayout {
        return UICollectionViewCompositionalLayout { [weak self] sectionIndex, _ in
            guard let self = self, sectionIndex < self.activeSections.count else { return nil }
            let currentSectionType = self.activeSections[sectionIndex]
            
            switch currentSectionType {
            case .info:
                return self.teamDetailsSection()
            case .players:
                return self.playersSection()
            case .fixtures:
                return self.fixtureSection()
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
        let itemSize = NSCollectionLayoutSize(widthDimension: .absolute(160), heightDimension: .absolute(280))
        let item = NSCollectionLayoutItem(layoutSize: itemSize)
        let group = NSCollectionLayoutGroup.horizontal(layoutSize: itemSize, subitems: [item])
        let section = NSCollectionLayoutSection(group: group)
        section.orthogonalScrollingBehavior = .continuous
        section.contentInsets = NSDirectionalEdgeInsets(top: 8, leading: 8, bottom: 8, trailing: 8)
        section.boundarySupplementaryItems = [makeHeader()]
        return section
    }
    
    func fixtureSection() -> NSCollectionLayoutSection {
        let itemSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(1), heightDimension:.fractionalHeight(1))
        let item = NSCollectionLayoutItem(layoutSize: itemSize)
        let groupSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(1), heightDimension: .estimated(180))
        let group = NSCollectionLayoutGroup.vertical(layoutSize: groupSize, subitems: [item])
        
        let section = NSCollectionLayoutSection(group: group)
        section.contentInsets = NSDirectionalEdgeInsets(top: 8, leading: 8, bottom: 8, trailing: 8)
        section.boundarySupplementaryItems = [makeHeader()]
        return section
    }
    
    private func makeHeader() -> NSCollectionLayoutBoundarySupplementaryItem {
        let headerSize = NSCollectionLayoutSize(
            widthDimension: .fractionalWidth(1.0),
            heightDimension: .absolute(32)
        )
        return NSCollectionLayoutBoundarySupplementaryItem(
            layoutSize: headerSize,
            elementKind: UICollectionView.elementKindSectionHeader,
            alignment: .top
        )
    }
}

extension TeamDetailsViewController: UICollectionViewDelegateFlowLayout {
    override func collectionView(_ collectionView: UICollectionView,
                                viewForSupplementaryElementOfKind kind: String,
                                at indexPath: IndexPath) -> UICollectionReusableView {
        let header = collectionView.dequeueReusableSupplementaryView(
            ofKind: kind,
            withReuseIdentifier: K.header,
            for: indexPath
        ) as! TeamsHeaderView
        
        header.setText("")
        
        if indexPath.section < activeSections.count {
            let currentSectionType = activeSections[indexPath.section]
            switch currentSectionType {
            case .players:
                header.setText("Players")
            case .fixtures:
                header.setText("Fixtures")
            default:
                header.setText("")
            }
        }
        return header
    }
}

extension TeamDetailsViewController: TeamDetailsViewProtocol {
    func reloadData() {
        DispatchQueue.main.async {
            self.updateActiveSections()
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
        ) { _ in
            self.navigationController?.popViewController(animated: true)
        }

        alert.addAction(action)
        present(alert, animated: true)
    }
}
