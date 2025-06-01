import SwiftUI

struct MaintenanceGuideline: Identifiable {
    let id = UUID()
    let title: String
    let description: String
    let interval: String
}

struct CarCareGuidelinesView: View {
    let guidelines = [
        MaintenanceGuideline(
            title: "Oil Change",
            description: "Regular oil changes help maintain engine health and performance.",
            interval: "Every 3,000-5,000 miles or 6 months"
        ),
        MaintenanceGuideline(
            title: "Tire Pressure",
            description: "Proper tire pressure improves fuel efficiency and safety.",
            interval: "Check monthly and before long trips"
        ),
        MaintenanceGuideline(
            title: "Brake System",
            description: "Ensure proper brake function and safety.",
            interval: "Inspect every 12,000 miles or annually"
        ),
        MaintenanceGuideline(
            title: "Air Filter",
            description: "Clean air filter ensures optimal engine performance.",
            interval: "Replace every 15,000-30,000 miles"
        ),
        MaintenanceGuideline(
            title: "Battery",
            description: "A healthy battery prevents starting problems.",
            interval: "Check every 6 months, replace every 3-5 years"
        ),
        MaintenanceGuideline(
            title: "Fluid Levels",
            description: "Check and maintain proper levels of all fluids.",
            interval: "Check monthly"
        )
    ]
    
    var body: some View {
        List(guidelines) { guideline in
            VStack(alignment: .leading, spacing: 8) {
                Text(guideline.title)
                    .font(.headline)
                    .foregroundColor(Color.midnightText)
                Text(guideline.description)
                    .font(.subheadline)
                    .foregroundColor(Color.midnightSecondaryText)
                Text("Interval: \(guideline.interval)")
                    .font(.caption)
                    .foregroundColor(.blue)
            }
            .padding(.vertical, 4)
            .listRowBackground(Color.midnightSecondary)
        }
        .navigationTitle("Car Care Guidelines")
        .background(Color.midnightBackground)
        .scrollContentBackground(.hidden)
    }
} 