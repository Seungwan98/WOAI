//
//  HomeView.swift
//  WOAI
//
//  Created by 양승완 on 4/23/25.
//

import SwiftUI
import Combine

#Preview {
    RecordingView()
}



struct RecordingView: View {
    
    @EnvironmentObject var router: AppRouter
    @StateObject var viewModel = RecordingVM()
    
    
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
                        .foregroundStyle(.white)
                        .onTapGesture {
                            router.pop()
                        }
                    Spacer()
                }
                Text("Recording")
                    .font(.title3)
                    .padding(.horizontal)
                    .foregroundStyle(.white)
            }
            Spacer()
            
            Text("\(viewModel.labelText)")
                .font(.largeTitle)
                .foregroundStyle(.white)
            Image(systemName: viewModel.isRecording ? "stop.circle.fill" : "record.circle")
                .resizable()
                .frame(width: 60,height: 60)
                .foregroundStyle(.white)
                .onTapGesture {
                    viewModel.isRecording.toggle()
                    viewModel.canRecord()
                }
            Spacer()
        }
        .frame(maxWidth: .infinity, maxHeight: .infinity)
        .background(Color.mainColor)
        .onAppear() {
            //
        }.toolbar(.hidden, for: .navigationBar)
            .alert("회의를 분석 하시겠습니까?", isPresented: $viewModel.isAlert) {
                Button("확인", role: .cancel) {
                    viewModel.isAlert = false
                }
                Button("취소", role: .destructive) {
                    viewModel.isAlert = false
                }
                
            }
    }
    
}


