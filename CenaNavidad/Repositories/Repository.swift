//
//  Repository.swift
//  CenaNavidad
//
//  Created by David gimenez on 6/1/19.
//  Copyright © 2019 David gimenez. All rights reserved.
//

import Foundation

protocol Repository {
    associatedtype T
    
    func getAll() -> [T]
    func get(identifier:String) -> T?
    func create(a:T) -> Bool
    func update(a:T) -> Bool
    func delete(a:T) -> Bool
}
