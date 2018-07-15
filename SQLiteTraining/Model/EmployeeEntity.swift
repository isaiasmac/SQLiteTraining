//
//  Employee.swift
//  SQLiteTraining
//
//  Created by Isaías on 7/14/18.
//  Copyright © 2018 IsaiasMac. All rights reserved.
//

import Foundation

struct EmployeeEntity: Codable {
    var id: String
    var lastName: String?
    var firstName: String?
    var title: String?
    var titleOfCourtesy: String?
    var address: String?
    var city: String?
    var region: String?
    var postalCode: String?
    var country: String?
    var homePhone: String?
    var eextension: String?
    var notes: String?
    var reportsTo: String?
    var photoPath: String?
    
    private enum CodingKeys: String, CodingKey {
        case id = "employee_id"
        case title = "title"
        case lastName = "last_name"
        case firstName = "first_name"
        case titleOfCourtesy = "title_of_courtesy"
        case address = "address"
        case city = "city"
        case region = "region"
        case postalCode = "postal_code"
        case homePhone = "home_phone"
        case reportsTo = "reports_to"
        case photoPath = "photo_path"
        case country = "country"
        case notes = "notes"
        case eextension = "extension"
    }
}
