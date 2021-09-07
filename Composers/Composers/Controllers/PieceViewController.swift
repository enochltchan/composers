//
//  PieceViewController.swift
//  Composers
//
//  Created by Enoch Chan on 5/26/21.
//

import UIKit

class PieceViewController: UIViewController {
    

    @IBOutlet weak var tableView: UITableView!

    //force unwrapping means that we take responsibility that the variable is never nil when accessed, otherwise the app will crash
    //we can assign a default value to list of composers that is an empty list to show that instead of having the app crashing
//    var composersList: [Composer] = []
//    var composerService: ComposerService!
    var filteredComposers: [Composer] = []
    var pieceList: [Piece] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        self.filteredComposers = []
        self.pieceList = []
        
        self.tableView.dataSource = self
        self.tableView.delegate = self
    }
    
    
    override func viewWillAppear(_ animated: Bool) {
        self.filteredComposers = []
        self.pieceList = []
        
        // filter to favorited composers
        self.filteredComposers = global.composersList.filter {
            composer in
            let scopeMatch = (composer.favorite)
            return scopeMatch
        }
        
        for composer in self.filteredComposers {
            var piece1 = Piece(composer: composer.name, name: composer.pieceNames[0], url: composer.pieceUrls[0])
            self.pieceList.append(piece1)
            var piece2 = Piece(composer: composer.name, name: composer.pieceNames[1], url: composer.pieceUrls[1])
            self.pieceList.append(piece2)
        }
        
        self.tableView.reloadData() // need to reload tableView every time new data is pulled in
        }
    }


extension PieceViewController: UITableViewDataSource {
    //extension adds the below functionality to the class it is extending
    //DataSource deals with what data is in the table
    //MARK: DataSource
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.pieceList.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        //as! force downcasts the tableView cell to be a PieceCell
        let cell = self.tableView.dequeueReusableCell(withIdentifier: "pieceCell") as! PieceCell
        let currentPiece = self.pieceList[indexPath.row]
        cell.piece = currentPiece
        return cell
    }
}

extension PieceViewController: UITableViewDelegate {
    //Delegate deals with the look and feel of the table; methods that don't need to be implemented
    //MARK: Delegate
}


struct Piece: CustomDebugStringConvertible {
    var composer: String
    var name: String
    var url: String
    
    var debugDescription: String {
        // this code will be called each time debutDescription is accessed
        return "Piece(composer: \(self.composer), name: \(self.name))"
    }
}
