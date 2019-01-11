//
//  LocalDishRepository.swift
//  CenaNavidad
//
//  Created by ALBERTO GURPEGUI RAMÓN on 10/1/19.
//  Copyright © 2019 David gimenez. All rights reserved.
//

import Foundation
import RealmSwift

class LocalDishRepository: Repository {
    
    func getCount(name: String) -> Int? {
        return 0
    }
    
    func getAll() -> [Dish] {
        var dishes: [Dish] = []
        do {
            let entities = try Realm().objects(DishEntity.self).sorted(byKeyPath: "id", ascending: false)
            for entity in entities {
                let model = entity.dishModel()
                dishes.append(model)
            }
        }
        catch let error as NSError {
            print("ERROR getAll Dishes: ", error.description)
        }
        return dishes
    }
    
    func get(identifier: String) -> Dish? {
        do{
            let realm = try Realm()
            if let entity = realm.objects(DishEntity.self).filter("id == %@", identifier).first{
                let model = entity.dishModel()
                return model
            }
        }
        catch {
            return nil
        }
        return nil
    }
    
    func get(name: String) -> Dish? {
        do{
            let realm = try Realm()
            if let entity = realm.objects(DishEntity.self).filter("name == %@", name).first{
                let model = entity.dishModel()
                return model
            }
        }
        catch {
            return nil
        }
        return nil
    }
    
    func create(a: Dish) -> Bool {
        do{
            let realm = try Realm()
            let entity = DishEntity(dish: a)
            try realm.write{
                realm.add(entity,update: true)
            }
        }
        catch{
            return false
        }
        return true
    }
    
    func delete(a: Dish) -> Bool {
        do{
            let realm = try Realm()
            try realm.write {
                let entityToDelete = realm.objects(DishEntity.self).filter("id == %@", a.id)
                realm.delete(entityToDelete)
            }
        }
        catch{
            return false
        }
        return true
    }
    
    func update(a: Dish) -> Bool {
        return create(a:a)
    }
}
