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
        title = "Favorites"
        presenter = FavoritesPresenter(view: self)
        setupTableView()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        presenter.reloadData()
    }
    
    private func setupTableView() {
        let nib = UINib(nibName: "LeagueCell", bundle: nil)
        let emptyNib = UINib(nibName: "EmptyTableCell", bundle: nil)
        tableView.register(nib, forCellReuseIdentifier: "LeagueCell")
        tableView.register(emptyNib, forCellReuseIdentifier: "EmptyTableCell")
        tableView.delegate   = self
        tableView.dataSource = self
    }

}

extension FavoritesViewController: FavoritesViewProtocol {
    
    func reloadData() {
        tableView.reloadData()
    }
    
    func deleteRowFromTable(at index: Int) {
        let indexPath = IndexPath(row: index, section: 0)
        tableView.performBatchUpdates({
            tableView.deleteRows(at: [indexPath], with: .automatic)
        }, completion: nil)
    }
    
    func reloadRowForEmptyState(at index: Int) {
        let indexPath = IndexPath(row: index, section: 0)
        tableView.performBatchUpdates({
            tableView.reloadRows(at: [indexPath], with: .automatic)
        }, completion: nil)
    }
    
    func show(type: ToastType, message: String) {
        ToastManager.shared.show(
            message: message,
            type: type,
            in: view
        )
    }
    
}


extension FavoritesViewController: UITableViewDelegate, UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if presenter.getLeaguesCount() == 0 {
                return 1
        } else {
            return presenter.getLeaguesCount()
        }
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        if presenter.getLeaguesCount() == 0 {
            let cell = tableView.dequeueReusableCell(
                withIdentifier: "EmptyTableCell",
                for: indexPath
            ) as! EmptyTableCell

            return cell
        } else {
            let cell = tableView.dequeueReusableCell(
                withIdentifier: "LeagueCell",
                for: indexPath
            ) as! LeagueCell
            cell.configure(with: presenter.getLeague(at: indexPath.row))
            return cell
        }
        
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        let selectedLeague = presenter.getLeague(at: indexPath.row)

        guard let vc = storyboard?.instantiateViewController(
            withIdentifier: "LeagueDetailsViewController"
        ) as? LeagueDetailsViewController else {
            return
        }
        if(presenter.isConnected()){
            vc.hidesBottomBarWhenPushed = true
            vc.currentLeague = selectedLeague.toLeague()
            vc.sport = selectedLeague.sport
            navigationController?.pushViewController(vc, animated: true)
        }
        else {
            show(type: .error, message: "No internet connection")
        }

        
        tableView.deselectRow(at: indexPath, animated: false)
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        if presenter.getLeaguesCount() == 0 {
            return tableView.bounds.height
        } else {
            return 90
        }
    }
    
    func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        "Favorite Leagues"
    }
    
    func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        true
    }
    
    func tableView(_ tableView: UITableView, trailingSwipeActionsConfigurationForRowAt indexPath: IndexPath) -> UISwipeActionsConfiguration? {
        let deleteAction = UIContextualAction(style: .destructive, title: nil) { [weak self] action, view, completion in
            guard let self = self else { return }
            self.showDeleteConfirmation(for: self.presenter.getLeague(at: indexPath.row), at: indexPath, completion: completion)
        }

        deleteAction.image = makeDeleteActionImage()
        deleteAction.backgroundColor = .secondarySystemBackground

        let config = UISwipeActionsConfiguration(actions: [deleteAction])
        config.performsFirstActionWithFullSwipe = false
        return config
    }

    private func makeDeleteActionImage() -> UIImage {
        let size = CGSize(width: 70, height: 90)
        let renderer = UIGraphicsImageRenderer(size: size)

        return renderer.image { ctx in
            let rectInset = CGRect(x: 4, y: 12, width: 62, height: 66)
            let roundedRect = UIBezierPath(roundedRect: rectInset, cornerRadius: 18)
            UIColor(red: 0.886, green: 0.294, blue: 0.290, alpha: 1).setFill()
            roundedRect.fill()

            let iconConfig = UIImage.SymbolConfiguration(pointSize: 20, weight: .regular)
            let icon = UIImage(systemName: "trash", withConfiguration: iconConfig)?
                .withTintColor(.white, renderingMode: .alwaysOriginal)
            let iconSize = icon?.size ?? .zero
            icon?.draw(at: CGPoint(
                x: rectInset.midX - iconSize.width / 2,
                y: rectInset.midY - iconSize.height / 2
            ))
        }
    }
    
    
}

extension FavoritesViewController {
    
    private func showDeleteConfirmation(for league: FavoriteLeague, at indexPath: IndexPath, completion: @escaping (Bool) -> Void) {
        
        AlertManager.showDeleteConfirmation(
            on: self,
            message: "Are you sure you want to delete \(league.name)?"
        ) { [weak self] confirmed in
            
            guard let self = self, confirmed else {
                completion(false)
                return
            }
            
            self.presenter.delete(league: league)
            completion(true)
        }
    }
}
