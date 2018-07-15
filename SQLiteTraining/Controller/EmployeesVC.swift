//
//  EmployeesVC.swift
//  SQLiteTraining
//
//  Created by Isaías on 7/14/18.
//  Copyright © 2018 IsaiasMac. All rights reserved.
//

import UIKit

class EmployeesVC: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()

        self.view.backgroundColor = .white
        
        loadEmployees()
    }
    
    private func loadEmployees() {
        let employeeModel = EmployeeModel()
        let employees = employeeModel.loadEmployees()
        
        guard let _employees = employees else {
            return
        }
        
        print("COUNT => \(_employees.count)")
        
        for e in _employees {
            print("ID => \(e.id)")
        }
    }
}
