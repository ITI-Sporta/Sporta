//
//  FavoritesViewController.swift
//  Sporta
//
//  Created by Mohamed Ayman on 05/05/2026.
//

import UIKit

class FavoritesViewController: UIViewController {

    @IBOutlet weak var tableView: UITableView!

    var presenter: FavoritesPresenterProtocol!
    let activityIndicator = UIActivityIndicatorView(style: .large)
    
    let refreshControl = UIRefreshControl()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        navigationController?.setNavigationBarHidden(false, animated: false)
        title = "Sporta"
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
          presenter.reloadData()
      }
}

extension FavoritesViewController: FavoritesViewProtocol {
    func showLoading() {
    
    }
    
    func hideLoading() {
    
    }
    
    func reloadData() {
    
    }
    
    func shwoDeleteUndo(message: String) {
        
    }
    
    
}


extension FavoritesViewController: UITableViewDelegate, UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        presenter.leagues.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(
            withIdentifier: "LeagueCell",
            for: indexPath
        ) as! LeagueCell
        cell.configure(with: presenter.leagues[indexPath.row])
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        let selectedLeague = presenter.leagues[indexPath.row]

        guard let vc = storyboard?.instantiateViewController(
            withIdentifier: "LeagueDetailsViewController"
        ) as? LeagueDetailsViewController else {
            return
        }

        vc.currentLeague = selectedLeague.toLeague()
        vc.sport = selectedLeague.sport

        navigationController?.pushViewController(vc, animated: true)
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        90
    }
    
    func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        "Favorite Leagues"
    }
}
