//
//  EmployeeModel.swift
//  SQLiteTraining
//
//  Created by Isaías on 7/14/18.
//  Copyright © 2018 IsaiasMac. All rights reserved.
//

import Foundation
import SwiftyJSON
import GRDB
import CoreData
import AERecord
import SQift


class EmployeeModel {

    deinit {
        print("🤯 EmployeeModel deinit...")
    }
    
    func getEmployees(_ page: Int = 1) {
        print("getEmployees... page: \(page)")
        
        APIService.sharedInstance.get_Employees { (status, data) in
            if status == true {
                print("😁 status => \(status)")
                
                if let _data = data {
                    if _data.count > 0 {
                        do {
                            let decoder = JSONDecoder()
                            let employees = try decoder.decode([EmployeeEntity].self, from: _data)
                            
                            if employees.count > 0 {
                                print("employees > 0 ")
                                //self.saveEmployees(employees)
                                self.saveEmployeesWithSQlite(employees)
                                
                                if page <= 7 {
                                    self.getEmployees(page + 1)
                                }
                                else{
                                    NotificationCenter.default.post(name: NSNotification.Name("NS_FINISH"),
                                                                    object: nil,
                                                                    userInfo: nil)
                                }
                            }
                            
                        }
                        catch {
                            print("x Error => \(error.localizedDescription)")
                        }
                    }
                }
                
            }
            else {
                print("😱 status => \(status)")
            }
        }
    }
    
    private func saveEmployees(_ employees: [EmployeeEntity]) {
        do {
            try AERecord.loadCoreDataStack()
            
        }
        catch {
            print(error)
        }
        
        for e in employees {
            let attrs: [String: Any] = ["id": Int32(secureJson(e.id))!,
                                        "last_name": secureJson(e.lastName),
                                        "first_name": secureJson(e.firstName),
                                        "title": secureJson(e.title),
                                        "title_of_courtesy": secureJson(e.titleOfCourtesy),
                                        "notes": secureJson(e.notes),
                                        "photo_path": secureJson(e.photoPath)]
            
            Employee.create(with: attrs)
        }
        
        AERecord.save()
    }
    
    private func secureJson(_ val: String?) -> String {
        if let _val = val {
            return _val
        }
        
        return ""
    }

    public func loadEmployees() -> [Employee]? {
        do {
            try AERecord.loadCoreDataStack()
        }
        catch {
            print(error)
        }
        
        let sortDescriptor = NSSortDescriptor(key: "id", ascending: true,
                                              selector: #selector(NSString.localizedStandardCompare(_:)))
        
        let employees = Employee.all(orderedBy: [sortDescriptor], in: AERecord.Context.background)
        return employees as? [Employee]
    }
    
    private func loadDB() {
        do {
            let connection = try Connection(storageLocation: .onDisk(sqliteFile()))
            try connection.run("INSERT INTO cars VALUES(?, ?, ?)", 1, "Audi", 52_642)
        }
        catch {
            print("Error: \(error.localizedDescription)")
        }
        
        
    }
    
    func sqliteFile() -> String {
        var fileURL: URL?
        do {
            fileURL = try FileManager.default.url(for: .documentDirectory, in: .userDomainMask, appropriateFor: nil, create: false)
                .appendingPathComponent("myDB.sqlite")
        } catch {
            print("Error SQLITEDB => \(error.localizedDescription)")
        }
        
        return fileURL!.path
    }
    
    private func saveEmployeesWithSQlite(_ employees: [EmployeeEntity]) {
        let table = """
                    CREATE TABLE IF NOT EXISTS db_employees (
                        employee_id INT NOT NULL,
                        last_name VARCHAR(20),
                        first_name VARCHAR(10),
                        title VARCHAR(30),
                        title_of_courtesy VARCHAR(25),
                        address VARCHAR(60),
                        city VARCHAR(15),
                        region VARCHAR(15),
                        postal_code VARCHAR(10),
                        country VARCHAR(15),
                        home_phone VARCHAR(24),
                        extension VARCHAR(4),
                        notes TEXT,
                        reports_to SMALLINT,
                        photo_path VARCHAR(255)
                    );
                    """
        
        let tableCategories = """
                        CREATE TABLE IF NOT EXISTS db_categories (
                            category_id SMALLINT PRIMARY KEY,
                            category_name VARCHAR(15) NOT NULL,
                            description TEXT
                        );

"""
        do {
            let connection = try Connection(storageLocation: .onDisk(sqliteFile()))
            try connection.run(table)
            try connection.run(tableCategories)
            
//            let insert = """
//                INSERT OR REPLACE INTO db_employees(employee_id, last_name, first_name, title, title_of_courtesy, address, city, region, postal_code, country, home_phone, extension, notes, reports_to, photo_path) VALUES (?,?,?,?,?,?,?,?,?,?,?,?,?,?,?)
//            """
//            for e in employees {
//                try connection.run(insert, Int32(secureJson(e.id))!, secureJson(e.lastName),
//                                   secureJson(e.firstName), secureJson(e.title),
//                                   secureJson(e.titleOfCourtesy), secureJson(e.address),
//                                   secureJson(e.city), secureJson(e.region),
//                                   secureJson(e.postalCode), secureJson(e.country),
//                                   secureJson(e.homePhone), secureJson(e.eextension),
//                                   secureJson(e.notes), secureJson(e.reportsTo),
//                                   secureJson(e.photoPath))
//            }
        }
        catch {
            print("Error: \(error.localizedDescription)")
        }
        
        
        
    }
}
