//
//  DetailInformView.swift
//  WOAI
//
//  Created by 양승완 on 5/21/25.
//

import SwiftUI

struct DetailInformView: View {
    @EnvironmentObject var router: AppRouter
    @StateObject var viewModel: DetailInformVM
    
    var body: some View {
        VStack {
            ZStack {
                HStack(alignment: .center) {
                    Spacer()
                        .frame(width: 20)
                    Image(systemName: "chevron.backward")
                        .resizable()
                        .aspectRatio(contentMode: .fit)
                        .frame(width: 20,height: 20)
                        .foregroundStyle(.black)
                        .onTapGesture {
                            router.pop()
                        }
                    Spacer()
                }
                Text("DetailInform")
                    .font(.title3)
                    .padding(.horizontal)
                    .foregroundStyle(.black)
            }
//            let meetingTitle: String
//            let meetingSummary: String
//            let recordedAt: String
//            let issues: [Issue]
//            let timeline: [Timeline]
//            let schedulingTasks: [SchedulingTask]
            ScrollView {
                
                DetailInformTopView(viewModel: viewModel)
                DetailInformCenterView(viewModel: viewModel)
                   
                
            }

        }.background(Color.mainBackground)
        
       
    }
}



#Preview {
    DetailInformView(viewModel: DetailInformVM(meetingTask: MeetingTaskModel.init(meetingTitle: "", meetingSummary: "", recordedAt: "", dates: ("","","",""))))
}
