//
//  ContentView.swift
//  timers
//
//  Created by Jeffrey Melloy on 1/25/23.
//

import SwiftUI
import CoreData

var itemNumber = 1

var timeFormat: DateFormatter {
    let formatter = DateFormatter()
    formatter.dateFormat = "hh:mm a"
    return formatter
}

func timeString(date: Date) -> String {
     let time = timeFormat.string(from: date)
     return time
}

extension TimeInterval {
    func format(using units: NSCalendar.Unit) -> String {
        let formatter = DateComponentsFormatter()
        formatter.allowedUnits = units
        formatter.unitsStyle = .positional
        formatter.zeroFormattingBehavior = .pad
        return formatter.string(from: self) ?? ""
    }
}

struct TimerView: View {
    @State var interval = TimeInterval()
    @State var isTimerRunning = false
    @State var item: Item

    let timer = Timer.publish(every: 1, on: .main, in: .common).autoconnect()

    var body: some View {
        LazyVStack {
            HStack {
                Text(interval.format(using: [.hour, .minute, .second]))
                    .font(Font.system(.largeTitle, design: .monospaced))
                    .onAppear(perform: {let _ = self.updateTimer})
                
                Spacer()
            }
            
            
            HStack {
                Text("\(item.name ?? "hi")")
                
                Spacer()
                
                Text("\(item.timestamp ?? Date(), formatter: itemFormatter)")
            }

        }
    }
    
    var updateTimer: Timer {
         Timer.scheduledTimer(withTimeInterval: 1, repeats: true,
                              block: {_ in
             self.interval = Date().timeIntervalSince(item.timestamp ?? Date() )
                               })
    }
}


struct ContentView: View {
    @State var date = Date()

    @Environment(\.managedObjectContext) private var viewContext

    @FetchRequest(
        sortDescriptors: [NSSortDescriptor(keyPath: \Item.timestamp, ascending: true)],
        animation: .default)
    

    private var items: FetchedResults<Item>

    var body: some View {
        VStack {
            Text("\(timeString(date: date))")
                .font(.largeTitle).onAppear(perform: {let _ = self.updateTimer})
            
            List {
                ForEach(items) { item in
                    TimerView(item: item)
                }
                .onDelete(perform: deleteItems)
            }
            
            Button(action: addItem) {
                Label("Add Item", systemImage: "plus")
            }
        }
    }

    private func addItem() {
        withAnimation {
            let newItem = Item(context: viewContext)
            newItem.timestamp = Date()
            newItem.name = "Item \(itemNumber)"
            itemNumber += 1
            
            do {
                try viewContext.save()
            } catch {
                // Replace this implementation with code to handle the error appropriately.
                // fatalError() causes the application to generate a crash log and terminate. You should not use this function in a shipping application, although it may be useful during development.
                let nsError = error as NSError
                fatalError("Unresolved error \(nsError), \(nsError.userInfo)")
            }
        }
    }

    private func deleteItems(offsets: IndexSet) {
        withAnimation {
            offsets.map { items[$0] }.forEach(viewContext.delete)

            do {
                try viewContext.save()
            } catch {
                // Replace this implementation with code to handle the error appropriately.
                // fatalError() causes the application to generate a crash log and terminate. You should not use this function in a shipping application, although it may be useful during development.
                let nsError = error as NSError
                fatalError("Unresolved error \(nsError), \(nsError.userInfo)")
            }
        }
    }
    
    var updateTimer: Timer {
         Timer.scheduledTimer(withTimeInterval: 1, repeats: true,
                              block: {_ in
                                 self.date = Date()
                               })
    }

}

private let itemFormatter: DateFormatter = {
    let formatter = DateFormatter()
    formatter.dateStyle = .none
    formatter.timeStyle = .short
    return formatter
}()

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView().environment(\.managedObjectContext, PersistenceController.preview.container.viewContext)
    }
}


