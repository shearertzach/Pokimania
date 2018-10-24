//
//  ViewController.swift
//  pokemania
//
//  Created by Zach Shearer on 10/24/18.
//  Copyright © 2018 Zach Shearer. All rights reserved.
//

import UIKit
import Alamofire
import SwiftyJSON
import SDWebImage

class ViewController: UIViewController {
    
    let baseURL = "https://pokeapi.co/api/v2/pokemon/"

    @IBOutlet weak var pokemonTextField: UITextField!
    @IBOutlet weak var statsField: UITextView!
    @IBOutlet weak var nameField: UITextView!
    @IBOutlet weak var abilityField: UITextView!
    @IBOutlet weak var itemField: UITextView!
    @IBOutlet weak var moveField: UITextView!
    @IBOutlet weak var typeField: UITextView!
    @IBOutlet weak var imageField: UIImageView!
    
    
    

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
    }

    @IBAction func submitButtonTapped(_ sender: Any) {
        guard let pokemonNameOrID = pokemonTextField.text else {
            return
        }
        
        let requestURL = baseURL + pokemonNameOrID.lowercased().replacingOccurrences(of: " ", with: "+")
        let request = Alamofire.request(requestURL)
        
        request.responseJSON { response in
            switch response.result {
            case .success(let value):
                let json = JSON(value)
                
                if let speciesName = json["species"]["name"].string {
                    self.nameField.text = speciesName.capitalized
                }
                
                
                var abilities = ""
                
                if let abilitiesJSON = json["abilities"].array {
                    for ability in abilitiesJSON {
                        if let abilityName = ability["ability"]["name"].string {
                            abilities += ("\(abilityName.capitalized)\n")
                        }
                    }
                    self.abilityField.text = abilities
                }
                
                
                var displayStats = ""
                var baseStats = ""
                if let stats = json["stats"].array {
                    for stat in stats {
                        if let baseStat = stat["base_stat"].int {
                            baseStats = String(baseStat)
                            print(baseStats)
                        } else {
                            print("failed to grab string.")
                        }
                        
                        if let statName = stat["stat"]["name"].string {
                            displayStats += ("\(statName.capitalized) - \(baseStats) \n")
                        }
                    }
                    self.statsField.text = displayStats
                }
                
                var moveString = ""
                if let moves = json["moves"].array {
                    for move in moves {
                        if let moveName = move["move"]["name"].string {
                            moveString += ("\(moveName.capitalized)\n")
                        }
                    }
                    self.moveField.text = moveString
                }
                
                var itemString = ""
                if let items = json["held_items"].array {
                    for item in items {
                        if let itemName = item["item"]["name"].string {
                            itemString += ("\(itemName.capitalized)\n")
                        }
                    }
                    self.itemField.text = itemString
                }
                
                var typeString = ""
                if let types = json["types"].array {
                    for type in types {
                        if let typeName = type["type"]["name"].string {
                            typeString += ("\(typeName)\n")
                        }
                    }
                    self.typeField.text = typeString
                }
                
                if let spriteURL = json["sprites"]["front_default"].string {
                    if let url = URL(string: spriteURL) {
                        self.imageField.sd_setImage(with: url, completed: nil)
                    }
                }
                
                
                
                
                
                
                
               self.pokemonTextField.text = ""
                
            case .failure(let error):
                print(error.localizedDescription)
                
            }
        }
    }
    
}

