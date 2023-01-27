//
//  EditItemView.swift
//  timers
//
//  Created by Jeffrey Melloy on 1/26/23.
//

import SwiftUI

extension Binding {
    init(_ source: Binding<Value?>, _ defaultValue: Value) {
        // Ensure a non-nil value in `source`.
        if source.wrappedValue == nil {
            source.wrappedValue = defaultValue
        }
        // Unsafe unwrap because *we* know it's non-nil now.
        self.init(source)!
    }
}


struct EditItemView: View {
    @ObservedObject var item: Item
    
    var body: some View {
        
        //            TextField("Title", text: $item.name)
        Form {
            VStack {
                LabeledContent("Title") {
                    TextField("Title", text: Binding($item.name, ""))

                }
                
                HStack {
                    LabeledContent("Start") {
                        TextField("Start", text: Binding($item.start, ""))
                            .keyboardType(.numberPad)
                    }
                    
                    LabeledContent("End") {
                        TextField("End", text: Binding($item.end, ""))
                            .keyboardType(.numberPad)
                    }
                }
                
            }
            
            
            
        }
    }
}
//
struct EditItemView_Previews: PreviewProvider {
    static var item = Item()

//    item.timestamp =  Date()
//    item.name = "hello, hi, i'm the problem"

    static var previews: some View {
        EditItemView(item: item)
    }
}
