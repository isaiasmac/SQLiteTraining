//
//  SyncingVC.swift
//  SQLiteTraining
//
//  Created by Isaías on 7/14/18.
//  Copyright © 2018 IsaiasMac. All rights reserved.
//

import UIKit
import Lottie
import Alamofire
import SwiftyJSON

class SyncingVC: UIViewController {
    
    let animationView = LOTAnimationView(name: "const2")
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
//        let employeeModel = EmployeeModel()
//        employeeModel.getEmployees(1)
        
//        let categoryModel = CategoryModel()
//        categoryModel.getCategories()

        let customerModel = CustomerModel()
        customerModel.getCustomers()
        
//        let sqlFile = employeeModel.sqliteFile()
//        print("SQLFile => \(sqlFile)")
        
        configUI()
        
        print("PATH => \(CoreDataStack.applicationDocumentsDirectory)")
        
        NotificationCenter.default.addObserver(self, selector: #selector(loadEmployeesVC),
                                               name: NSNotification.Name("NS_FINISH"),
                                               object: nil)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        animationView.play()
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        animationView.stop()
    }
    
    deinit {
        print("denit SyncingVC...")
    }

    //MARK: Methods
    
    private func configUI() {
        self.view.backgroundColor = .white
        animationView.frame = CGRect(x: 0, y: -10.0, width: self.view.frame.width, height: 400)
        animationView.center = self.view.center
        animationView.contentMode = .scaleAspectFill
        animationView.loopAnimation = true
        view.addSubview(animationView)
    }
    
    @objc func loadEmployeesVC() {
        print("finish...")
        
        DispatchQueue.main.async {
            if let navCtrl = self.navigationController {
                navCtrl.pushViewController(EmployeesVC(), animated: true)
            }
            else{
                self.present(EmployeesVC(), animated: true, completion: nil)
            }
        }
    }
    
}
