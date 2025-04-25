//
//  SchedulingTaskCoreData+CoreDataProperties.swift
//  WOAI
//
//  Created by 양승완 on 4/25/25.
//
//

import Foundation
import CoreData


extension SchedulingTaskCoreData {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<SchedulingTaskCoreData> {
        return NSFetchRequest<SchedulingTaskCoreData>(entityName: "SchedulingTaskCoreData")
    }

    @NSManaged public var date: String?
    @NSManaged public var participants: [String]?
    @NSManaged public var subject: String?
    @NSManaged public var time: String?
    @NSManaged public var meetingTask: MeetingTaskCoreData?

}

extension SchedulingTaskCoreData : Identifiable {

}
