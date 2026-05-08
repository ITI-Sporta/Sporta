//
//  FixturesViewController.swift
//  Sporta
//
//  Created by Mohamed Ayman on 05/05/2026.
//

import UIKit

class LeagueDetailsViewController: UIViewController {

    // MARK: - Outlets
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var segmentControl: UISegmentedControl!
    @IBOutlet weak var leagueImageView: UIImageView!
    @IBOutlet weak var leagueNameLabel: UILabel!
    @IBOutlet weak var countrySeasonLabel: UILabel!
    var currentLeague: League!

    // MARK: - Properties
    private var fixtures: [Fixture] = []
    private var standings: [Standing] = []
    
    private var showingFixtures: Bool {
        return segmentControl.selectedSegmentIndex == 0
    }

    // MARK: - Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
    }

    private func setupUI() {
        let orange = UIColor(red: 255/255, green: 126/255, blue: 33/255, alpha: 1.0)
        segmentControl.selectedSegmentTintColor = orange
        segmentControl.setTitleTextAttributes([.foregroundColor: UIColor.white], for: .selected)
        
        leagueImageView.layer.cornerRadius = 8
        leagueImageView.clipsToBounds = true
    }

    @IBAction func segmentChanged(_ sender: UISegmentedControl) {
        UIView.transition(with: tableView, duration: 0.3, options: .transitionCrossDissolve, animations: {
            self.tableView.reloadData()
        })
    }
}
