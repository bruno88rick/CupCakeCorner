//
//  String-EmptyChecking.swift
//  CupCakeCorner
//
//  Created by Bruno Oliveira on 24/05/24.
//

import Foundation

//better way of solution
extension String {
    var isReallyEmptyAndJustWhiteSpace: Bool {
        self.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty
    }
}
