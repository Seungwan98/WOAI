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

class AppRouter: ObservableObject {
    @Published var path = NavigationPath()
    @Published var selectedTab: Tab = .home

    enum Tab {
        case home, settings, profile
    }

    func push<Destination: Hashable>(_ destination: Destination) {
        path.append(destination)
    }

    func pop() {
        path.removeLast()
    }

    func reset() {
        path = NavigationPath()
    }
}

enum SomeRoute: Hashable {
    case home
    case record
    case settings
}

struct MainView: View {
    @StateObject private var router = AppRouter()
    
    var body: some View {
        NavigationStack(path: $router.path) {
            TabView(selection: $router.selectedTab) {
                HomeView()
                    .tag(AppRouter.Tab.home)
                    .tabItem { Label("Home", systemImage: "house") }
                
                RecordView()
                    .tag(AppRouter.Tab.settings)
                    .tabItem { Label("Settings", systemImage: "gear") }
                
                SettingView()
                    .tag(AppRouter.Tab.profile)
                    .tabItem { Label("Profile", systemImage: "person") }
            }
            .navigationDestination(for: SomeRoute.self) { route in
                switch route {
                case .home:
                    Text("h")
                case .record:
                    Text("r")
                case .settings:
                    Text("s")
                    
                    
                }
            }
        }
        .environmentObject(router)
    }
    
}
