//
//  MeetingTasks.swift
//  WOAI
//
//  Created by 양승완 on 4/24/25.
//

import Foundation

// MARK: - MeetingTask
struct MeetingTaskDTO: Codable {
    var uuid: UUID?
    let meetingTitle: String
    let meetingSummary: String
    let recordedAt: String
    let issues: [Issue]
    let timeline: [Timeline]
    let schedulingTasks: [SchedulingTask]

    
    
    enum CodingKeys: String, CodingKey {
        case issues = "Issues"
        case timeline = "Timeline"
        case schedulingTasks = "SchedulingTasks"
        case meetingTitle = "MeetingTitle"
        case meetingSummary = "MeetingSummary"
        case recordedAt = "RecordedAt"
    }
}

// MARK: - SchedulingTask
struct SchedulingTask: Codable, Hashable {
    let subject, date, time: String
    let participants: [String]

    enum CodingKeys: String, CodingKey {
        case subject = "Subject"
        case date = "Date"
        case time = "Time"
        case participants = "Participants"
    }
}

// MARK: - Task
struct Issue: Codable, Hashable {
    let issueName, details: String
    let actionItems: [String]

    enum CodingKeys: String, CodingKey {
        case issueName = "IssueName"
        case details = "Details"
        case actionItems = "ActionItems"
    }
}

// MARK: - Timeline
struct Timeline: Codable, Hashable {
    let time, discussion: String

    enum CodingKeys: String, CodingKey {
        case time = "Time"
        case discussion = "Discussion"
    }
}


