//
//  TestingARKitAPP.swift
//  TestingARKit
//
//  Created by thaxz on 01/10/23.
//

import Foundation
import SwiftUI

@main
struct TestingARKitAPP: SwiftUI.App {
    @Environment(\.scenePhase) var scenePhase

    var body: some SwiftUI.Scene {
        WindowGroup {
            ContentView()
                .onChange(of: scenePhase) { newPhase in
                    switch newPhase {
                    case .active:
                        print("App did become active")
                    case .inactive:
                        print("App did become inactive")
                    default:
                        break
                    }
                }
        }
    }
}
