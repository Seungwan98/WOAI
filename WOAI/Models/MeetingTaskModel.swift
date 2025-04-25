//
//  MeetingTasks.swift
//  WOAI
//
//  Created by 양승완 on 4/24/25.
//

import Foundation

// MARK: - MeetingTask
struct MeetingTaskModel: Identifiable {
    var id: String { meetingTitle }
    
    let meetingTitle: String
    let meetingSummary: String
    let recordedAt: String
    let issues: [Issue]
    let timeline: [Timeline]
    let schedulingTasks: [SchedulingTask]

}

