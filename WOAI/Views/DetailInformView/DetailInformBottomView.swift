//
//  DetailInformTopView.swift
//  WOAI
//
//  Created by 양승완 on 5/21/25.
//

import SwiftUI

struct DetailInformBottomView: View {
    @ObservedObject var viewModel: DetailInformVM
    
    @State var btnTap = false
    
    var body: some View {
        HStack(alignment:.center) {
            Spacer()
            Image(systemName: "trash")
                .resizable()
                .frame(width: 20, height: 20)
                .foregroundStyle(.white)
            Spacer()
            
        }
        .frame(height: 40)
        .background(Color.mainColor)
        .clipShape(RoundedRectangle(cornerRadius: 10))
        .padding()
        .onTapGesture {
            btnTap.toggle()
        }
        .alert("회의를 삭제하시겠습니까?", isPresented: $btnTap) {
            Button("확인", role: .destructive) {
                viewModel.deleteItemById()
            }
            Button("취소", role: .cancel) {
            }
            
        }
    }
}
#Preview {
    DetailInformView(viewModel: DetailInformVM(meetingTask: MeetingTaskModel.init(meetingTitle: "", meetingSummary: "", recordedAt: "", dates: ("","","",""))))
}
