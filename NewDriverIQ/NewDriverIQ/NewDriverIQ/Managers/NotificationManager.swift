import UserNotifications
import CoreData

class NotificationManager {
    static let shared = NotificationManager()
    
    private init() {}
    
    func requestAuthorization() {
        UNUserNotificationCenter.current().requestAuthorization(options: [.alert, .badge, .sound]) { granted, error in
            if granted {
                print("Notification permission granted")
            } else if let error = error {
                print("Error requesting notification permission: \(error)")
            }
        }
    }
    
    func scheduleMaintenanceReminder(for reminder: Reminder) {
        let content = UNMutableNotificationContent()
        content.title = "Maintenance Reminder"
        content.body = "Time for \(reminder.title ?? "maintenance")"
        content.sound = .default
        
        // Create trigger based on mileage or time interval
        var trigger: UNNotificationTrigger?
        
        if reminder.timeInterval > 0 {
            trigger = UNTimeIntervalNotificationTrigger(
                timeInterval: reminder.timeInterval,
                repeats: true
            )
        }
        
        guard let trigger = trigger else { return }
        
        let request = UNNotificationRequest(
            identifier: reminder.id?.uuidString ?? UUID().uuidString,
            content: content,
            trigger: trigger
        )
        
        UNUserNotificationCenter.current().add(request) { error in
            if let error = error {
                print("Error scheduling notification: \(error)")
            }
        }
    }
    
    func cancelReminder(with id: String) {
        UNUserNotificationCenter.current().removePendingNotificationRequests(withIdentifiers: [id])
    }
} 