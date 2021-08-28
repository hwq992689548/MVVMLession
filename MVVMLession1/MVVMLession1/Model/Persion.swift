//
//  Persion.swift
//  MVVMLession1
//
//  Created by huangweiqiang on 2021/8/27.
//

import UIKit

struct Persion: Codable {
    let name: String
    let subName: String
    var isFollow: Bool
    
    init(name: String,
         subName: String,
         isFollow: Bool) {
        self.name = name
        self.subName = subName
        self.isFollow = isFollow
    }
}
