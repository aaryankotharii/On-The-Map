//
//  ListViewController.swift
//  On The Map
//
//  Created by Aaryan Kothari on 02/05/20.
//  Copyright © 2020 Aaryan Kothari. All rights reserved.
//

import UIKit

class ListViewController: UIViewController {
    
    //MARK: Outlets
    @IBOutlet var studentDataTableView: UITableView!
    
    
    //MARK:- StudentLocation Data
    var data = (UIApplication.shared.delegate as! AppDelegate).data.results
    
    //MARK: VC lifecycle methods
    override func viewDidLoad() {
        super.viewDidLoad()
        setupTableView()
        NotificationCenter.default.addObserver(self, selector: #selector(loadList), name: NSNotification.Name(rawValue: "load"), object: nil)
    }
    
    //MARK: TableView basic setup
    func setupTableView(){
        studentDataTableView.delegate = self
        studentDataTableView.dataSource = self
        studentDataTableView.backgroundView = UIImageView(image:#imageLiteral(resourceName: "TableView background"))
        studentDataTableView.backgroundView?.contentMode = .scaleAspectFit
    }
    
    @objc func loadList(){
        data = (UIApplication.shared.delegate as! AppDelegate).data.results
        self.studentDataTableView.reloadData()
    }
}


//MARK:- TableView DataSource Methods
extension ListViewController: UITableViewDataSource{
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return data.count       /// Number of cells
    }
        
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = studentDataTableView.dequeueReusableCell(withIdentifier: "cell") as! StudentDataTableViewCell
        
        let student = data[indexPath.row]
        
        let fullName = student.firstName + " " + student.lastName
        let mediaUrl = student.mediaURL
        
        cell.nameLabel.text = fullName
        cell.urlLabel.text = mediaUrl
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 75
    }
}


//MARK:- TableView Delegate Methods
extension ListViewController: UITableViewDelegate{
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        tableView.deselectRow(at: indexPath, animated: true)         ///Unhighlight cell after return

        let mediaUrl = data[indexPath.row].mediaURL                  /// URL Given by user
        
        presentSafari(mediaUrl)                                     /// Present Safari with URL
    }
}
