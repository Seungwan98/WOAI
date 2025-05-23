//
//  DetailInformVM.swift
//  WOAI
//
//  Created by 양승완 on 5/21/25.
//

import Foundation
import CoreData
import SwiftUICore

class DetailInformVM: ObservableObject {
    @Published var meetingTask: MeetingTaskModel
    @Published var popView = false
    
    init(meetingTask: MeetingTaskModel) {
        self.meetingTask = meetingTask
    }
    
    
    private let dateFormatter = DateFormatter()

    
        func deleteItemById() {
            let context = CoreDataManager.shared.container.viewContext
            let fetchRequest: NSFetchRequest<MeetingTaskCoreData> = MeetingTaskCoreData.fetchRequest()
            fetchRequest.predicate = NSPredicate(format: "recordedAt == %@", meetingTask.recordedAt as CVarArg)
                fetchRequest.fetchLimit = 1
                
                do {
                    if let objectToDelete = try context.fetch(fetchRequest).first {
                        context.delete(objectToDelete)
                        try context.save()
                        popView = true
                    } else {
                        print("삭제 대상 없음")
                    }
                } catch {
                    print("삭제 중 오류 발생: \(error)")
                }
           
        }
    
    
   
    
}
