//
//  DetailInformVM.swift
//  WOAI
//
//  Created by 양승완 on 5/21/25.
//

import Foundation

class DetailInformVM: ObservableObject {
    @Published var meetingTask: MeetingTaskModel
    
    init(meetingTask: MeetingTaskModel) {
        self.meetingTask = meetingTask
    }
    
    
    private let dateFormatter = DateFormatter()

    
   
    
}
