//
//  HomeTopListView.swift
//  WOAI
//
//  Created by 양승완 on 5/21/25.
//

import SwiftUI

struct HomeTopListView: View {
    @ObservedObject var viewModel: HomeVM
    var body: some View {
        VStack(spacing: 0) {
            HStack() {
                Image(systemName: "checkmark.rectangle.fill")
                    .foregroundStyle(Color.mainColor)
                Text("오늘 회의").font(.system(size: 20, weight: .bold))
                    .foregroundColor(Color.mainColor)
                Spacer()
            }
            .padding(.bottom, 10)
            
            VStack( spacing: 1) {
                ForEach(viewModel.todaysMeetings) { meeting in
                    HStack {
                        VStack(alignment: .leading, spacing: 8) {
                            Text(meeting.startDateTime)
                                .font(.headline)
                                .foregroundStyle(Color.mainColor)
                            Text(meeting.meetingTitle)
                    
                        }
                        .frame(maxWidth: .infinity, alignment: .leading)
                        .padding()
                        Spacer()
                        Button("보기 >") {
                            print("보기")
                        }
                        .padding()
                        .foregroundStyle(Color.mainColor)
                    }.background(Color.white)
                        .cornerRadius(8)
                    
                }
            }
        }
        .padding(.vertical)    }
}
