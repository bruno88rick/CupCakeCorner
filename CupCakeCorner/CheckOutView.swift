//
//  CheckOutView.swift
//  CupCakeCorner
//
//  Created by Bruno Oliveira on 21/05/24.
//

import SwiftUI

struct CheckOutView: View {
    var order: Order
    var urlString = "https://reqres.in/api/cupcakes"
    
    @State private var alertMessage = ""
    @State private var showingAlert = false
    @State private var alertTitle = ""
    var saveAddressOnCache: Bool
    
    
    var body: some View {
        ScrollView {
            VStack {
                AsyncImage(url: URL(string: "https://hws.dev/img/cupcakes@3x.jpg"), scale: 3) { image in
                    image
                        .resizable()
                        .scaledToFit()
                } placeholder: {
                    ProgressView()
                }
                .frame(height: 233)
                
                Text("You total is \(order.cost, format: .currency(code: "BRL"))")
                    .font(.title)
                
                /*this don`t work because our button don`t want do waite:
                 Button("Place Order", action: placeOrder)*/
                //So, to solver we need to use the Task out of thin air, like the modifer task()
                Button ("Place Order") {
                    
                    Task {
                        await placeOrder()
                    }
                }
                .padding()
            }
        }
        .navigationTitle("CheckOut")
        .navigationBarTitleDisplayMode(.inline)
        //Using scroll views is a great way to make sure your layouts work great no matter what Dynamic Type size the user has enabled, but it creates a small annoyance: when your views fit just fine on a single screen, they still bounce a little when the user moves up and down on them. To solver this, use this modifier:
        .scrollBounceBehavior(.basedOnSize)
        .alert(alertTitle, isPresented: $showingAlert) { } message: {
            Text(alertMessage)
        }
    }
    
    func placeOrder() async {
        
        //Convert our current order object into some JSON data that can be sent
        guard let encoded = try? JSONEncoder().encode(order) else {
            print("Failed to encode order")
            return
        }
        
        //setting address to user defaults
        if saveAddressOnCache {
            UserDefaults.standard.set(encoded, forKey: "address")
        }
        
        //Telling Swift how to send that data over a network call
        let url = URL(string: urlString)!
        /*That first line contains a force unwrap for the URL(string:) initializer, which means “this returns an optional URL, but please force it to be non-optional.” Creating URLs from strings might fail because you inserted some gibberish, but here I hand-typed the URL so I can see it’s always going to be correct – there are no string interpolations in there that might cause problems*/
        var request = URLRequest(url: url)
        request.setValue("aplication/json", forHTTPHeaderField: "Content-Type")
        request.httpMethod = "POST"
        
        //Run that request and process the response
        do {
            let(data, _) = try await URLSession.shared.upload(for: request, from: encoded)
            //handle the result
            /*we’ll decode the data that came back, use it to set our confirmation message property, then set showingConfirmation to true so the alert appears. If the decoding fails – if the server sent back something that wasn’t an order for some reason – we’ll just print an error message*/
            let decodedOrder = try JSONDecoder().decode(Order.self, from: data)
            alertMessage = "Your order for \(decodedOrder.quantity)x \(Order.types[decodedOrder.type].lowercased()) cupcakes in on its way!"
            showingAlert = true
        } catch {
            alertTitle = "Sorry! There`s an Error on your Checkout"
            alertMessage = error.localizedDescription
            showingAlert = true
            //print("Check out failed: \(error.localizedDescription)")
        }
    }
    
}

#Preview {
    CheckOutView(order: Order(), saveAddressOnCache: true)
}
