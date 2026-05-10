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
        
    override func viewDidLoad() {
        super.viewDidLoad()
        navigationController?.setNavigationBarHidden(false, animated: false)
        title = "Sporta"
        presenter = FavoritesPresenter(view: self)
        setupTableView()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        presenter.reloadData()
    }
    
    private func setupTableView() {
        let nib = UINib(nibName: "LeagueCell", bundle: nil)
        tableView.register(nib, forCellReuseIdentifier: "LeagueCell")
        tableView.delegate   = self
        tableView.dataSource = self
    }

}

extension FavoritesViewController: FavoritesViewProtocol {
    
    func reloadData() {
        tableView.reloadData()
    }
    
    func show(title: String, message: String) {
        // TODO: Show something like a SnackBar
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
        vc.hidesBottomBarWhenPushed = true
        vc.currentLeague = selectedLeague.toLeague()
        vc.sport = selectedLeague.sport

        navigationController?.pushViewController(vc, animated: true)
        tableView.deselectRow(at: indexPath, animated: false)
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        90
    }
    
    func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        "Favorite Leagues"
    }
    
    func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        true
    }
    
    func tableView(_ tableView: UITableView, trailingSwipeActionsConfigurationForRowAt indexPath: IndexPath) -> UISwipeActionsConfiguration? {
        let deleteAction = UIContextualAction(style: .destructive, title: "Delete") { [weak self] action, view, completion in
            
            guard let self = self else {
                return
            }
            
            self.showDeleteConfirmation(for: self.presenter.leagues[indexPath.row], at: indexPath, completion: completion)
        }

        deleteAction.image = UIImage(systemName: "trash")
        deleteAction.backgroundColor = .systemRed

        let config = UISwipeActionsConfiguration(actions: [deleteAction])

        return config
    }
}

extension FavoritesViewController {
    
    private func showDeleteConfirmation(for league: FavoriteLeague, at indexPath: IndexPath, completion: @escaping (Bool) -> Void) {
        let alert = UIAlertController(
            title: "Delete Item?",
            message: "Are you sure you want to delete \(league.name)?",
            preferredStyle: .alert
        )

        let deleteAction = UIAlertAction(title: "Delete", style: .destructive) { [weak self] _ in
            guard let self = self else { return }
            
            self.presenter.delete(league: league)
            
            self.tableView.deleteRows(at: [indexPath], with: .automatic)
            completion(true)
        }

        let cancelAction = UIAlertAction(title: "Cancel", style: .cancel) { _ in
            completion(false)
        }

        alert.addAction(deleteAction)
        alert.addAction(cancelAction)

        present(alert, animated: true)
    }
}
