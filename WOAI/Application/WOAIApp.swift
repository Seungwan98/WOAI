//
//  WoaiApp.swift
//  WOAI
//
//  Created by 양승완 on 4/23/25.
//

import SwiftUI

@main
struct WOAIApp: App {
    @StateObject private var router = AppRouter()
    @StateObject private var homeVM = HomeVM()

    var body: some Scene {
        WindowGroup {
            NavigationStack(path: $router.path) { // ✅ 전역 네비게이션 스택
                MainView().navigationDestination(for: SomeRoute.self) { route in
                    switch route {
                    case .home:
                        HomeView(viewModel: homeVM)
                    case .recording:
                        RecordingView()
                    case .settings:
                        SettingView()
                    case .rocrdNote:
                        RecordNoteView()
                    }
                }
            }
            .environmentObject(router) // ✅ 라우터도 전역 전달
           
        }
    }
}
