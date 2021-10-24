//
//  SearchHistoryItem+CoreDataProperties.swift
//  Evaluation Test (Fora Soft)
//
//  Created by Andrey Alymov on 22.10.2021.
//
//

import Foundation
import CoreData


extension SearchHistoryItem {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<SearchHistoryItem> {
        return NSFetchRequest<SearchHistoryItem>(entityName: "SearchHistoryItem")
    }

    @NSManaged public var name: String?
    @NSManaged public var collectionId: String?

}

extension SearchHistoryItem : Identifiable {

}
