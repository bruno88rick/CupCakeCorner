//
//  Order.swift
//  CupCakeCorner
//
//  Created by Bruno Oliveira on 21/05/24.
//

import SwiftUI

enum CodingKeys: String, CodingKey {
    case _type = "type"
    case _quantity = "quantity"
    case _specialRequestEnabled = "specialRequestEnabled"
    case _extraFrosting = "extraFrosting"
    case _addSprinkles = "addSprinkles"
    case _name = "name"
    case _city = "city"
    case _streetAddress = "streetAddress"
    case _zip = "zip"
}

@Observable
class Order: Codable {
    static let types = ["Vanilla", "Strawberry", "Chocolate", "Rainbow"]
    
    var type = 0
    var quantity = 3
    
    //Adding property observer to control extraFrosting and addSprinkles toggle to false when specialRequest toggle is set to false
    //from my side: ir specialrequest toggle set to true, then set all toggles to true too ;-)
    var specialRequestEnabled = false {
        didSet {
            if specialRequestEnabled == false {
                extraFrosting = false
                addSprinkles = false
            } else if specialRequestEnabled == true {
                extraFrosting = true
                addSprinkles = true
            }
        }
    }
    var extraFrosting = false
    var addSprinkles = false
    
    var name = ""
    var streetAddress = ""
    var city = ""
    var zip = ""
    
    var hasValidAddress: Bool {
        
        if name.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty || streetAddress.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty || city.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty || zip.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty {
            return false
        }
        return true
    }
    
    //decimal is better for money, explanation on the video
    var cost: Decimal {
        // $2 per cake
        var cost = Decimal(quantity) * 2
        
        //complicated cakes cost more
        cost += (Decimal(type) / 2)
        
        // $1/cake for extra frosting
        if extraFrosting {
            cost += Decimal(quantity)
        }
        
        //$0.50/cake for sprinkles
        if addSprinkles {
            cost += Decimal(quantity)
        }
        return cost
    }
}
