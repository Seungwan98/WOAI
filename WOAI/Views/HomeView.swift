//
//  HomeView.swift
//  WOAI
//
//  Created by 양승완 on 4/23/25.
//

import SwiftUI
import Combine

#Preview {
    MainView()
}
struct HomeView: View {
    
    struct normalMeetingModel: Identifiable {
        let id = UUID()
        let name: String
        let time: String
    }
    
    struct currentMeetingModel: Identifiable {
        let id = UUID()
        let name: String
        let date: String
        let description: String
        let contents: [String]
        
    }
    
    
    let itemSpacing: CGFloat = 30
    let mainColor: Color = Color(hex: "#1D3557")!
    
    
    var body: some View {
        
        let normalMeetings = [
            normalMeetingModel(name: "product Meeting", time: "10:00"),
            normalMeetingModel(name: "UX", time: "20:12"),
            normalMeetingModel(name: "UI Meetup", time: "24:00")
        ]
        
        let meetings = [
            currentMeetingModel(name: "제품 개발 회의", date: "2024.12.31", description: "새로운 기능 개발..", contents: ["제품","개발","일정"]),
            currentMeetingModel(name: "제품 개발 회의", date: "2024.12.31", description: "새로운 기능 개발..", contents: ["제품","개발","일정"]),
            currentMeetingModel(name: "제품 개발 회의", date: "2024.12.31", description: "새로운 기능 개발..", contents: ["제품","개발","일정"])
        ]
        
        ScrollView {
            VStack(spacing: 10) {
                
                Button("+ 새 회의 시작") {
                    print("tapp")
                }.font(.system(size: 20, weight: .bold))
                    .foregroundColor(.white)
                    .frame(maxWidth: .infinity)
                    .frame(height: 50)
                    .background(Color(hex: "#1D3557"))
                    .cornerRadius(8)
                
                
                
                VStack(spacing: 0) {
                    HStack() {
                        Image(systemName: "checkmark.rectangle.fill").foregroundStyle(mainColor)
                        Text("오늘 회의").font(.system(size: 20, weight: .bold)).foregroundColor(mainColor)
                        Spacer()
                    }.padding(.bottom, 10)
                    
                    LazyVStack( spacing: 1) {
                        ForEach(normalMeetings) { meeting in
                            HStack {
                                VStack(alignment: .leading, spacing: 8) {
                                    Text(meeting.time)
                                    Text(meeting.name)
                                }.frame(maxWidth: .infinity, alignment: .leading).padding()
                                Spacer()
                                Button("보기 >") {
                                    print("보기")
                                }.padding().foregroundStyle(mainColor)
                            }.background(Color.gray.opacity(0.1)).cornerRadius(8)
                            
                            
                            
                        }
                    }
                }
                .padding(.vertical)
                
                VStack(spacing: 0) {
                    HStack() {
                        Image(systemName: "message.fill").foregroundStyle(mainColor)
                        Text("최근 회의 기록").font(.system(size: 20, weight: .bold)).foregroundColor(mainColor)
                        Spacer()
                    }.padding(.bottom, 10)
                    
                    LazyVStack( spacing: 4) {
                        ForEach(meetings) { meeting in
                            VStack(alignment: .leading, spacing: 0) {
                                HStack {
                                    Text(meeting.name)
                                    Spacer()
                                    Text(meeting.date)
                                    
                                }.padding()
                                Text(meeting.description).padding(.leading)

                                HStack {
                                    ForEach(meeting.contents, id: \.self) { content in
                                        Text("\(content)").padding(8).background(Color.green.opacity(0.2))
                                            .cornerRadius(8)
                                    }
                                }.padding()
                                
                            }.frame(maxWidth: .infinity, alignment: .leading)
                                .background(Color.gray.opacity(0.1)).cornerRadius(8)
                        }
                    }
                }.padding(.vertical)
                
                
                
            }.padding(.horizontal, itemSpacing)
            
        }
    }
}

