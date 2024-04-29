//
//  ErrorResponse.swift
//  GripTask
//
//  Created by Shraddha on 23/04/24.
//

import Foundation

struct ErrorResponse: Decodable {
    let message: String
}

extension ErrorResponse: LocalizedError {}
