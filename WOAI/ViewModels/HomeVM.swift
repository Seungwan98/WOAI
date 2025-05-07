import Foundation
import CoreData
import Combine

class HomeVM: ObservableObject {
    
    @Published var meetings: [MeetingTaskModel] = []
    @Published var todaysMeetings: [MeetingTaskModel] = []
    
    private let dateFormatter = DateFormatter()

    
    func onAppear() {
        let context = CoreDataManager.shared.container.viewContext
        
        let fetchRequest = MeetingTaskCoreData.fetchRequest()
        
        do {
            let allMeetings = try context.fetch(fetchRequest)
            
            let newMeeting = allMeetings.map {
                var issueModels: [Issue] = []
                var timelineModels: [Timeline] = []
                var schedulingTaskModels: [SchedulingTask] = []
                if let issues = $0.issues {
                    for i in issues.allObjects as! [IssueCoreData] {
                        let issue = Issue(issueName: i.issueName ?? "", details: i.details ?? "", actionItems: i.actionItems ?? [])
                        issueModels.append(issue)
                    }
                }
                if let timeline = $0.timeline {
                    for t in timeline.allObjects as! [TimelineCoreData] {
                        timelineModels.append(Timeline(time: t.time ?? "", discussion: t.discussion ?? ""))
                    }
                }
                if let schedulingTasks = $0.schedulingTasks {
                    for s in schedulingTasks.allObjects as! [SchedulingTaskCoreData] {
                        schedulingTaskModels.append(SchedulingTask(subject: s.subject ?? "", date: s.date ?? "", time: s.time ?? "", participants: s.participants ?? []))
                    }
                }
            
                

                let getterDates = getDateFormatted(startRecorded: $0.startRecorded, finishRecorded: $0.finishRecorded)
                
                
                return MeetingTaskModel(meetingTitle: $0.meetingTitle ?? "", meetingSummary: $0.meetingSummary ?? "", recordedAt: $0.recordedAt ?? "", issues: issueModels, timeline: timelineModels, schedulingTasks: schedulingTaskModels, dates: getterDates )
            }
            
            let calendar = Calendar.current

          

            // 오늘 날짜만 남기기
            self.todaysMeetings = newMeeting.filter { meet in
                
                if let day = TimeManager.shared.getUntilDaysDate(inputDate: meet.startDateDays) {
                    return  calendar.isDate(.now, inSameDayAs: day )

                } else {
                    return false
                }
                
                
            }
            
            self.meetings = newMeeting
            
            
        } catch {
            print("❌ 가져오기 실패: \(error)")
            
            
        }
    }
    
    func getDateFormatted(startRecorded: Date?, finishRecorded: Date?) -> (String,String,String,String) {
        var startDateDays = ""
        var startDateTime = ""
        var finishDateDays = ""
        var finishDateTime = ""
        if let startRecorded {
            startDateDays = TimeManager.shared.getUntilDays(inputDate: startRecorded)
            startDateTime = TimeManager.shared.getOnlyTimes(inputDate: startRecorded)
        }
      
        if let finishRecorded {
            finishDateDays = TimeManager.shared.getUntilDays(inputDate: finishRecorded)
            finishDateTime = TimeManager.shared.getOnlyTimes(inputDate: finishRecorded)
        }

        return (startDateDays, startDateTime, finishDateDays, finishDateTime)
    }
    
    
}
