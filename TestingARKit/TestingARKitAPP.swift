//
//  TestingARKitAPP.swift
//  TestingARKit
//
//  Created by thaxz on 01/10/23.
//

import Foundation
import SwiftUI

@main
struct TapMakesCupsApp: SwiftUI.App {
    @Environment(\.scenePhase) var scenePhase
    
    @StateObject var viewModel = ViewModel()
    
    var body: some SwiftUI.Scene {
        WindowGroup {
            ContentView()
                .environmentObject(viewModel)
                .onChange(of: scenePhase) { newPhase in
                    switch newPhase {
                    case .active:
                        print("App did become active")
                        viewModel.resume()
                    case .inactive:
                        print("App did become inactive")
                        viewModel.pause()
                    default:
                        break
                    }
                }
        }
    }
}
