//
//  BottomListView.swift
//  WOAI
//
//  Created by 양승완 on 5/21/25.
//

import SwiftUI

struct RecordNoteBottomListView: View {
    @ObservedObject var viewModel: RecordNoteVM
    @State private var showingAlert = false
    var body: some View {
        List {
            ForEach(viewModel.recordedList) { model in
                VStack {
                    HStack {
                        VStack(alignment: .leading) {
                            Text("\(model.name)")
                                .lineLimit(1)
                            Text("\(model.loadingTime)")
                                .lineLimit(1)
                        }
                        Spacer()
                        //                                Image(systemName: "headphones").resizable().scaledToFill().frame(width: 15, height: 10).foregroundStyle(Color.mainColor)
                        //                                Spacer().frame(width: 10)
                        
                        
                        Image(systemName: "trash")
                            .resizable()
                            .scaledToFill()
                            .frame(width: 15, height: 10)
                            .foregroundStyle(Color.red)
                            .onTapGesture {
                                showingAlert.toggle()
                            }.alert("삭제하시겠습니까?", isPresented: $showingAlert) {
                                Button("확인", role: .destructive) {
                                    viewModel.tapCell(idx: model.id)
                                }
                                Button("취소",role: .cancel) {
                                    
                                }
                              }
                    }
                }
                
            }
        }.listStyle(.plain)
            .background(Color.clear)
            .padding(.horizontal, 20)
    }
}

#Preview {
    RecordNoteView()
}
