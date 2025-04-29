//
//  MeetingTaskCoreData+CoreDataProperties.swift
//  WOAI
//
//  Created by 양승완 on 4/25/25.
//
//

import Foundation
import CoreData


extension MeetingTaskCoreData {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<MeetingTaskCoreData> {
        return NSFetchRequest<MeetingTaskCoreData>(entityName: "MeetingTaskCoreData")
    }

    @NSManaged public var meetingTitle: String?
    @NSManaged public var meetingSummary: String?
    @NSManaged public var recordedAt: String?
    @NSManaged public var issues: NSSet?
    @NSManaged public var schedulingTasks: NSSet?
    @NSManaged public var timeline: NSSet?
    @NSManaged public var startRecorded: Date?
    @NSManaged public var finishRecorded: Date?

}

// MARK: Generated accessors for issues
extension MeetingTaskCoreData {

    @objc(addIssuesObject:)
    @NSManaged public func addToIssues(_ value: IssueCoreData)

    @objc(removeIssuesObject:)
    @NSManaged public func removeFromIssues(_ value: IssueCoreData)

    @objc(addIssues:)
    @NSManaged public func addToIssues(_ values: NSSet)

    @objc(removeIssues:)
    @NSManaged public func removeFromIssues(_ values: NSSet)

}

// MARK: Generated accessors for schedulingTasks
extension MeetingTaskCoreData {

    @objc(addSchedulingTasksObject:)
    @NSManaged public func addToSchedulingTasks(_ value: SchedulingTaskCoreData)

    @objc(removeSchedulingTasksObject:)
    @NSManaged public func removeFromSchedulingTasks(_ value: SchedulingTaskCoreData)

    @objc(addSchedulingTasks:)
    @NSManaged public func addToSchedulingTasks(_ values: NSSet)

    @objc(removeSchedulingTasks:)
    @NSManaged public func removeFromSchedulingTasks(_ values: NSSet)

}

// MARK: Generated accessors for timeline
extension MeetingTaskCoreData {

    @objc(addTimelineObject:)
    @NSManaged public func addToTimeline(_ value: TimelineCoreData)

    @objc(removeTimelineObject:)
    @NSManaged public func removeFromTimeline(_ value: TimelineCoreData)

    @objc(addTimeline:)
    @NSManaged public func addToTimeline(_ values: NSSet)

    @objc(removeTimeline:)
    @NSManaged public func removeFromTimeline(_ values: NSSet)

}

extension MeetingTaskCoreData : Identifiable {

}
