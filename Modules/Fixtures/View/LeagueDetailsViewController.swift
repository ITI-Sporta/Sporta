//
//  LeagueDetailsViewController.swift
//  Sporta
//
//  Created by Mohamed Ayman on 05/05/2026.
//

import UIKit

class LeagueDetailsViewController: UIViewController {
    
    // MARK: - Outlets
    @IBOutlet weak var tableView:           UITableView!
    @IBOutlet weak var segmentControl:      UISegmentedControl!
    @IBOutlet weak var leagueImageView:     UIImageView!
    @IBOutlet weak var leagueNameLabel:     UILabel!
    @IBOutlet weak var countrySeasonLabel:  UILabel!
    @IBOutlet weak var teamsCollectionView: UICollectionView!
    @IBOutlet weak var tableViewHeight:     NSLayoutConstraint!
    
    // MARK: - Properties
    var currentLeague: League!
    var sport: Sport!
    
    private var presenter: LeagueDetailsPresenterProtocol!
    private let spinner = UIActivityIndicatorView(style: .large)
    
    // MARK: - Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        setupPresenter()
        setupUI()
        setupTableView()
        setupTeamsCollectionView()
        setupSpinner()
        populateLeagueHeader()
        presenter.viewDidLoad()
    }
    
    // MARK: - Setup
    private func setupPresenter() {
        presenter = LeagueDetailsPresenter(
            view: self,
            leagueId: currentLeague.id,
            sport: sport
        )
    }
    
    private func setupUI() {
        let orange = UIColor(red: 255/255, green: 126/255, blue: 33/255, alpha: 1.0)
        segmentControl.selectedSegmentTintColor = orange
        segmentControl.setTitleTextAttributes([.foregroundColor: UIColor.white],    for: .selected)
        segmentControl.setTitleTextAttributes([.foregroundColor: UIColor.darkGray], for: .normal)
        leagueImageView.layer.cornerRadius = 8
        leagueImageView.clipsToBounds = true
    }
    
    private func setupTableView() {
        let nib = UINib(nibName: "MatchCell", bundle: nil)
        tableView.register(nib, forCellReuseIdentifier: "MatchCell")
        tableView.delegate        = self
        tableView.dataSource      = self
        tableView.separatorStyle  = .none
        tableView.backgroundColor = .clear
        tableView.isScrollEnabled = false
    }
    
    private func setupTeamsCollectionView() {
        let nib = UINib(nibName: "TeamCell", bundle: nil)
        teamsCollectionView.register(nib, forCellWithReuseIdentifier: "TeamCell")
        teamsCollectionView.delegate             = self
        teamsCollectionView.dataSource           = self
        teamsCollectionView.backgroundColor      = .clear
        teamsCollectionView.showsHorizontalScrollIndicator = false
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
    
    private func populateLeagueHeader() {
        leagueNameLabel.text    = currentLeague.name
        countrySeasonLabel.text = currentLeague.country ?? ""
        leagueImageView.setImage(currentLeague.logo ?? "")
    }
    
    // MARK: - Actions
    @IBAction func segmentChanged(_ sender: UISegmentedControl) {
        presenter.didChangeSegment(to: sender.selectedSegmentIndex)
    }
    
    @IBAction func favoriteButtonClicked(_ sender: UIBarButtonItem) {
        // setup this action and add what you need to contract & presenter
    }
}

// MARK: - UITableViewDataSource
extension LeagueDetailsViewController: UITableViewDataSource {
    
    func tableView(_ tableView: UITableView,
                   numberOfRowsInSection section: Int) -> Int {
        presenter.numberOfRows(for: segmentControl.selectedSegmentIndex)
    }
    
    func tableView(_ tableView: UITableView,
                   cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(
            withIdentifier: "MatchCell",
            for: indexPath
        ) as! MatchCell
        let fixture = presenter.fixture(
            at: indexPath.row,
            for: segmentControl.selectedSegmentIndex
        )
        cell.delegate = self
        cell.configure(with: fixture)
        return cell
    }
    
    // MARK: - Empty state
    func tableView(_ tableView: UITableView,
                   viewForFooterInSection section: Int) -> UIView? {
        let count = presenter.numberOfRows(for: segmentControl.selectedSegmentIndex)
        guard count == 0 else { return nil }
        let label = UILabel()
        label.text          = emptyMessage(for: segmentControl.selectedSegmentIndex)
        label.textAlignment = .center
        label.textColor     = .secondaryLabel
        label.font          = UIFont.systemFont(ofSize: 15)
        return label
    }
    
    func tableView(_ tableView: UITableView,
                   heightForFooterInSection section: Int) -> CGFloat {
        let count = presenter.numberOfRows(for: segmentControl.selectedSegmentIndex)
        return count == 0 ? 200 : 0
    }
    
    private func emptyMessage(for segmentIndex: Int) -> String {
        switch segmentIndex {
        case 0: return "No upcoming fixtures"
        case 1: return "No recent results"
        case 2: return "No live matches right now"
        default: return ""
        }
    }
}

// MARK: - UITableViewDelegate
extension LeagueDetailsViewController: UITableViewDelegate {
    
    func tableView(_ tableView: UITableView,
                   didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
    }
    
    func tableView(_ tableView: UITableView,
                   heightForRowAt indexPath: IndexPath) -> CGFloat {
        UITableView.automaticDimension
    }
    
    func tableView(_ tableView: UITableView,
                   estimatedHeightForRowAt indexPath: IndexPath) -> CGFloat {
        120
    }
}

// MARK: - UICollectionViewDataSource
extension LeagueDetailsViewController: UICollectionViewDataSource {
    
    func collectionView(_ collectionView: UICollectionView,
                        numberOfItemsInSection section: Int) -> Int {
        presenter.numberOfTeams()
    }
    
    func collectionView(_ collectionView: UICollectionView,
                        cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(
            withReuseIdentifier: "TeamCell",
            for: indexPath
        ) as! TeamCell
        cell.configure(with: presenter.team(at: indexPath.item))
        return cell
    }
}

// MARK: - UICollectionViewDelegate
extension LeagueDetailsViewController: UICollectionViewDelegate {
    
    func collectionView(_ collectionView: UICollectionView,
                        didSelectItemAt indexPath: IndexPath) {
        collectionView.deselectItem(at: indexPath, animated: true)
        let team = presenter.team(at: indexPath.item)
        navigateToTeamDetails(with: team)
    }
}

// MARK: - UICollectionViewDelegateFlowLayout
extension LeagueDetailsViewController: UICollectionViewDelegateFlowLayout {
    
    func collectionView(_ collectionView: UICollectionView,
                        layout collectionViewLayout: UICollectionViewLayout,
                        sizeForItemAt indexPath: IndexPath) -> CGSize {
        CGSize(width: 80, height: 100)
    }
}

// MARK: - LeagueDetailsViewProtocol
extension LeagueDetailsViewController: LeagueDetailsViewProtocol {
    
    func showLoading() {
        DispatchQueue.main.async {
            self.spinner.startAnimating()
            self.tableView.isHidden           = true
            self.teamsCollectionView.isHidden = true
        }
    }
    
    func hideLoading() {
        DispatchQueue.main.async {
            self.spinner.stopAnimating()
            self.tableView.isHidden           = false
            self.teamsCollectionView.isHidden = false
        }
    }
    
    func reloadFixtures() {
        DispatchQueue.main.async {
            UIView.transition(
                with: self.tableView,
                duration: 0.3,
                options: .transitionCrossDissolve,
                animations: {
                    self.tableView.reloadData()
                },
                completion: { _ in
                    self.tableView.layoutIfNeeded()
                    let minHeight: CGFloat = 400
                    let contentHeight = self.tableView.contentSize.height
                    self.tableViewHeight.constant = max(contentHeight, minHeight)
                }
            )
        }
    }
    
    func reloadTeams() {
        DispatchQueue.main.async {
            self.teamsCollectionView.reloadData()
        }
    }
    
    func showError(message: String) {
        DispatchQueue.main.async {
            let alert = UIAlertController(
                title: "Error",
                message: message,
                preferredStyle: .alert
            )
            alert.addAction(UIAlertAction(title: "Retry", style: .default) { _ in
                self.presenter.viewDidLoad()
            })
            alert.addAction(UIAlertAction(title: "OK", style: .cancel))
            self.present(alert, animated: true)
        }
    }
}

// MARK: - MatchCellDelegate
extension LeagueDetailsViewController: MatchCellDelegate {
    
    func didTapHomeTeam(in cell: MatchCell) {
        guard let indexPath = tableView.indexPath(for: cell) else { return }
        let fixture = presenter.fixture(at: indexPath.row, for: segmentControl.selectedSegmentIndex)
        navigateToTeamDetails(teamName: fixture.homeTeamName ?? "")
    }
    
    func didTapAwayTeam(in cell: MatchCell) {
        guard let indexPath = tableView.indexPath(for: cell) else { return }
        let fixture = presenter.fixture(at: indexPath.row, for: segmentControl.selectedSegmentIndex)
        navigateToTeamDetails(teamName: fixture.awayTeamName ?? "")
    }
}

// MARK: - Navigation
extension LeagueDetailsViewController {
    
    private func navigateToTeamDetails(with team: Team) {
        guard let vc = storyboard?.instantiateViewController(
            withIdentifier: "TeamDetailsViewController"
        ) as? TeamDetailsViewController else { return }
        vc.hidesBottomBarWhenPushed = true
        vc.teamName = team.name
        navigationController?.pushViewController(vc, animated: true)
    }
    
    private func navigateToTeamDetails(teamName: String) {
        guard let vc = storyboard?.instantiateViewController(
            withIdentifier: "TeamDetailsViewController"
        ) as? TeamDetailsViewController else { return }
        vc.hidesBottomBarWhenPushed = true
        vc.teamName = teamName
        navigationController?.pushViewController(vc, animated: true)
    }
}
