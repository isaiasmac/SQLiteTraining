//
//  Utils.swift
//  SQLiteTraining
//
//  Created by Isaías on 7/14/18.
//  Copyright © 2018 IsaiasMac. All rights reserved.
//

import Foundation

class Utils {
    
    static func secureJson(_ val: String?) -> String {
        if let _val = val {
            return _val
        }
        
        return ""
    }
}
