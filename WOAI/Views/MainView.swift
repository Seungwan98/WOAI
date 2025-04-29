//
//  HomeView.swift
//  WOAI
//
//  Created by 양승완 on 4/23/25.
//

import SwiftUI
import Combine

//#Preview {
//    MainView()
//}



struct MainView: View {
    @EnvironmentObject var router: AppRouter

    var body: some View {
        TabView(selection: $router.selectedTab) {
            HomeView(viewModel: HomeVM())
                .tag(AppRouter.Tab.home)
                .tabItem { Label("Home", systemImage: "house") }
            RecordView()
                .tag(AppRouter.Tab.record)
                .tabItem { Label("Record", systemImage: "microphone") }
            SettingView()
                .tag(AppRouter.Tab.settings)
                .tabItem { Label("Settings", systemImage: "gear") }
         
            
        
        }
    }
    
}
