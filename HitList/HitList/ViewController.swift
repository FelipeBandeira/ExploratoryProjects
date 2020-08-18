//
//  ViewController.swift
//  HitList
//
//  Created by Felipe Bandeira on 17/08/20.
//  Copyright © 2020 SaiaRodada. All rights reserved.
//

import UIKit
import CoreData

class ViewController: UIViewController {
    
    @IBOutlet weak var tableView: UITableView!
    var people: [NSManagedObject] = []
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        
        title = "The List"
        
        tableView.register(UITableViewCell.self, forCellReuseIdentifier: "Cell")
        
    }
    
    
    
    @IBAction func addName(_ sender: UIBarButtonItem) {
        
        let alert = UIAlertController(title: "New Name", message: "Add a new name", preferredStyle: .alert)
        
        let saveAction = UIAlertAction(title: "Save", style: .default) {
            //o que é unowned self?
            [unowned self] action in
            
            //o que é o guard, de guard let? O que ele faz?
            guard let textField = alert.textFields?.first,
                let nameToSave = textField.text else {
                    //o que esse return tá retornando? Qual a necessidade dele aqui?
                    return
            }
            
            self.save(name: nameToSave)
            self.tableView.reloadData()
        }
        
        let cancelAction = UIAlertAction(title: "Cancel", style: .cancel)
        
        alert.addTextField()
        
        alert.addAction(saveAction)
        alert.addAction(cancelAction)
        
        present(alert, animated: true)
    }
    
    
    func save(name: String) {
        
        guard let appDelegate =
            UIApplication.shared.delegate as? AppDelegate else {
                return
        }
        
        //1) Estou abrindo um caminho até o meu container de dados
        let managedContext =
            appDelegate.persistentContainer.viewContext
        
        //2) Estou criando um objeto do tipo Person (as definições de Person estão guardadas no container)
        let entity =
            NSEntityDescription.entity(forEntityName: "Person",
                                       in: managedContext)!
        
        //3) Estou colocando esse objeto criado dentro do container
        let person = NSManagedObject(entity: entity,
                                     insertInto: managedContext)
        
       //4) Estou fazendo algumas modificações no objeto
        person.setValue(name, forKeyPath: "name")
        
        
        do {
            try managedContext.save()
            //se eu acabei de salvar as modificações que fiz no container, por que vou dar append?
            people.append(person)
        } catch let error as NSError {
            print("Could not save. \(error), \(error.userInfo)")
        }
    }
    
}

// MARK: - UITbaleViewDataSource

extension ViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return people.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let person = people[indexPath.row]
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "Cell", for: indexPath)
        
        cell.textLabel?.text = person.value(forKey: "name") as? String
        return cell
    }
}
