//
//  IssueCoreData+CoreDataProperties.swift
//  WOAI
//
//  Created by 양승완 on 4/25/25.
//
//

import Foundation
import CoreData


extension IssueCoreData {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<IssueCoreData> {
        return NSFetchRequest<IssueCoreData>(entityName: "IssueCoreData")
    }

    @NSManaged public var actionItems: [String]?
    @NSManaged public var details: String?
    @NSManaged public var issueName: String?
    @NSManaged public var meetingTask: MeetingTaskCoreData?

}

extension IssueCoreData : Identifiable {

}
