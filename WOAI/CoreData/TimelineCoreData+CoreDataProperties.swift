//
//  TimelineCoreData+CoreDataProperties.swift
//  WOAI
//
//  Created by 양승완 on 4/25/25.
//
//

import Foundation
import CoreData


extension TimelineCoreData {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<TimelineCoreData> {
        return NSFetchRequest<TimelineCoreData>(entityName: "TimelineCoreData")
    }

    @NSManaged public var discussion: String?
    @NSManaged public var time: String?
    @NSManaged public var meetingTask: MeetingTaskCoreData?

}

extension TimelineCoreData : Identifiable {

}
