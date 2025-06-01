//
//  NewDriverIQApp.swift
//  NewDriverIQ
//
//  Created by Fernando Cardona on 5/26/25.
//

import SwiftUI
import CoreData

@main
struct NewDriverIQApp: App {
    let persistenceController = PersistenceController.shared
    
    init() {
        // Request notification authorization when app launches
        NotificationManager.shared.requestAuthorization()
        
        // Set up the global appearance
        UITabBar.appearance().backgroundColor = UIColor(Color.midnightBackground)
        UINavigationBar.appearance().backgroundColor = UIColor(Color.midnightBackground)
    }
    
    var body: some Scene {
        WindowGroup {
            TabView {
                NavigationView {
                    CarListView()
                }
                .tabItem {
                    Label("My Cars", systemImage: "car.fill")
                }
                
                NavigationView {
                    CarCareGuidelinesView()
                }
                .tabItem {
                    Label("Guidelines", systemImage: "book.fill")
                }
            }
            .environment(\.managedObjectContext, persistenceController.container.viewContext)
            .preferredColorScheme(.dark)
            .background(Color.midnightBackground)
            .tint(.white)
        }
    }
}
