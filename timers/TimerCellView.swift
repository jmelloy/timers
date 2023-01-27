//
//  TimerCellView.swift
//  timers
//
//  Created by Jeffrey Melloy on 1/26/23.
//

import SwiftUI


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

func itemColor(item: Item) -> Color {
    let calendar = Calendar.current

    if let endTime = item.end,
       let end = Double(endTime),
       let date = calendar.date(byAdding: .minute, value: Int(floor(end)), to: item.timestamp!),
       let finalDate = calendar.date(byAdding: .second, value: Int(round(end.remainder(dividingBy: 1) * 60)), to: date)  {
        
        if Date() > finalDate {
            
            return .red
        }
    }
    
    if let startTime = item.start,
       let start = Double(startTime),
       let date = calendar.date(byAdding: .minute, value: Int(floor(start)), to: item.timestamp!),
       let finalDate = calendar.date(byAdding: .second, value: Int(round(start.remainder(dividingBy: 1) * 60)), to: date)  {
        
        if Date() > finalDate {
            return .yellow
        }
    }
    return .black
}

struct TimerView: View {
    @State var interval = TimeInterval()
    @State var isTimerRunning = false
    @ObservedObject var item: Item

    let timer = Timer.publish(every: 1, on: .main, in: .common).autoconnect()

    var body: some View {
        LazyVStack {
            HStack {
                Text(interval.format(using: [.hour, .minute, .second]))
                    .foregroundColor(itemColor(item: item))
                    .font(Font.system(.largeTitle, design: .monospaced))
                    .onAppear(perform: {let _ = self.updateTimer})
                
                Spacer()
                
                Text("\(item.start ?? "") \(item.end ?? "" != "" && item.start ?? "" != "" ? " - " : "") \(item.end ?? "") \(item.end ?? "" != "" || item.start ?? "" != "" ? "min" : "")")
                
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

private let itemFormatter: DateFormatter = {
    let formatter = DateFormatter()
    formatter.dateStyle = .none
    formatter.timeStyle = .short
    return formatter
}()
