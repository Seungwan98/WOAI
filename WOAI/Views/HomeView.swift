//
//  HomeView.swift
//  WOAI
//
//  Created by 양승완 on 4/23/25.
//

import SwiftUI
import Combine

#Preview {
    MainView().environmentObject(AppRouter())
}
struct HomeView: View {
    
    @ObservedObject var viewModel: HomeVM
    @EnvironmentObject var router: AppRouter
    
    let itemSpacing: CGFloat = 30
    
    
    var body: some View {
        
        ScrollView {
            VStack(spacing: 10) {
                
                Button("+ 새 회의 시작") {
                    router.push(.recording)
                    
                }.font(.system(size: 20, weight: .bold))
                    .foregroundColor(.white)
                    .frame(maxWidth: .infinity)
                    .frame(height: 50)
                    .background(Color.mainColor)
                    .cornerRadius(8)
                
                
                
                VStack(spacing: 0) {
                    HStack() {
                        Image(systemName: "checkmark.rectangle.fill").foregroundStyle(Color.mainColor)
                        Text("오늘 회의").font(.system(size: 20, weight: .bold)).foregroundColor(Color.mainColor)
                        Spacer()
                    }.padding(.bottom, 10)
                    
                    LazyVStack( spacing: 1) {
                        ForEach(viewModel.meetings) { meeting in
                            HStack {
                                VStack(alignment: .leading, spacing: 8) {
                                    Text(meeting.startDateTime).font(.headline).foregroundStyle(Color.mainColor)
                                    Text(meeting.meetingTitle)
                            
                                }.frame(maxWidth: .infinity, alignment: .leading).padding()
                                Spacer()
                                Button("보기 >") {
                                    print("보기")
                                }.padding().foregroundStyle(Color.mainColor)
                            }.background(Color.white).cornerRadius(8)
                            
                            
                            
                        }
                    }
                }
                .padding(.vertical)
                
                VStack(spacing: 0) {
                    HStack() {
                        Image(systemName: "message.fill").foregroundStyle(Color.mainColor)
                        Text("최근 회의 기록").font(.system(size: 20, weight: .bold)).foregroundColor(Color.mainColor)
                        Spacer()
                    }.padding(.bottom, 10)
                    
                    LazyVStack( spacing: 4) {
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
                        }
                    }
                }.padding(.vertical)
                
                
                
            }.padding(.horizontal, itemSpacing)
            
        }.background(Color.mainBackground).onAppear {
            viewModel.onAppear()

        }
    }
}

