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
    
    let startDateDays: String
    let startDateTime: String
    let finishDateDays: String
    let finishDateTime: String
    
    
    // ✅ 직접 사용하는 init
    init(
        meetingTitle: String,
        meetingSummary: String,
        recordedAt: String,
        issues: [Issue] = [],
        timeline: [Timeline] = [],
        schedulingTasks: [SchedulingTask] = [],
        dates: (String, String, String, String)
    ) {
        self.meetingTitle = meetingTitle
        self.meetingSummary = meetingSummary
        self.recordedAt = recordedAt
        self.issues = issues
        self.timeline = timeline
        self.schedulingTasks = schedulingTasks
        self.startDateDays = dates.0
        self.startDateTime = dates.1
        self.finishDateDays = dates.2
        self.finishDateTime = dates.3
        
    }
}

