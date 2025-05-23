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

            ScrollView {
                
                DetailInformTopView(viewModel: viewModel)
                DetailInformCenterView(viewModel: viewModel)
                DetailInformBottomView(viewModel: viewModel)
                   
                
            }

        }.background(Color.mainBackground).navigationBarHidden(true)
            .onReceive(viewModel.$popView) { pop in
                       if pop {
                           router.pop()
                       }
                   }
        
       
    }
}



#Preview {
    DetailInformView(viewModel: DetailInformVM(meetingTask: MeetingTaskModel.init(meetingTitle: "", meetingSummary: "", recordedAt: "", dates: ("","","",""))))
}
