//
//  ListViewController.swift
//  On The Map
//
//  Created by Aaryan Kothari on 02/05/20.
//  Copyright © 2020 Aaryan Kothari. All rights reserved.
//

import UIKit

class ListViewController: UIViewController {
    
    
    var data = (UIApplication.shared.delegate as! AppDelegate).data.results

    @IBOutlet var studentDataTableView: UITableView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        NotificationCenter.default.addObserver(self, selector: #selector(loadList), name: NSNotification.Name(rawValue: "load"), object: nil)
        studentDataTableView.backgroundView = UIImageView(image:#imageLiteral(resourceName: "TableView background"))
        studentDataTableView.backgroundView?.contentMode = .scaleAspectFit
    }
    
    @objc func loadList(){
        data = (UIApplication.shared.delegate as! AppDelegate).data.results
        self.studentDataTableView.reloadData()
    }
}

extension ListViewController: UITableViewDataSource, UITableViewDelegate{
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return data.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = studentDataTableView.dequeueReusableCell(withIdentifier: "cell") as! StudentDataTableViewCell
        
        let student = data[indexPath.row]
        
        let fullName = student.firstName + " " + student.lastName
        
        cell.nameLabel.text = fullName
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        print(indexPath.row)
    }
}
