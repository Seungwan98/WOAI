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
    
    
    @ObservedObject var viewModel = HomeVM()
    
    
    let itemSpacing: CGFloat = 30
    let mainColor: Color = Color(hex: "#1D3557")!
    
    
    var body: some View {
        
        
        
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

                        ForEach(viewModel.meetings) { meeting in
                            HStack {
                                VStack(alignment: .leading, spacing: 8) {
                                    Text(meeting.recordedAt)
                                    Text(meeting.meetingTitle)
                            
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
                        ForEach(viewModel.meetings) { meeting in
                            VStack(alignment: .leading, spacing: 0) {
                                HStack {
                                    Text(meeting.meetingTitle)
                                    Spacer()
                                    Text(meeting.recordedAt)
                                    
                                }.padding()
                           
                                Text(meeting.meetingSummary).padding(.leading)

                                HStack {
//                                    ForEach(meeting.contents) { content in
//                                        Text("\(content)").padding(8).background(Color.green.opacity(0.2))
//                                            .cornerRadius(8)
//                                    }
                                }.padding()
                                
                            }.frame(maxWidth: .infinity, alignment: .leading)
                                .background(Color.gray.opacity(0.1)).cornerRadius(8)
                        }
                    }
                }.padding(.vertical)
                
                
                
            }.padding(.horizontal, itemSpacing)
            
        }.onAppear {
            viewModel.onAppear()

        }
    }
}

