//
//  Machine_TestApp.swift
//  Machine Test
//
//  Created by Alen C James on 16/09/24.
//

import SwiftUI

@main
struct Machine_TestApp: App {
    var body: some Scene {
        WindowGroup {
            HomeView(viewModel: HomeViewModel())
        }
    }
}
