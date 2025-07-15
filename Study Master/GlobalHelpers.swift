//
//  GlobalHelpers.swift
//  Study Master
//
//  Created by Finley Room on 7/14/25.
//
import SwiftUI

struct IdentifiableDate: Identifiable {
    let date: Date
    var id: Date { date }
}
