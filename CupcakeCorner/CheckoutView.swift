//
//  CheckoutView.swift
//  CupcakeCorner
//
//  Created by Brando Lugo on 2/3/21.
//

import SwiftUI

struct CheckoutView: View {
    @ObservedObject var order: Order

    @State private var alertTitle = ""
    @State private var returnMessage = ""
    @State private var showAlert = false
    
    var body: some View {
        GeometryReader { geo in
            ScrollView {
                VStack {
                    Image("cupcakes")
                        .resizable()
                        .scaledToFit()
                        .frame(width: geo.size.width)
                    
                    Text("Your total is $\(self.order.cost, specifier: "%.2f")")
                        .font(.title)
                    
                    Button("Place order", action: {
                        //Place order
                        self.placeOrder()
                    })
                        .padding()
                }
            }
        }
        .navigationTitle("Checkout")
        .alert(isPresented: $showAlert, content: {
            Alert(title: Text(alertTitle), message: Text(returnMessage), dismissButton: .default(Text("Ok")))
        })
        
        
    }
    
    func placeOrder() {
        guard let encoded = try? JSONEncoder().encode(order)
        else {
            print("Failed to encode.")
            return
        }
        
        let url = URL(string: "https://reqres.in/api/cupcakes")!
        
        var request = URLRequest(url: url)
        
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")
        
        request.httpMethod = "POST"
        
        request.httpBody = encoded
        
        URLSession.shared.dataTask(with: request) { data, response, error in
            guard let data = data else {
                self.alertTitle = "Oops!"
                self.returnMessage = error?.localizedDescription ?? "Unknown"
                print("No data in response: \(error?.localizedDescription ?? "Unknown error").")
                self.showAlert = true
                return
            }
            
            if let decodedOrder = try? JSONDecoder().decode(Order.self, from: data) {
                self.alertTitle = "Thank you!🥰"
                self.returnMessage = "Your order for \(decodedOrder.quantity) \(Order.types[decodedOrder.type].lowercased()) cupcakes are on their way!"
                self.showAlert = true
            } else {
                print("Invaliid response from the server")
            }
        }.resume()
    }
}

struct CheckoutView_Previews: PreviewProvider {
    static var previews: some View {
        CheckoutView(order: Order())
    }
}
