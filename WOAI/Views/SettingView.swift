//
//  SettingView.swift
//  WOAI
//
//  Created by 양승완 on 4/23/25.
//

import SwiftUI
import Combine

#Preview {
    SettingView()
}
struct SettingView: View {
    var body: some View {
        VStack {
            Text("Settings").font(.title2)
            Spacer().frame(height: 20)
            VStack(alignment: .leading, spacing: 8) {
                
                Text("일반").font(.headline).foregroundStyle(Color.mainColor)
                
                
                HStack {
                    Text("언어설정")
                    Spacer()
                    Text("한국어").foregroundStyle(Color.gray).onTapGesture {
                        //
                    }
                }
            }.frame(maxWidth: .infinity, alignment: .leading).padding().background(Color.white).cornerRadius(10)
            
            
            Spacer()
            
        }.padding(.horizontal, 30).background(Color.mainBackground)
    }
}
