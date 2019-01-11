//
//  DishEntity.swift
//  CenaNavidad
//
//  Created by ALBERTO GURPEGUI RAMÓN on 10/1/19.
//  Copyright © 2019 David gimenez. All rights reserved.
//

import Foundation
import RealmSwift

class DishEntity: Object {
    
    @objc dynamic var id = ""
    @objc dynamic var name = ""
    
    
    override static func primaryKey() -> String?{
        return "id"
    }
    
    convenience init(dish: Dish) {
        self.init()
        self.id = dish.id
        self.name = dish.name
    }
    
    func dishModel() -> Dish {
        let model = Dish()
        model.id = id
        model.name = name
        return model
    }
    
}
