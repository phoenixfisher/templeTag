//
//  DateTimePicker.swift
//  templeTag
//
//  Created by Phoenix Fisher on 1/25/26.
//

import SwiftUI

struct DateTimePicker: View {
    @Environment(\.dismiss) var dismiss
    
    @Binding var date: Date
    @Binding var time: Date?
    @State private var tempDate: Date
    @State private var tempTime: Date
    
    @State private var includeTime: Bool
    
    init(date: Binding<Date>, time: Binding<Date?>) {
        _date = date
        _time = time
        
        let initialDate = date.wrappedValue
        let initialTime = time.wrappedValue ?? Date()
        
        _tempDate = State(initialValue: initialDate)
        _tempTime = State(initialValue: initialTime)
        _includeTime = State(initialValue: time.wrappedValue != nil)
    }
    
    var body: some View {
        NavigationStack {
            Form {
                Section {
                    DatePicker("Select a date", selection: $tempDate, displayedComponents: .date)
                }
                
                Section {
                    Toggle("Add time", isOn: $includeTime)
                    if includeTime {
                        DatePicker("Select a time", selection: $tempTime, displayedComponents: .hourAndMinute)
                    }
                }
            }
            .toolbar {
                ToolbarItem(placement: .cancellationAction) {
                    Button("Cancel") { dismiss() }
                }
                ToolbarItem(placement: .confirmationAction) {
                    Button("Done") {
                        date = tempDate
                        time = includeTime ? tempTime : nil
                        dismiss()
                    }
                }
            }
        }
    }
}
