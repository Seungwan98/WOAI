//
//  MeetingTasks.swift
//  WOAI
//
//  Created by 양승완 on 4/24/25.
//

import Foundation

// MARK: - MeetingTask
struct MeetingTask: Codable {
    let issues: [Issue]
    let timeline: [Timeline]
    let schedulingTasks: [SchedulingTask]

    enum CodingKeys: String, CodingKey {
        case issues = "Issues"
        case timeline = "Timeline"
        case schedulingTasks = "SchedulingTasks"
    }
}

// MARK: - SchedulingTask
struct SchedulingTask: Codable {
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
struct Issue: Codable {
    let issueName, details: String
    let actionItems: [String]

    enum CodingKeys: String, CodingKey {
        case issueName = "IssueName"
        case details = "Details"
        case actionItems = "ActionItems"
    }
}

// MARK: - Timeline
struct Timeline: Codable {
    let time, discussion: String

    enum CodingKeys: String, CodingKey {
        case time = "Time"
        case discussion = "Discussion"
    }
}
