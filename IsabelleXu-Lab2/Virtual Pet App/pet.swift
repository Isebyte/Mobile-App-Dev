//
//  pet.swift
//  Virtual Pet App
//
//  Created by Isabelle Xu on 9/17/18.
//  Copyright © 2018 WashU. All rights reserved.
//

import Foundation
import UIKit

/* All value related calculations are completed in this class */
class Pet {
    let animal:String
    var color:UIColor
    var happiness:Int
    var hunger:Int
    var image:UIImage
    var numPoops:Int
    
    init(animalColor: UIColor, animalType: String, animalImage: UIImage) {
        color = animalColor
        animal = animalType
        happiness = 0
        hunger = 0
        numPoops = 0
        image = animalImage
    }
    
    // allow playing up to max of 10 happiness
    func play() {
        if hunger > 0 && happiness < 10 {
            hunger -= 1
            happiness += 1
        }
    }
    
    // allow feeding up to max of 10 hunger
    func feed() {
        let prev = hunger // previous hunger value before click
        if hunger < 10 {
            hunger += 1
        }
        if hunger == 10 && hunger != prev {
            numPoops += 1
        }
    }
    
    // each poop on screen = -1 happiness
    func poop() {
        if happiness > 0 {
            happiness -= 1
        }
    }
    
    // cleaning increases happiness in proportion to numPoops
    func clean() {
        if happiness < 10 && numPoops > 0 {
            // prevent happiness overload
            //print(numPoops)
            if (happiness + numPoops) <= 10 {
                happiness += numPoops
            } else if (happiness + numPoops > 10) {
                happiness = 10
            }
            numPoops = 0
        }
    }
    
}
