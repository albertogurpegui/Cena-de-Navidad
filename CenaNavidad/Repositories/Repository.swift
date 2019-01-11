//
//  Repository.swift
//  CenaNavidad
//
//  Created by Alberto gurpegui on 3/1/19.
//  Copyright © 2019 Alberto gurpegui. All rights reserved.
//

import Foundation

protocol Repository {
    associatedtype T
    
    func getAll() -> [T]
    func get(identifier:String) -> T?
    func get(name:String) -> T?
    func getCount(name:String) -> Int?
    func create(a:T) -> Bool
    func delete(a:T) -> Bool
    func update(a:T) -> Bool
}
