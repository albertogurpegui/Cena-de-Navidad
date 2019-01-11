//
//  Paticipant.swift
//  CenaNavidad
//
//  Created by Alberto gurpegui on 3/1/19.
//  Copyright © 2019 Alberto gurpegui. All rights reserved.
//

import UIKit

class Participant {
    var id:String!
    var name:String!
    var paid = false
    var creationDate:Date!
    var dishes:[Dish] = []
}
