//
//  web3walletApp.swift
//  web3wallet
//
//  Created by saeid on 2/18/24.
//

import SwiftUI

@main
struct web3walletApp: App {
    let persistenceController = PersistenceController.shared

    var body: some Scene {
        WindowGroup {
            ContentView()
                .environment(\.managedObjectContext, persistenceController.container.viewContext)
        }
    }
}
