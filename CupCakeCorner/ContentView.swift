//
//  ContentView.swift
//  CupCakeCorner
//
//  Created by Bruno Oliveira on 21/05/24.
//

import SwiftUI

struct ContentView: View {
    @State private var order = Order()
    
    var body: some View {
        NavigationStack {
            Form {
                Section {
                    Picker("Select your cake type:", selection: $order.type) {
                        ForEach(Order.types.indices, id: \.self) {
                            //There’s a small speed bump here: our cupcake topping list is an array of strings, but we’re storing the user’s selection as an integer – how can we match the two? One easy solution is to use the indices property of the array, which gives us a position of each item that we can then use with as an array index. This is a bad idea for mutable arrays because the order of your array can change at any time, but here our array order won’t ever change so it’s safe.
                            Text(Order.types[$0])
                        }
                    }
                    
                    Stepper("Number of Cakes: \(order.quantity)", value: $order.quantity, in: 3...20)
                }
                
                Section {
                    Toggle("Any special request?", isOn: $order.specialRequestEnabled.animation())
                    
                    if order.specialRequestEnabled {
                        Toggle("Add extra frosting", isOn: $order.extraFrosting)
                        Toggle("Add extra sprinkles", isOn: $order.addSprinkles)
                    }
                    
                    /*Here there’s a bug, and it’s one of our own making: if we enable special requests then enable one or both of “extra frosting” and “extra sprinkles”, then disable the special requests, our previous special request selection stays active. This means if we re-enable special requests, the previous special requests are still active.
                     
                     This kind of problem isn’t hard to work around if every layer of your code is aware of it – if the app, your server, your database, and so on are all programmed to ignore the values of extraFrosting and addSprinkles when specialRequestEnabled is set to false. However, a better idea – a safer idea – is to make sure that both extraFrosting and addSprinkles are reset to false when specialRequestEnabled is set to false.

                     We can make this happen by adding a didSet property observer to specialRequestEnabled.*/
                }
                
                Section {
                    NavigationLink("Delivery Details") {
                        AddressView(order: order)
                    }
                }
                
            }
            .navigationTitle("Cupcake Corner")
        }
    }
}

#Preview {
    ContentView()
}
