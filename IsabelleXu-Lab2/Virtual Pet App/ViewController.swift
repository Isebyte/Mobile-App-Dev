//
//  ViewController.swift
//  Virtual Pet App
//
//  Created by Isabelle Xu on 9/15/18.
//  Copyright © 2018 WashU. All rights reserved.
//
/** CREATIVE PORTION
 *
 * 1. Pooping randomly on board
 * 2. cleaning functionality (-1 happiness for each poop, +n for clean)
 * icon credit: Icons made by smalllikeart from "https://www.flaticon.com/" is licensed by Creative Commons 3.0" CC 3.0
 * 3. Clicking on Pet gives you its thoughts
 */

import UIKit

class ViewController: UIViewController {
    
    // Dictionary of pets and their saved infomation
    let availablePets:[String: Pet] = [
        "Dog": Pet(animalColor: UIColor(red: 255/255.0, green: 0/255.0, blue: 0/255.0, alpha: 1.00), animalType: "Dog", animalImage: UIImage(named:"dog")!),
        "Cat": Pet(animalColor: UIColor(red: 255/255.0, green: 153/255.0, blue: 0/255.0, alpha: 1.00), animalType: "Cat", animalImage: UIImage(named:"cat")!),
        "Bird": Pet(animalColor: UIColor(red: 255/255.0, green: 214/255.0, blue: 0/255.0, alpha: 1.00), animalType: "Bird", animalImage: UIImage(named:"bird")!),
        "Bunny": Pet(animalColor: UIColor(red: 149/255.0, green: 22/255.0, blue: 75/255.0, alpha: 1.00), animalType: "Bunny", animalImage: UIImage(named:"bunny")!),
        "Fish": Pet(animalColor: UIColor(red: 68/255.0, green: 208/255.0, blue: 255/255.0, alpha: 1.00), animalType: "Fish", animalImage: UIImage(named:"fish")!)
    ]
    
    
    var currentPet: Pet! // keeps track of currently active pet
    
    @IBOutlet weak var backgroundView: UIView!
    @IBOutlet weak var happinessDV: DisplayView!
    @IBOutlet weak var hungerDV: DisplayView!
    @IBOutlet weak var happinessVal: UILabel!
    @IBOutlet weak var hungerVal: UILabel!
    
    @IBOutlet weak var poopLayer: UIView!
    @IBOutlet weak var animalImage: UIButton!
    
    /* Play with pet when pressed */
    @IBAction func playBtn(_ sender: UIButton) {
        currentPet.play()
        updateHunger()
        updateHappiness()
    }
    @IBAction func petBtn(_ sender: UIButton) {
        feelingPrompt()
    }
    
    /* Feed pet when pressed */
    @IBAction func feedBtn(_ sender: UIButton) {
        let prev = currentPet.hunger
        currentPet.feed()
        // prevent poop overload
        if currentPet.hunger == 10 && currentPet.hunger != prev {
            setPoop()
            currentPet.poop()
        }
        updateHunger()
        updateHappiness()
    }
    
    /* Draws a poop somewhere random on the colored view */
    func setPoop() {
        // set poop image randomly within view's bounds
        let viewWidth = poopLayer.frame.width
        let viewHeight = poopLayer.frame.height
        
        let view_x = CGFloat(arc4random_uniform(UInt32(viewWidth) - 45))
        let view_y = CGFloat(arc4random_uniform(UInt32(viewHeight) - 45))
        
        let image = UIImage(named: "poop")
        let imageView = UIImageView(image: image!)
        imageView.frame = CGRect(x: view_x, y: view_y, width: 45, height: 45)
        imageView.tag = currentPet.numPoops
        
        poopLayer.addSubview(imageView)
    }

    /* Cleans pet when pressed */
    @IBAction func cleanBtn(_ sender: UIButton) {
        removePoops()
        currentPet.clean()
        happinessDV.animateValue(to:CGFloat(currentPet.happiness)/10)
        happinessVal.text = String(currentPet.happiness)
    }
    
    // removes poop UIViews from screen
    func removePoops() {
        // print("Removing poops")
        // remove all poop subviews from poop layer
        poopLayer.subviews.forEach { (item) in
            item.removeFromSuperview()
        }
    }
    
    /* Shows a prompt with pet's current feelings */
    func feelingPrompt() {
        var message = ""
        if currentPet.happiness == 0 || currentPet.hunger == 0 {
            message = "Your pet looks at you miserably. Shame on you. Shame."
        } else if currentPet.happiness >= 5 && currentPet.happiness < 10 {
            message = "Your pet seems moderately happy."
        } else if currentPet.hunger >= 5 && currentPet.hunger < 10 {
            message = "Your pet rubs its stomach neutrally."
        } else if currentPet.happiness == 10 && currentPet.hunger == 10 {
            message = "Hey, your pet looks great! It waves at you contently."
        } else {
            message = "You swear that you pet winked at you."
        }
        
        let alert = UIAlertController(title: currentPet.animal, message: message, preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "Ok", style: .default, handler: nil))
        self.present(alert, animated: true)
    }
    
    /* Pet switching; values must update immediately upon switching */
    @IBAction func dogBtn(_ sender: UIButton) {
        currentPet = availablePets["Dog"]!
        loadValues()
    }
    
    @IBAction func catBtn(_ sender: UIButton) {
        currentPet = availablePets["Cat"]!
        loadValues()
    }
    
    @IBAction func birdBtn(_ sender: UIButton) {
        currentPet = availablePets["Bird"]!
        loadValues()
    }
    
    @IBAction func bunnyBtn(_ sender: UIButton) {
        currentPet = availablePets["Bunny"]!
        loadValues()
    }
    
    @IBAction func fishBtn(_ sender: UIButton) {
        currentPet = availablePets["Fish"]!
        loadValues()
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        view.translatesAutoresizingMaskIntoConstraints = false
        currentPet = availablePets["Dog"]! 
        loadValues()
        // allow pet image to be clicked
    
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    /* Updates current UIColor, as well as current pet */
    func updateColor() {
        let currentColor = currentPet.color
        happinessDV.color = currentColor
        hungerDV.color = currentColor
        backgroundView.backgroundColor = currentColor
    }
    
    /* Updates current Pet happiness and animates change */
    func updateHappiness() {
        happinessVal.text = String(currentPet.happiness)
        let happiness = CGFloat(currentPet.happiness) / 10
        happinessDV.animateValue(to: happiness)
    }
    
    /* Updates current Pet hunger and animates change */
    func updateHunger() {
        hungerVal.text = String(currentPet.hunger)
        let hunger = CGFloat(currentPet.hunger) / 10
        hungerDV.animateValue(to: hunger)
    }
    
    /* Immediates loads new pet color and saved values without animation */
    func loadValues() {
        // clear poops from screen
        
        removePoops()
        var numPoops = currentPet.numPoops
        //print("New Pet numPoops: " + String(numPoops))
        
        // redraw saved numPoops
        while numPoops > 0 {
            setPoop()
            numPoops -= 1
        }
        updateColor()
        let happiness = CGFloat(currentPet.happiness) / 10
        let hunger = CGFloat(currentPet.hunger) / 10
        happinessDV.value = happiness
        hungerDV.value = hunger
        happinessVal.text = String(currentPet.happiness)
        hungerVal.text = String(currentPet.hunger)
        animalImage.setImage(currentPet.image, for: .normal)
    }

}

// for debugging purposes. See: https://stackoverflow.com/questions/11664115/unable-to-simultaneously-satisfy-constraints-will-attempt-to-recover-by-breakin
extension NSLayoutConstraint {
    
    override open var description: String {
        let id = identifier ?? ""
        return "id: \(id), constant: \(constant)" //you may print whatever you want here
    }
}



