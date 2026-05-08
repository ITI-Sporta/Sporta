//
//  LeagueDetailsViewController.swift
//  Sporta
//
//  Created by Mohamed Ayman on 05/05/2026.
//

import UIKit

class LeagueDetailsViewController: UIViewController {
    
    // MARK: - Outlets
    @IBOutlet weak var tableView:          UITableView!
    @IBOutlet weak var segmentControl:     UISegmentedControl!
    @IBOutlet weak var leagueImageView:    UIImageView!
    @IBOutlet weak var leagueNameLabel:    UILabel!
    @IBOutlet weak var countrySeasonLabel: UILabel!
    
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
                   heightForRowAt indexPath: IndexPath) -> CGFloat {
        UITableView.automaticDimension
    }
    
    func tableView(_ tableView: UITableView,
                   estimatedHeightForRowAt indexPath: IndexPath) -> CGFloat {
        120
    }
}

// MARK: - LeagueDetailsViewProtocol
extension LeagueDetailsViewController: LeagueDetailsViewProtocol {
    
    func showLoading() {
        DispatchQueue.main.async {
            self.spinner.startAnimating()
            self.tableView.isHidden = true
        }
    }
    
    func hideLoading() {
        DispatchQueue.main.async {
            self.spinner.stopAnimating()
            self.tableView.isHidden = false
        }
    }
    
    func reloadFixtures() {
        DispatchQueue.main.async {
            UIView.transition(
                with: self.tableView,
                duration: 0.3,
                options: .transitionCrossDissolve,
                animations: { self.tableView.reloadData() }
            )
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
