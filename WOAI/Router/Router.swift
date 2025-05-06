//
//  Router.swift
//  WOAI
//
//  Created by 양승완 on 4/24/25.
//

import Combine
import SwiftUI

class AppRouter: ObservableObject {
    @Published var path = NavigationPath()
    @Published var someRoutes: [SomeRoute] = []
    @Published var selectedTab: Tab = .home
    
    func push(_ route: SomeRoute) {
        path.append(route)
        someRoutes.append(route)
        
    }
    func pop() {
        path.removeLast()
        
    }
    func reset() {
        path = NavigationPath()
    }
}
extension AppRouter {
    
    enum Tab {
        case home, recordNote, settings
    }
    
    func popTo(_ target: SomeRoute) {
        guard let index = someRoutes.firstIndex(of: target) else { return }
        
        // 스택 자르기
        let newStack = someRoutes.prefix(through: index)
        // 새로운 Path 생성 -> 이후에 self.path 를 이 값으로 바꿔줌
        var newPath = NavigationPath()
        
        for route in newStack {
            newPath.append(route)
        }
        
        // path와 stack 모두 재설정
        path = newPath
        // ArraySlice to Array
        someRoutes = Array(newStack)
    }
    
}
enum SomeRoute: Hashable {
    case home
    case recording
    case rocrdNote
    case settings
}

