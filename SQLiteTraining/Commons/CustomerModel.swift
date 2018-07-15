//
//  CustomerModel.swift
//  SQLiteTraining
//
//  Created by Isaías on 7/14/18.
//  Copyright © 2018 IsaiasMac. All rights reserved.
//

import Foundation

class CustomerModel {
    
    deinit {
        print("🤯 CustomerModel deinit...")
    }
    
    func getCustomers() {
        print("getCustomers")
        
        APIService.sharedInstance.getCustomersClassic { (status, customers) in
            if status == true {
                self.save(customers)
            }
        }
        
//        APIService.sharedInstance.getCustomers { (status, data) in
//            if status == true {
//                print("😁 status => \(status)")
//                
//                if let _data = data {
//                    if _data.count > 0 {
//                        do {
//                            let decoder = JSONDecoder()
//                            let categories = try decoder.decode([CustomerEntity].self, from: _data)
//                            self.save(categories)
//                        }
//                        catch {
//                            print("x Error => \(error.localizedDescription)")
//                        }
//                    }
//                }
//                
//            }
//            else {
//                print("😱 status => \(status)")
//            }
//        }
    }
    
    private func save(_ customers: [CustomerEntity]?) {
        guard let _customers = customers else {
            return
        }
        
        let tableCustomers = """
                        CREATE TABLE IF NOT EXISTS db_customer2 (
                            id SMALLINT PRIMARY KEY,
                            name VARCHAR(125),
                            note TEXT,
                            phone_number VARCHAR(25),
                            progress SMALLINT,
                            credit_card VARCHAR(15)
                        );
        """
        
        do {
            let connection = SQLiteManager.connect()
            try connection.run(tableCustomers)
            
            let insert = """
                INSERT OR REPLACE INTO db_customer2(id, name, note, phone_number, progress, credit_card) VALUES (?,?,?,?,?,?)
            """
            
            for c in _customers {
                try connection.run(insert, c.id,
                                   Utils.secureJson(c.name),
                                   Utils.secureJson(c.note),
                                   Utils.secureJson(c.phone_number),
                                   c.progress,
                                   Utils.secureJson(c.credit_card))
            }
        }
        catch {
            print("Error: \(error.localizedDescription)")
        }
    }
}
