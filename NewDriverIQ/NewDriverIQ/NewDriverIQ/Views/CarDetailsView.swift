import SwiftUI

struct CarDetailsView: View {
    @StateObject var viewModel: CarDetailsViewModel
    @Environment(\.dismiss) private var dismiss
    @State private var showingSaveSuccess = false
    
    var body: some View {
        Form {
            Section(header: Text("Vehicle Information")) {
                TextField("Make", text: $viewModel.make)
                TextField("Model", text: $viewModel.model)
                Picker("Year", selection: $viewModel.year) {
                    ForEach((1990...Calendar.current.component(.year, from: Date())), id: \.self) { year in
                        Text(String(year)).tag(year)
                    }
                }
                HStack {
                    Text("Current Mileage")
                    TextField("Mileage", value: $viewModel.currentMileage, format: .number)
                        .keyboardType(.numberPad)
                }
            }

            
            Section(header: Text("Maintenance Reminders")) {
                ForEach(viewModel.getAvailableReminders(), id: \.self) { reminder in
                    Toggle(reminder, isOn: Binding(
                        get: { viewModel.selectedReminders.contains(reminder) },
                        set: { isSelected in
                            if isSelected {
                                viewModel.selectedReminders.insert(reminder)
                            } else {
                                viewModel.selectedReminders.remove(reminder)
                            }
                        }
                    ))
                }
            }
            
            Section {
                Button("Save") {
                    viewModel.saveCar()
                    showingSaveSuccess = true
                    DispatchQueue.main.asyncAfter(deadline: .now() + 1.0) {
                        dismiss()
                    }
                }
            }
        }
        .navigationTitle("Car Details")
        .overlay {
            if showingSaveSuccess {
                SaveSuccessView()
                    .transition(.scale.combined(with: .opacity))
            }
        }
    }
}

struct SaveSuccessView: View {
    var body: some View {
        VStack {
            Image(systemName: "checkmark.circle.fill")
                .foregroundColor(.green)
                .font(.system(size: 50))
            Text("Saved Successfully!")
                .font(.headline)
                .foregroundColor(.green)
        }
        .padding()
        .background(Color(UIColor.systemBackground))
        .cornerRadius(10)
        .shadow(radius: 5)
    }
} 
