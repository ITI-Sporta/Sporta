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
    

    override func viewDidLoad() {
        super.viewDidLoad()
        
        navigationController?.setNavigationBarHidden(false, animated: false)
        title = "Sporta"
        
        setupIndicator()
        presenter = LeaguesPresenter(view: self, sport: sport)
        setupRefreshControl()
        setupTableView()
    }
    
    private func setupTableView() {
        let nib = UINib(nibName: "LeagueCell", bundle: nil)
        tableView.register(nib, forCellReuseIdentifier: "LeagueCell")
        tableView.delegate   = self
        tableView.dataSource = self
    }
    
    func setupIndicator() {
        activityIndicator.center = view.center
        activityIndicator.hidesWhenStopped = true
        view.addSubview(activityIndicator)
    }
    
    func setupRefreshControl() {
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
}

extension LeaguesViewController :LeaguesViewProtocol {
    
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
        )

        alert.addAction(action)

        present(alert, animated: true)
    }
}

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
        
        let selectedLeague = presenter.getLeague(at: indexPath.row)

        guard let vc = storyboard?.instantiateViewController(
            withIdentifier: "FixturesViewController"
        ) as? FixturesViewController else {
            return
        }

        vc.currentLeague = selectedLeague

        navigationController?.pushViewController(vc, animated: true)
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        90
    }
    
    func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        "\(sport.displayName) Leagues"
    }
}
