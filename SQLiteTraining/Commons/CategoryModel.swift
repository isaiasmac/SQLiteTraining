//
//  CategoryModel.swift
//  SQLiteTraining
//
//  Created by Isaías on 7/14/18.
//  Copyright © 2018 IsaiasMac. All rights reserved.
//

import Foundation
import SQift


class CategoryModel {
    
    deinit {
        print("🤯 CategoryModel deinit...")
    }
    
    func getCategories() {
        print("getCategories")
        
        APIService.sharedInstance.getCategories { (status, data) in
            if status == true {
                print("😁 status => \(status)")
                
                if let _data = data {
                    if _data.count > 0 {
                        do {
                            let decoder = JSONDecoder()
                            let categories = try decoder.decode([CategoryEntity].self, from: _data)
                            
                            self.save(categories)
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
    
    private func save(_ categories: [CategoryEntity]) {
        let tableCategories = """
                        CREATE TABLE IF NOT EXISTS db_categories (
                            category_id SMALLINT PRIMARY KEY,
                            category_name VARCHAR(15) NOT NULL,
                            description TEXT
                        );

"""
        do {
            let connection = SQLiteManager.connect()
            try connection.run(tableCategories)

            let insert = """
                INSERT OR REPLACE INTO db_categories(category_id, category_name, description) VALUES (?,?,?)
            """
            
            for c in categories {
                try connection.run(insert, Int32(Utils.secureJson(c.category_id))!,
                                           Utils.secureJson(c.category_name),
                                           Utils.secureJson(c.description))
            }
        }
        catch {
            print("Error: \(error.localizedDescription)")
        }
    }
}
