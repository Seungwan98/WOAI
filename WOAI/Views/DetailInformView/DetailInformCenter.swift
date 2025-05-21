//
//  DetailInformTopView.swift
//  WOAI
//
//  Created by 양승완 on 5/21/25.
//

import SwiftUI

struct DetailInformCenterView: View {
    
    @ObservedObject var viewModel: DetailInformVM
    var body: some View {
        VStack {
            HStack {
                Text("issues")
                    .font(.title)
                    .bold()
                    .padding(.horizontal)
                    .foregroundStyle(Color.mainColor)
                
                Spacer()
                
            }.padding(.vertical)
            
            
            VStack {
                ForEach(viewModel.meetingTask.issues, id: \.self) { issue in
                    Text("\(issue.issueName)")
                    Text("-------")
                    Text("\(issue.details)")
                    
                    
                    
                }
            }

            
        }.frame(maxWidth: .infinity)
            .background(Color.red)
            .clipShape(RoundedRectangle(cornerRadius: 10))
            .padding(.horizontal)
        
        
        VStack {
            HStack {
                Text("TimeLine")
                    .font(.title)
                    .bold()
                    .padding(.horizontal)
                    .foregroundStyle(Color.mainColor)
                Spacer()
            }.padding(.vertical)
            
            
            VStack {
                ForEach(viewModel.meetingTask.timeline, id: \.self) { timeline in
                    Text("\(timeline.time)")
                    Text("\(timeline.discussion)")
                    Text("-------")
                    
                    
                    
                    
                }
            }

            
        }.frame(maxWidth: .infinity)
            .background(Color.red)
            .clipShape(RoundedRectangle(cornerRadius: 10))
            .padding(.horizontal)
            .onAppear {
                print(viewModel.meetingTask)
            }
    }
}

#Preview {
    DetailInformView(viewModel: DetailInformVM(meetingTask: MeetingTaskModel.init(meetingTitle: "", meetingSummary: "", recordedAt: "", dates: ("","","",""))))
}
