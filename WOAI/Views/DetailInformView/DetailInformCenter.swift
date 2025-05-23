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
                Text("Issues")
                    .font(.title)
                    .bold()
                    .padding(.horizontal)
                    .foregroundStyle(Color.mainColor)
                Spacer()
            }.padding(.vertical)
            
            
            VStack(spacing: 10) {
                ForEach(viewModel.meetingTask.issues, id: \.self) { issue in
                    VStack {
                        Text("\(issue.issueName)")
                            .foregroundStyle(Color.mainColor)
                        .frame(maxWidth: .infinity, alignment: .leading)
                        .padding(4)

                        Text("\(issue.details)")
                        .foregroundStyle(Color.mainColor)
                        .frame(maxWidth: .infinity, alignment: .leading)
                        .padding(4)
                        
                    }.background(Color.mainBackground) .clipShape(RoundedRectangle(cornerRadius: 10))
                    
                }
            }.padding(.horizontal)
            Spacer().frame(height: 10)

            
        }.frame(maxWidth: .infinity)
            .background(Color.white)
            .clipShape(RoundedRectangle(cornerRadius: 10))
            .padding(.horizontal)
        
        
        Spacer().frame(height: 6)
        
        VStack {
            HStack {
                Text("TimeLine")
                    .font(.title)
                    .bold()
                    .padding(.all)
                    .foregroundStyle(Color.mainColor)
                Spacer()
            }

            
            VStack(spacing: 10) {
                ForEach(viewModel.meetingTask.timeline, id: \.self) { timeline in
                    VStack {
                        Text("\(timeline.time)")
                            .foregroundStyle(Color.mainColor)
                        .frame(maxWidth: .infinity, alignment: .leading)
                        .padding(4)

                        Text("\(timeline.discussion)")
                        .foregroundStyle(Color.mainColor)
                        .frame(maxWidth: .infinity, alignment: .leading)
                        .padding(4)
                        
                    }.background(Color.mainBackground) .clipShape(RoundedRectangle(cornerRadius: 10))
                    
                }
            }.padding(.horizontal)
            Spacer().frame(height: 10)
        }.frame(maxWidth: .infinity)
            .background(Color.white)
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
