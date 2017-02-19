//
//  SmoothTableViewController.swift
//  Farmdrop
//
//  Created by James Beattie on 15/02/2017.
//  Copyright © 2017 James Beattie. All rights reserved.
//

import UIKit
import Moya
import Changeset
import ReactiveSwift
import ReactiveCocoa
import Result

class TableViewController: UITableViewController {
    
    @IBOutlet weak var searchBar: UISearchBar!
    
    var viewModel: TableViewModel!

    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Observes signal from the producerChangeset in the viewModel and updates the tableview.
        bindViewModel()
    }
    
    func bindViewModel() {
        viewModel.producerChangeset.producer.observe(on: UIScheduler()).startWithValues { (edits) in
            self.tableView.update(with: edits as! [Edit<Producer>])
        }
        
        searchBar.returnKeyType = .done
        _ = searchBar.reactive.continuousTextValues
            .map({ return $0 != nil ? $0! : ""})
            .observe({ [unowned self] (event) in
                if let val = event.value {
                    self.viewModel.search(searchString: val)
                }
            })
    }
    
    // MARK: - Table view data source

    override func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return viewModel.getProducersCount()
    }
    
    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 160
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "ProducerCell", for: indexPath) as! ProducerTableViewCell
        cell.setupViewModel(viewModel: viewModel.createDetailViewModel(forIndex: indexPath.row))
        return cell
    }
    
    override func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
        guard viewModel.getProducersCount() > 0 else { return }
        if (viewModel.getProducersCount() - Fetching.Threshold <= indexPath.row) {
            viewModel.fetchMoreProducers()
        }
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        searchBar.resignFirstResponder()
        performSegue(withIdentifier: "showProducerDetail", sender: self)
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "showProducerDetail" {
            guard let viewController = segue.destination as? DetailViewController else { return }
            guard let indexPath = tableView.indexPathForSelectedRow else { return }
            guard let selectedCell = tableView.cellForRow(at: indexPath) as? ProducerTableViewCell else { return }
            viewController.viewModel = selectedCell.viewModel
        
        }
    }
    
    override func scrollViewWillBeginDragging(_ scrollView: UIScrollView) {
        searchBar.resignFirstResponder()
    }
}
