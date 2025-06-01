import Foundation
import CoreData
import SwiftUI

class CarDetailsViewModel: ObservableObject {
    @Published var make: String = ""
    @Published var model: String = ""
    @Published var year: Int = Calendar.current.component(.year, from: Date())
    @Published var currentMileage: Double = 0.0
    @Published var selectedReminders: Set<String> = []
    
    private let context: NSManagedObjectContext
    private var car: Car?
    
    init(context: NSManagedObjectContext, car: Car? = nil) {
        self.context = context
        self.car = car
        
        if let car = car {
            self.make = car.make ?? ""
            self.model = car.model ?? ""
            self.year = Int(car.year)
            self.currentMileage = car.currentMileage
            if let reminders = car.reminders as? Set<Reminder> {
                self.selectedReminders = Set(reminders.compactMap { $0.type })
            }
        }
    }
    
    func saveCar() {
        let car = self.car ?? Car(context: context)
        car.make = make
        car.model = model
        car.year = Int16(year)
        car.currentMileage = currentMileage
        
        // Save reminders
        selectedReminders.forEach { reminderType in
            let reminder = Reminder(context: context)
            reminder.id = UUID()
            reminder.type = reminderType
            reminder.title = reminderType
            reminder.car = car
            
            // Set default intervals based on reminder type
            switch reminderType {
            case "Oil Change":
                reminder.mileageInterval = 3000
                reminder.timeInterval = 180 * 24 * 60 * 60 // 6 months in seconds
            case "Tire Check":
                reminder.timeInterval = 30 * 24 * 60 * 60 // 1 month in seconds
            default:
                reminder.timeInterval = 90 * 24 * 60 * 60 // 3 months in seconds
            }
            
            // Schedule notification
            NotificationManager.shared.scheduleMaintenanceReminder(for: reminder)
        }
        
        do {
            try context.save()
        } catch {
            print("Error saving car: \(error)")
        }
    }
    
    func getAvailableReminders() -> [String] {
        return [
            "Oil Change",
            "Tire Check",
            "Brake Check",
            "Air Filter",
            "Battery Check"
        ]
    }
} 
