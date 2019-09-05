//
//  Item.swift
//  Accomplish
//
//  Created by Jacob Rozell on 9/4/19.
//  Copyright © 2019 Jacob Rozell. All rights reserved.
//

import Foundation

struct Item: Codable {
    let title: String
    var done: Bool
    
    init(title: String="", done: Bool=false) {
        self.title = title
        self.done = done
    }
}
