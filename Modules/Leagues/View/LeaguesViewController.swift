//
//  LeaguesViewController.swift
//  Sporta
//
//  Created by Mohamed Ayman on 05/05/2026.
//

import UIKit

class LeaguesViewController: UIViewController {

    @IBOutlet weak var tableView: UITableView!
    var sport: Sport!
    var presenter: LeaguesPresenterProtocol!
    let activityIndicator = UIActivityIndicatorView(style: .large)
    let refreshControl = UIRefreshControl()
    private let searchController = UISearchController(searchResultsController: nil)

    override func viewDidLoad() {
        super.viewDidLoad()
        
        navigationController?.setNavigationBarHidden(false, animated: false)
        title = "Leagues"
        
        setupIndicator()
        presenter = LeaguesPresenter(view: self, sport: sport)
        setupRefreshControl()
        setupTableView()
        setupSearchController()
    }
    
    private func setupTableView() {
        let nib = UINib(nibName: "LeagueCell", bundle: nil)
        tableView.register(nib, forCellReuseIdentifier: "LeagueCell")
        tableView.delegate   = self
        tableView.dataSource = self
    }
    
    func setupIndicator() {
        activityIndicator.color = UIColor(red: 255/255, green: 126/255, blue: 33/255, alpha: 1.0)
        activityIndicator.center = view.center
        activityIndicator.hidesWhenStopped = true
        view.addSubview(activityIndicator)
    }
    
    func setupRefreshControl() {
        refreshControl.tintColor = UIColor(red: 255/255, green: 126/255, blue: 33/255, alpha: 1.0)
        refreshControl.addTarget(
            self,
            action: #selector(refreshData),
            for: .valueChanged
        )
        tableView.refreshControl = refreshControl
    }

    @objc func refreshData() {
        presenter.fetchData()
    }
    
    private func setupSearchController() {
        searchController.searchResultsUpdater = self
        searchController.obscuresBackgroundDuringPresentation = false
        searchController.searchBar.placeholder = "Search by name or country"
        searchController.searchBar.tintColor = UIColor(red: 255/255, green: 126/255, blue: 33/255, alpha: 1.0)
        navigationItem.searchController = searchController
        navigationItem.hidesSearchBarWhenScrolling = false
        definesPresentationContext = true
    }
}

// MARK: - LeaguesViewProtocol
extension LeaguesViewController: LeaguesViewProtocol {
    
    func showLoading() {
        activityIndicator.startAnimating()
    }
    
    func hideLoading() {
        refreshControl.endRefreshing()
        activityIndicator.stopAnimating()
    }
    
    func reloadData() {
        tableView.reloadData()
    }
    
    func showError(_ message: String) {
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

// MARK: - UITableViewDelegate, UITableViewDataSource
extension LeaguesViewController: UITableViewDelegate, UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        presenter.numberOfLeagues
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(
            withIdentifier: "LeagueCell",
            for: indexPath
        ) as! LeagueCell
        cell.configure(with: presenter.getLeague(at: indexPath.item))
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        
        guard let cell = tableView.cellForRow(at: indexPath) else { return }
        
        UIView.animate(withDuration: 0.1, animations: {
            cell.transform = CGAffineTransform(scaleX: 0.96, y: 0.96)
        }) { _ in
            UIView.animate(withDuration: 0.1, animations: {
                cell.transform = .identity
            }) { _ in
                let selectedLeague = self.presenter.getLeague(at: indexPath.row)

                guard let vc = self.storyboard?.instantiateViewController(
                    withIdentifier: "LeagueDetailsViewController"
                ) as? LeagueDetailsViewController else {
                    return
                }
                
                if NetworkMonitor.shared.isConnected {
                    vc.hidesBottomBarWhenPushed = true
                    vc.currentLeague = selectedLeague
                    vc.sport = self.sport
                    self.navigationController?.pushViewController(vc, animated: true)
                } else {
                    self.showError("No internet connection")
                }
            }
        }
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        90
    }
    
    func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        "\(sport.displayName) Leagues"
    }
}

// MARK: - UISearchResultsUpdating
extension LeaguesViewController: UISearchResultsUpdating {
    func updateSearchResults(for searchController: UISearchController) {
        presenter.search(query: searchController.searchBar.text ?? "")
    }
}
