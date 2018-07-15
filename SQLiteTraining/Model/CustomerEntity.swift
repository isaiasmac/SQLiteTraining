//
//  CustomerEntity.swift
//  SQLiteTraining
//
//  Created by Isaías on 7/14/18.
//  Copyright © 2018 IsaiasMac. All rights reserved.
//

import Foundation

struct CustomerEntity: Codable {
    var id: Int?
    var name: String?
    var address: String?
    var note: String?
    var phone_number: String?
    var progress: Int?
    var credit_card: String?
}
