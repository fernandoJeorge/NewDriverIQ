import SwiftUI
import CoreData

struct CarListView: View {
    @Environment(\.managedObjectContext) private var viewContext
    @FetchRequest(
        sortDescriptors: [NSSortDescriptor(keyPath: \Car.make, ascending: true)],
        animation: .default)
    private var cars: FetchedResults<Car>
    @State private var showingAddCar = false
    
    var body: some View {
        List {
            if cars.isEmpty {
                Text("No cars added yet")
                    .foregroundColor(Color.midnightSecondaryText)
                    .frame(maxWidth: .infinity, alignment: .center)
                    .padding()
            } else {
                ForEach(cars) { car in
                    VStack(alignment: .leading, spacing: 8) {
                        HStack {
                            Text("\(car.make ?? "") \(car.model ?? "")")
                                .font(.headline)
                                .foregroundColor(Color.midnightText)
                            Spacer()
                            Text("\(car.year)")
                                .foregroundColor(Color.midnightSecondaryText)
                        }
                        
                        Text("Mileage: \(Int(car.currentMileage)) miles")
                            .font(.subheadline)
                            .foregroundColor(Color.midnightSecondaryText)
                        
                        if let reminders = car.reminders as? Set<Reminder>, !reminders.isEmpty {
                            Text("Active Reminders: \(reminders.count)")
                                .font(.caption)
                                .foregroundColor(.blue)
                        }
                    }
                    .padding(.vertical, 4)
                    .listRowBackground(Color.midnightSecondary)
                }
                .onDelete(perform: deleteCars)
            }
        }
        .navigationTitle("My Cars")
        .background(Color.midnightBackground)
        .scrollContentBackground(.hidden)
        .toolbar {
            ToolbarItem(placement: .navigationBarTrailing) {
                Button(action: { showingAddCar = true }) {
                    Label("Add Car", systemImage: "plus")
                }
            }
        }
        .sheet(isPresented: $showingAddCar) {
            NavigationView {
                CarDetailsView(viewModel: CarDetailsViewModel(context: viewContext))
            }
        }
    }
    
    private func deleteCars(offsets: IndexSet) {
        withAnimation {
            offsets.map { cars[$0] }.forEach(viewContext.delete)
            
            do {
                try viewContext.save()
            } catch {
                print("Error deleting car: \(error)")
            }
        }
    }
}

#Preview {
    CarListView()
        .environment(\.managedObjectContext, PersistenceController.preview.container.viewContext)
} 