//
//  DataModel.swift
//  NomadStory
//
//  Created by Ahmed on 6/15/22.
//

import Foundation

// MARK: - DataModelValue
struct DataModelValue: Codable {
    let barcode, dataModelDescription, id: String
    let imageURL: String
    let name: String
    let retailPrice: Int
    let costPrice: Int?

    enum CodingKeys: String, CodingKey {
        case barcode
        case dataModelDescription = "description"
        case id
        case imageURL = "image_url"
        case name
        case retailPrice = "retail_price"
        case costPrice = "cost_price"
    }
    
    static let database = DatabaseHandler.shared
    func store() {
        guard let data = DataModelValue.database.add(OfflineStorageModel.self) else { return }
        data.id = id
        data.barcode = barcode
        data.dataModelDescription = dataModelDescription
        data.imageURL = imageURL
        data.name = name
        data.retailPrice = Int16(retailPrice)
        data.costPrice = Int16(costPrice ?? 0)
        
        DataModelValue.database.save()
        
    }
    
}

typealias DataModel = [String: DataModelValue]
