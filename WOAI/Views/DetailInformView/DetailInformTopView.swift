//
//  DetailInformTopView.swift
//  WOAI
//
//  Created by 양승완 on 5/21/25.
//

import SwiftUI

struct DetailInformTopView: View {
    @ObservedObject var viewModel: DetailInformVM

    var body: some View {
        VStack {
            HStack {
                Text("\(viewModel.meetingTask.meetingTitle )")
                    .font(.title)
                    .bold()
                    .padding(.horizontal)
                    .foregroundStyle(Color.mainColor)
                
                Spacer()

            }.padding(.vertical)
            HStack {
                Image(systemName: "checkmark.rectangle.fill")
                    .foregroundStyle(Color.mainColor)
                    .padding(.leading)

                Text("2024년 2월 12일").font(.system(size: 20, weight: .bold))
                    .foregroundColor(Color.mainColor)
                Spacer()
            }.padding(.bottom)
        }.frame(maxWidth: .infinity)
            .background(Color.white)
            .clipShape(RoundedRectangle(cornerRadius: 10))
            .padding(.horizontal)
            .padding(.top)
    }
}
#Preview {
    DetailInformView(viewModel: DetailInformVM(meetingTask: MeetingTaskModel.init(meetingTitle: "", meetingSummary: "", recordedAt: "", dates: ("","","",""))))
}
