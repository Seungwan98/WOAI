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

    var body: some Scene {
        WindowGroup {
            NavigationStack(path: $router.path) { // ✅ 전역 네비게이션 스택
                MainView().navigationDestination(for: SomeRoute.self) { route in
                    switch route {
                    case .home:
                        HomeView()
                    case .record:
                        RecordView()
                    case .settings:
                        SettingView()
                    }
                }
            }
            .environmentObject(router) // ✅ 라우터도 전역 전달
           
        }
    }
}
