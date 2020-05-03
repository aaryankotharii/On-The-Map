//
//  ListViewController.swift
//  On The Map
//
//  Created by Aaryan Kothari on 02/05/20.
//  Copyright © 2020 Aaryan Kothari. All rights reserved.
//

import UIKit

class ListViewController: UIViewController {
    
    var studentData = [StudentLocation]()

    override func viewDidLoad() {
        super.viewDidLoad()
        UdacityClient.getStudentLocation(completion: handleStudentData(studentData:error:))
        // Do any additional setup after loading the view.
    }
    
    func handleStudentData(studentData:[StudentLocation], error:Error?){
        self.studentData = studentData
    }
}

extension ListViewController: UITableViewDataSource{
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return studentData.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        //
    }
}
