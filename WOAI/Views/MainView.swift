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
struct MainView: View {
    var body: some View {
        TabView {
            HomeView()
                .tabItem {
                    Label("홈", systemImage: "house")
                }

            RecordView()
                .tabItem {
                    Label("녹음", systemImage: "mic.fill")
                }

            SettingView()
                .tabItem {
                    Label("설정", systemImage: "gear")
                }
        }
    }
}

