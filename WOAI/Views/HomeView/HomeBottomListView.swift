//
//  BottomListView.swift
//  WOAI
//
//  Created by 양승완 on 5/21/25.
//

import SwiftUI

struct HomeBottomListView: View {
    @ObservedObject var viewModel: HomeVM
    @EnvironmentObject var router: AppRouter
    var body: some View {
        VStack(spacing: 0) {
            HStack() {
                Image(systemName: "message.fill")
                    .foregroundStyle(Color.mainColor)
                Text("최근 회의 기록").font(.system(size: 20, weight: .bold)).foregroundColor(Color.mainColor)
                Spacer()
            }.padding(.bottom, 10)
            
            VStack( spacing: 4) {
                ForEach(viewModel.meetings) { meeting in
                    VStack(alignment: .leading, spacing: 0) {
                        HStack {
                            Text(meeting.meetingTitle).font(.headline).foregroundStyle(Color.mainColor)
                            Spacer()
                            Text(meeting.startDateDays).font(.system(size: 14)).foregroundStyle(Color.gray)
                            
                        }.padding()
                        
                        Text(meeting.meetingSummary).padding(.leading).padding(.trailing)
                        
                        HStack {
                            //TODO: 세부 정보 타이틀
                            //                                    ForEach(meeting.contents) { content in
                            //                                        Text("\(content)").padding(8).background(Color.green.opacity(0.2))
                            //                                            .cornerRadius(8)
                            //                                    }
                        }.padding()
                        
                    }.frame(maxWidth: .infinity, alignment: .leading)
                        .background(Color.white).cornerRadius(8)
                        .onTapGesture {
                            router.push(.detailInform(model: meeting))
                        }
                }
            }
        }.padding(.vertical)
    }
}
#Preview {
    MainView().environmentObject(AppRouter())
}
