import UIKit

class LeagueDetailsViewController: UIViewController {
    
    // MARK: - Outlets
    @IBOutlet weak var segmentControl: UISegmentedControl!
    @IBOutlet weak var toggleFavoriteBtn: UIBarButtonItem!
    
    // MARK: - Properties
    var currentLeague: League!
    var sport: Sport!
    
    private var presenter: LeagueDetailsPresenterProtocol!
    private var collectionView: UICollectionView!
    private let spinner = UIActivityIndicatorView(style: .large)
    
    // MARK: - Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        setupPresenter()
        setupUI()
        setupCollectionView()
        setupSpinner()
        presenter.viewDidLoad()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        setupFavoriteButton()
    }
    
    // MARK: - Setup Methods
    private func setupPresenter() {
        presenter = LeagueDetailsPresenter(
            view: self,
            leagueId: currentLeague.id,
            sport: sport
        )
    }

    private func setupFavoriteButton() {
        presenter.checkIsFavorite(id: currentLeague.id)
    }

    private func setupUI() {
        view.backgroundColor = UIColor(red: 0.960, green: 0.960, blue: 0.960, alpha: 1.0)
        let orange = UIColor(red: 255/255, green: 126/255, blue: 33/255, alpha: 1.0)
        segmentControl.selectedSegmentTintColor = orange
        segmentControl.setTitleTextAttributes([.foregroundColor: UIColor.white], for: .selected)
        segmentControl.setTitleTextAttributes([.foregroundColor: UIColor.darkGray], for: .normal)
    }
    
    private func setupCollectionView() {
        collectionView = UICollectionView(frame: .zero, collectionViewLayout: createLayout())
        collectionView.translatesAutoresizingMaskIntoConstraints = false
        collectionView.backgroundColor = .clear
        collectionView.showsVerticalScrollIndicator = false
        collectionView.delegate = self
        collectionView.dataSource = self
        
        collectionView.register(UINib(nibName: "LeagueHeaderCell", bundle: nil), forCellWithReuseIdentifier: "LeagueHeaderCell")
        collectionView.register(UINib(nibName: "TeamCell", bundle: nil), forCellWithReuseIdentifier: "TeamCell")
        collectionView.register(UINib(nibName: "MatchCell", bundle: nil), forCellWithReuseIdentifier: "MatchCell")
        collectionView.register(UICollectionViewCell.self, forCellWithReuseIdentifier: "EmptyCell")
        collectionView.register(UINib(nibName: "EmptyStateCell", bundle: nil), forCellWithReuseIdentifier: "EmptyStateCell")
        
        collectionView.register(TeamsHeaderView.self, forSupplementaryViewOfKind: UICollectionView.elementKindSectionHeader, withReuseIdentifier: "TeamsHeaderView")
        collectionView.register(SegmentHeaderView.self, forSupplementaryViewOfKind: UICollectionView.elementKindSectionHeader, withReuseIdentifier: "SegmentHeaderView")
        
        view.addSubview(collectionView)
        NSLayoutConstraint.activate([
            collectionView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            collectionView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            collectionView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            collectionView.bottomAnchor.constraint(equalTo: view.bottomAnchor)
        ])
    }
    
    private func setupSpinner() {
        spinner.color = UIColor(red: 255/255, green: 126/255, blue: 33/255, alpha: 1.0)
        spinner.hidesWhenStopped = true
        spinner.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(spinner)
        NSLayoutConstraint.activate([
            spinner.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            spinner.centerYAnchor.constraint(equalTo: view.centerYAnchor)
        ])
    }
    
    // MARK: - IBActions
    @IBAction func segmentChanged(_ sender: UISegmentedControl) {
        presenter.didChangeSegment(to: sender.selectedSegmentIndex)
    }
    
    @IBAction func favoriteButtonClicked(_ sender: UIBarButtonItem) {
        let isFavorite = toggleFavoriteBtn.image == UIImage(systemName: "heart.fill")
        
        if isFavorite {
            AlertManager.showDeleteConfirmation(
                on: self,
                title: "Remove From Favorites",
                message: "Are you sure you want to remove \(currentLeague.name)?"
            ) { [weak self] confirmed in
                if confirmed, let self = self, let league = self.currentLeague {
                    self.presenter.toggleIsFavorite(league: league)
                }
            }
        } else {
            if let league = currentLeague {
                presenter.toggleIsFavorite(league: league)
            }
        }
    }
    
    // MARK: - Compositional Layout
    private func createLayout() -> UICollectionViewLayout {
        UICollectionViewCompositionalLayout { [weak self] sectionIndex, _ in
            guard let self = self, let section = LeagueDetailSection(rawValue: sectionIndex) else { return nil }
            switch section {
            case .header:   return self.createHeaderSection()
            case .segment:  return self.createSegmentSection()
            case .teams:    return self.createTeamsSection()
            case .fixtures: return self.createFixturesSection()
            }
        }
    }
    
    private func createHeaderSection() -> NSCollectionLayoutSection {
        let item = NSCollectionLayoutItem(layoutSize: NSCollectionLayoutSize(widthDimension: .fractionalWidth(1.0), heightDimension: .estimated(120)))
        let group = NSCollectionLayoutGroup.vertical(layoutSize: NSCollectionLayoutSize(widthDimension: .fractionalWidth(1.0), heightDimension: .estimated(120)), subitems: [item])
        let section = NSCollectionLayoutSection(group: group)
        section.contentInsets = NSDirectionalEdgeInsets(top: 16, leading: 16, bottom: 0, trailing: 16)
        return section
    }
    
    private func createSegmentSection() -> NSCollectionLayoutSection {
        let item = NSCollectionLayoutItem(layoutSize: NSCollectionLayoutSize(widthDimension: .fractionalWidth(1.0), heightDimension: .absolute(80)))
        let group = NSCollectionLayoutGroup.vertical(layoutSize: NSCollectionLayoutSize(widthDimension: .fractionalWidth(1.0), heightDimension: .absolute(80)), subitems: [item])
        let section = NSCollectionLayoutSection(group: group)
        
        let headerSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(1.0), heightDimension: .absolute(50))
        let header = NSCollectionLayoutBoundarySupplementaryItem(layoutSize: headerSize, elementKind: UICollectionView.elementKindSectionHeader, alignment: .top)
        section.boundarySupplementaryItems = [header]
        return section
    }
    
    private func createTeamsSection() -> NSCollectionLayoutSection {
        let item = NSCollectionLayoutItem(layoutSize: NSCollectionLayoutSize(widthDimension: .absolute(80), heightDimension: .absolute(100)))
        item.contentInsets = NSDirectionalEdgeInsets(top: 0, leading: 6, bottom: 0, trailing: 6)
        
        let group = NSCollectionLayoutGroup.horizontal(layoutSize: NSCollectionLayoutSize(widthDimension: .absolute(80), heightDimension: .absolute(100)), subitems: [item])
        let section = NSCollectionLayoutSection(group: group)
        section.orthogonalScrollingBehavior = .continuous
        section.contentInsets = NSDirectionalEdgeInsets(top: 8, leading: 10, bottom: 16, trailing: 10)
        
        let header = NSCollectionLayoutBoundarySupplementaryItem(layoutSize: NSCollectionLayoutSize(widthDimension: .fractionalWidth(1.0), heightDimension: .absolute(36)), elementKind: UICollectionView.elementKindSectionHeader, alignment: .top)
        section.boundarySupplementaryItems = [header]
        return section
    }
    
    private func createFixturesSection() -> NSCollectionLayoutSection {
        let count = presenter.numberOfRows(for: segmentControl.selectedSegmentIndex)
        
        let height: NSCollectionLayoutDimension = (count == 0) ? .absolute(400) : .estimated(180)
        
        let item = NSCollectionLayoutItem(
            layoutSize: NSCollectionLayoutSize(widthDimension: .fractionalWidth(1.0), heightDimension: height)
        )
        
        let group = NSCollectionLayoutGroup.vertical(
            layoutSize: NSCollectionLayoutSize(widthDimension: .fractionalWidth(1.0), heightDimension: height),
            subitems: [item]
        )
        
        let section = NSCollectionLayoutSection(group: group)
        section.contentInsets = NSDirectionalEdgeInsets(top: 8, leading: 16, bottom: 16, trailing: 16)
        return section
    }
}

// MARK: - UICollectionViewDataSource
extension LeagueDetailsViewController: UICollectionViewDataSource {
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return LeagueDetailSection.allCases.count
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        guard let leagueSection = LeagueDetailSection(rawValue: section) else { return 0 }
        switch leagueSection {
        case .header:   return 1
        case .segment:  return 0
        case .teams:    return presenter.numberOfTeams()
        case .fixtures:
            let count = presenter.numberOfRows(for: segmentControl.selectedSegmentIndex)
            return count == 0 ? 1 : count
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let section = LeagueDetailSection(rawValue: indexPath.section) else { return UICollectionViewCell() }
        
        switch section {
        case .header:
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "LeagueHeaderCell", for: indexPath) as! LeagueHeaderCell
            cell.configure(with: currentLeague)
            return cell
            
        case .segment:
            return collectionView.dequeueReusableCell(withReuseIdentifier: "EmptyCell", for: indexPath)
            
        case .teams:
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "TeamCell", for: indexPath) as! TeamCell
            cell.configure(with: presenter.team(at: indexPath.item))
            return cell
            
        case .fixtures:
            let count = presenter.numberOfRows(for: segmentControl.selectedSegmentIndex)
            
            if count == 0 {
                return collectionView.dequeueReusableCell(withReuseIdentifier: "EmptyStateCell", for: indexPath)
            }
            
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "MatchCell", for: indexPath) as! MatchCell
            cell.delegate = self
            cell.configure(with: presenter.fixture(at: indexPath.item, for: segmentControl.selectedSegmentIndex))
            return cell
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, viewForSupplementaryElementOfKind kind: String, at indexPath: IndexPath) -> UICollectionReusableView {
        guard let section = LeagueDetailSection(rawValue: indexPath.section) else { return UICollectionReusableView() }
        
        switch section {
        case .segment:
            let header = collectionView.dequeueReusableSupplementaryView(ofKind: kind, withReuseIdentifier: "SegmentHeaderView", for: indexPath) as! SegmentHeaderView
            header.configure(with: segmentControl)
            return header
            
        case .teams:
            let header = collectionView.dequeueReusableSupplementaryView(ofKind: kind, withReuseIdentifier: "TeamsHeaderView", for: indexPath) as! TeamsHeaderView
            return header
            
        default:
            return UICollectionReusableView()
        }
    }
}

// MARK: - UICollectionViewDelegate
extension LeagueDetailsViewController: UICollectionViewDelegate {
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        collectionView.deselectItem(at: indexPath, animated: true)
        guard let section = LeagueDetailSection(rawValue: indexPath.section) else { return }
        
        if case .teams = section {
            navigateToTeamDetails(with: presenter.team(at: indexPath.item))
        }
    }
}

// MARK: - LeagueDetailsViewProtocol
extension LeagueDetailsViewController: LeagueDetailsViewProtocol {
    func setFavoriteIcon(systemName: String) {
        toggleFavoriteBtn.image = UIImage(systemName: systemName)
    }
    
    func showLoading() {
        DispatchQueue.main.async {
            self.spinner.startAnimating()
            self.collectionView.isHidden = true
        }
    }
    
    func hideLoading() {
        DispatchQueue.main.async {
            self.spinner.stopAnimating()
            self.collectionView.isHidden = false
        }
    }
    
    func reloadFixtures() {
        DispatchQueue.main.async {
            self.collectionView.reloadSections(IndexSet(integer: LeagueDetailSection.fixtures.rawValue))
        }
    }
    
    func reloadTeams() {
        DispatchQueue.main.async {
            self.collectionView.reloadSections(IndexSet(integer: LeagueDetailSection.teams.rawValue))
        }
    }
    
    func showError(message: String) {
        DispatchQueue.main.async {
            let alert = UIAlertController(title: "Error", message: message, preferredStyle: .alert)
            alert.addAction(UIAlertAction(title: "Retry", style: .default) { _ in self.presenter.viewDidLoad() })
            alert.addAction(UIAlertAction(title: "OK", style: .cancel))
            self.present(alert, animated: true)
        }
    }
}

// MARK: - MatchCellDelegate
extension LeagueDetailsViewController: MatchCellDelegate {
    func didTapHomeTeam(in cell: MatchCell) {
        guard let indexPath = collectionView.indexPath(for: cell) else { return }
        let fixture = presenter.fixture(at: indexPath.item, for: segmentControl.selectedSegmentIndex)
        navigateToTeamDetails(teamName: fixture.homeTeamName ?? "")
    }
    
    func didTapAwayTeam(in cell: MatchCell) {
        guard let indexPath = collectionView.indexPath(for: cell) else { return }
        let fixture = presenter.fixture(at: indexPath.item, for: segmentControl.selectedSegmentIndex)
        navigateToTeamDetails(teamName: fixture.awayTeamName ?? "")
    }
}

// MARK: - Navigation
extension LeagueDetailsViewController {
    private func navigateToTeamDetails(with team: Team) {
        guard let vc = storyboard?.instantiateViewController(withIdentifier: "TeamDetailsViewController") as? TeamDetailsViewController else { return }
        vc.hidesBottomBarWhenPushed = true
        vc.teamId = team.id
        vc.sport = sport
        navigationController?.pushViewController(vc, animated: true)
    }
    
    private func navigateToTeamDetails(teamName: String) {
        guard let vc = storyboard?.instantiateViewController(withIdentifier: "TeamDetailsViewController") as? TeamDetailsViewController else { return }
        vc.hidesBottomBarWhenPushed = true
        vc.teamId = presenter.getTeamId(teamName: teamName)
        vc.sport = sport
        navigationController?.pushViewController(vc, animated: true)
    }
}
