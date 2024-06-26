//
//  AddressView.swift
//  CupCakeCorner
//
//  Created by Bruno Oliveira on 21/05/24.
//

import SwiftUI

struct AddressView: View {
    /*Previously you've seen how Xcode lets us bind to local @State properties just fine, even when those properties are classes using the @Observable macros. That works because the @State property wrapper automatically creates two-way bindings for us, which we access through the $ syntax – $name, $age, etc.
     
     We haven't use @State in AddressView because we aren't creating the class here, we're just receiving it from elsewhere. This means SwiftUI doesn't have access to the same two-way bindings we'd normally use, which is a problem.

     Now, we know this class uses the @Observable macro, which means SwiftUI is able to watch this data for changes. So, what the @Bindable property wrapper does is create the missing bindings for us – it produces two-way bindings that are able to work with the @Observable macro, without having to use @State to create local data. It's perfect here.*/
    @Bindable var order: Order
    @State var saveAddressOnCache = true
    
    var body: some View {
        Form {
            Section {
                TextField("Name", text: $order.name)
                TextField("Street Address", text: $order.streetAddress)
                TextField("City", text: $order.city)
                TextField("Zip Code", text: $order.zip)
            }
            
            Section {
                Toggle(isOn: $saveAddressOnCache, label: {
                    Text("Save this Order and Address to use latter?")
                })
            }
            
            Section {
                NavigationLink("Check Out") {
                    CheckOutView(order: order, saveAddressOnCache: saveAddressOnCache)
                }
            }
            .disabled(order.hasValidAddress == false)
        }
        .navigationTitle("Delivery Details")
        .navigationBarTitleDisplayMode(.inline)
        .onAppear {
            if let savedAddress = UserDefaults.standard.data(forKey: "address") {
                if let decodedItems = try? JSONDecoder().decode(Order.self, from: savedAddress) {
                    order.streetAddress = decodedItems.streetAddress
                    order.city = decodedItems.city
                    order.name = decodedItems.name
                    order.zip = decodedItems.zip
                    return
                }
                return
            }
            return
        }
        .onDisappear {
            if !saveAddressOnCache {
                if UserDefaults.standard.data(forKey: "address") != nil {
                    UserDefaults.standard.removeObject(forKey: "address")
                }
            }
        }
    }
}

#Preview {
    AddressView(order: Order())
}
