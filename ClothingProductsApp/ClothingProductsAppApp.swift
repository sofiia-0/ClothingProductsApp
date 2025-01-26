//
//  ClothingProductsAppApp.swift
//  ClothingProductsApp
//
//  Created by User-UAM on 1/25/25.
//

import SwiftUI

@main
struct ClothingProductsAppApp: App {
    let persistenceController = PersistenceController.shared

    var body: some Scene {
        WindowGroup {
            ContentView()
                .environment(\.managedObjectContext, persistenceController.container.viewContext)
        }
    }
}
