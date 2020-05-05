//
//  ListViewController.swift
//  On The Map
//
//  Created by Aaryan Kothari on 02/05/20.
//  Copyright © 2020 Aaryan Kothari. All rights reserved.
//

import UIKit

class ListViewController: UIViewController {
    
    
    var studentData : [StudentInformation] {
        let object = UIApplication.shared.delegate
        let appDelegate = object as! AppDelegate
        return appDelegate.data.results
    }

    @IBOutlet var studentDataTableView: UITableView!
    
    override func viewDidLoad() {
       // studentDataTableView.delegate = self
        studentDataTableView.dataSource = self
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }
    
    func handleStudentData(studentData:[StudentInformation], error:Error?){
        print(studentData)
        //self.studentData = studentData
        DispatchQueue.main.async {   self.studentDataTableView.reloadData()  }
    }
}

extension ListViewController: UITableViewDataSource{
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return studentData.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = studentDataTableView.dequeueReusableCell(withIdentifier: "cell") as! StudentDataTableViewCell
        
        let student = studentData[indexPath.row]
        
        let fullName = student.firstName + " " + student.lastName
        
        cell.nameLabel.text = fullName
        
        return cell
    }
}
