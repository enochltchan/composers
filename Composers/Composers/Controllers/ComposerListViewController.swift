//
//  ViewController.swift
//  Composers
//
//  Created by Enoch Chan on 4/2/21.
//

import UIKit

class ComposerListViewController: UIViewController, UISearchResultsUpdating, UISearchBarDelegate {
    
    let searchController = UISearchController()
    
    @IBOutlet weak var tableView: UITableView!
    
    //force unwrapping means that we take responsibility that the variable is never nil when accessed, otherwise the app will crash
    //we can assign a default value to list of composers that is an empty list to show that instead of having the app crashing
//    var composersList: [Composer] = []
    var composerService: ComposerService!
    
    var filteredComposers: [Composer] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
        initSearchController()
        // Do any additional setup after loading the view.
        self.composerService = ComposerService()
        
        self.tableView.dataSource = self
        self.tableView.delegate = self
    }
    
    func initSearchController() {
        searchController.loadViewIfNeeded()
        searchController.searchResultsUpdater = self
        searchController.obscuresBackgroundDuringPresentation = false
        searchController.searchBar.enablesReturnKeyAutomatically = false
        searchController.searchBar.returnKeyType = UIReturnKeyType.done
        definesPresentationContext = true
        
        navigationItem.searchController = searchController
        navigationItem.hidesSearchBarWhenScrolling = false
        searchController.searchBar.scopeButtonTitles = ["All", "Baroque", "Classical", "Romantic", "20th Century"]
        searchController.searchBar.delegate = self
    }
    
    override func viewWillAppear(_ animated: Bool) {
        // source: http://swiftdeveloperblog.com/code-examples/create-uiactivityindicatorview-programmatically/
        let spinner = UIActivityIndicatorView(style: UIActivityIndicatorView.Style.large)
        spinner.center = view.center
        // hide spinner when stopAnimating() is called
        spinner.hidesWhenStopped = true
        spinner.startAnimating()
        view.addSubview(spinner)
        
        guard let confirmedService = self.composerService else { return }
        
        confirmedService.getComposers(completion: { composers, error in guard let composers = composers, error == nil else {
                let alert = UIAlertController(title: "Error fetching data", message: "There was an error fetching composer data.", preferredStyle: .alert)
                alert.addAction(UIAlertAction(title: NSLocalizedString("OK", comment: "Default action"), style: .default, handler: { _ in
                NSLog("The \"OK\" alert occured.")
                }))
                self.present(alert, animated: true, completion: nil)
                return
            }
        // Call stopAnimating() now that data has loaded
        spinner.stopAnimating()
        if (global.composersList.count == 0) {
            global.composersList = composers
        }
        
        // if the API call returns no composers
        if global.composersList.count == 0 {
            let alert = UIAlertController(title: "No composers available", message: "There are no composers available at this time.", preferredStyle: .alert)
            alert.addAction(UIAlertAction(title: NSLocalizedString("OK", comment: "Default action"), style: .default, handler: { _ in
            NSLog("The \"OK\" alert occured.")
            }))
            self.present(alert, animated: true, completion: nil)
        }
        
        self.tableView.reloadData() // need to reload tableView every time new data is pulled in
        })
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // refactor to combine all three conditions together with a guard
        guard
            let destination = segue.destination as? DetailViewController,
            let selectedIndexPath = self.tableView.indexPathForSelectedRow,
            let confirmedCell = self.tableView.cellForRow(at: selectedIndexPath) as? ComposerCell else { return }
        
        let confirmedComposer = confirmedCell.composer
        destination.composer = confirmedComposer
    }
}

extension ComposerListViewController: UITableViewDataSource {
    //extension adds the below functionality to the class it is extending
    //DataSource deals with what data is in the table
    //MARK: DataSource

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if(searchController.isActive) {
            return self.filteredComposers.count
        } else {
            return global.composersList.count
        }
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        //as! force downcasts the tableView cell to be a ComposerCell
        let cell = self.tableView.dequeueReusableCell(withIdentifier: "composerCell") as! ComposerCell
        
        if(searchController.isActive) {
            let currentComposer = self.filteredComposers[indexPath.row]
            cell.composer = currentComposer
        } else {
            let currentComposer = global.composersList[indexPath.row]
            cell.composer = currentComposer
        }
        return cell
    }
}

extension ComposerListViewController: UITableViewDelegate {
    //Delegate deals with the look and feel of the table; methods that don't need to be implemented
    //MARK: Delegate
    
    // source: https://useyourloaf.com/blog/table-swipe-actions/
    func tableView(_ tableView: UITableView, trailingSwipeActionsConfigurationForRowAt indexPath: IndexPath) -> UISwipeActionsConfiguration? {
        
        let cell = self.tableView.cellForRow(at: indexPath) as? ComposerCell
        let confirmedComposer: Composer
        if(searchController.isActive) {
            confirmedComposer = self.filteredComposers[indexPath.row]
            print(self.filteredComposers)
        } else {
            confirmedComposer = cell!.composer!
        }
//        let confirmedComposer = cell!.composer!
        
        let title = confirmedComposer.favorite ?
            NSLocalizedString("Unfavorite", comment: "Unfavorite") :
            NSLocalizedString("Favorite", comment: "Favorite")
        
        let action = UIContextualAction(style: .normal, title: title,
            handler: { (action, view, completionHandler) in
            // Update data source when user taps action
                confirmedComposer.favorite = !confirmedComposer.favorite
//                if confirmedComposer.favorite {
//                    let heart = UIImageView(frame: CGRect(x: 0, y: 65, width: 40, height: 30))
//                    heart.image = UIImage(systemName: "heart.fill")
//                    heart.tintColor = .systemRed
//                    if (cell!.composer!.favorite) {
//                        cell!.accessoryView = heart
//                    } else {
//                        cell!.accessoryView = .none
//                    }
//                } else {
//                    cell!.accessoryView = .none
//                }
                
                completionHandler(true)
            })
        
        action.image = UIImage(named: "heart")
        action.backgroundColor = confirmedComposer.favorite ? .red : .green
        let configuration = UISwipeActionsConfiguration(actions: [action])
        
        return configuration
    }
    
    func tableView(_ tableView: UITableView, leadingSwipeActionsConfigurationForRowAt indexPath: IndexPath) -> UISwipeActionsConfiguration? {
        let cell = self.tableView.cellForRow(at: indexPath) as? ComposerCell
        let confirmedComposer = cell!.composer!
        
        // source: https://medium.com/swiftcommmunity/get-country-flag-from-code-string-f38cf157f2e6
        func countryFlag(countryCode: String) -> String {
          let base = 127397
          var tempScalarView = String.UnicodeScalarView()
          for i in countryCode.utf16 {
            if let scalar = UnicodeScalar(base + Int(i)) {
              tempScalarView.append(scalar)
            }
          }
          return String(tempScalarView)
        }
        
        let flag = countryFlag(countryCode: confirmedComposer.country)
        let action = UIContextualAction(style: .normal, title: flag,
            handler: { (action, view, completionHandler) in
                completionHandler(true)
            })
        
        let configuration = UISwipeActionsConfiguration(actions: [action])
        
        return configuration
    }
    
    // source for search bar: https://www.youtube.com/watch?v=DAHG0orOxKo
    func updateSearchResults(for searchController: UISearchController) {
        let searchBar = searchController.searchBar
        let scopeButton = searchBar.scopeButtonTitles![searchBar.selectedScopeButtonIndex]
        let searchText = searchBar.text!
        
        filterForSearchTextAndScopeButton(searchText: searchText, scopeButton: scopeButton)
    }
    
    func filterForSearchTextAndScopeButton(searchText: String, scopeButton: String = "All") {
        self.filteredComposers = global.composersList.filter {
            composer in
            let scopeMatch = (scopeButton == "All" || composer.period.lowercased().contains(scopeButton.lowercased()))
            if(searchController.searchBar.text != "") {
                let searchTextMatch = composer.name.lowercased().contains(searchText.lowercased())
                return scopeMatch && searchTextMatch
            } else {
                return scopeMatch
            }
        }
        tableView.reloadData()
        
    }
}

struct global {
    static var composersList: [Composer] = []
}
