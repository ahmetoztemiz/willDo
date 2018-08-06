//
//  Category.swift
//  willDo
//
//  Created by ahmet on 6.08.2018.
//  Copyright © 2018 ahmetoztemiz. All rights reserved.
//

import Foundation
import RealmSwift

class Category: Object {
    @objc dynamic var name: String = ""
    var items = List<Item>()
}
