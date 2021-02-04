//
//  AddressView.swift
//  CupcakeCorner
//
//  Created by Brando Lugo on 2/3/21.
//

import SwiftUI

struct AddressView: View {
    @ObservedObject var order: Order
    
    var body: some View {
            Form {
                Section {
                    TextField("Name", text: $order.name)
                    TextField("Street Address", text: $order.streetAddress)
                    TextField("City", text: $order.city)
                    TextField("Zip", text: $order.zip)
                }
                
                Section {
                    NavigationLink("Check Out", destination: CheckoutView(order: order))
                }
                .disabled(order.hasValidAddress == false)
            }
            .navigationBarTitle("Delivery Details")
        
        
    }
}

struct AddressView_Previews: PreviewProvider {
    static var previews: some View {
        AddressView(order: Order())
    }
}
