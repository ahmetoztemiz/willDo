//
//  Item.swift
//  willDo
//
//  Created by ahmet on 6.08.2018.
//  Copyright © 2018 ahmetoztemiz. All rights reserved.
//

import Foundation
import RealmSwift

class Item: Object {
    @objc dynamic var title: String = ""
    @objc dynamic var check: Bool = false
    @objc dynamic var dateCreated = Date()
    
    var parentCategory = LinkingObjects(fromType: Category.self, property: "items")
}
