//
//  OfflineStorageModel.swift
//  NomadStory
//
//  Created by Ahmed on 6/15/22.
//

import Foundation
import CoreData

@objc(Model)
public class OfflineStorageModel: NSManagedObject {
    
    @NSManaged var barcode, dataModelDescription, id: String
    @NSManaged var imageURL: String
    @NSManaged var name: String
    @NSManaged var retailPrice: Int16
    @NSManaged var costPrice: Int16
    
}
