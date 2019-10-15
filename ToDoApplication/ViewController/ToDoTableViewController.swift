//
//  ToDoTableViewController.swift
//  ToDoApplication
//
//  Created by Tushar on 27/09/19.
//  Copyright © 2019 Tushar. All rights reserved.
//

import UIKit
import CoreData

class ToDoTableViewController: UITableViewController {
    
    // MARK: Properties
    var resultsController: NSFetchedResultsController<Todo>!
    let coreDataStack = CoreDataStack()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        featchData()
    }
    
    private func featchData() {
        // Request
        let request: NSFetchRequest<Todo> = Todo.fetchRequest()
        let sortDescriptor = NSSortDescriptor.init(key: "date", ascending: true)
        
        // Init
        request.sortDescriptors = [sortDescriptor]
        resultsController = NSFetchedResultsController.init(fetchRequest: request,
                                                            managedObjectContext: coreDataStack.manageContext, sectionNameKeyPath: nil, cacheName: nil)
        resultsController.delegate = self
        // Fetch
        do {
            try resultsController.performFetch()
        } catch {
            print("Error:::", error)
        }
        
    }
    
    // MARK: - Table view data source
    
    
    override func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return resultsController.sections?[section].numberOfObjects ?? 0
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "reuseIdentifier", for: indexPath)
        let todo = resultsController.object(at: indexPath)
        cell.textLabel?.text = todo.title
        return cell
    }
    
    
    
    // MARK: Tableview Delegate
    
    override func tableView(_ tableView: UITableView, trailingSwipeActionsConfigurationForRowAt indexPath: IndexPath) -> UISwipeActionsConfiguration? {
        
        let action = UIContextualAction.init(style: .destructive, title: "Delete") { (action, view, completion) in
            let todo = self.resultsController.object(at: indexPath)
            self.resultsController.managedObjectContext.delete(todo)
            do  {
                try self.resultsController.managedObjectContext.save()
                completion(true)
            } catch {
                print("save error")
                completion(false)
            }
            
        }
        action.backgroundColor = .red
        action.image = UIImage(named: "trash")
        return UISwipeActionsConfiguration(actions: [action])
    }
    
    
    override func tableView(_ tableView: UITableView, leadingSwipeActionsConfigurationForRowAt indexPath: IndexPath) -> UISwipeActionsConfiguration? {
        
        let action  = UIContextualAction.init(style: .destructive, title: "Check") { (action, view, completion) in
            let todo = self.resultsController.object(at: indexPath)
            self.resultsController.managedObjectContext.delete(todo)
            do  {
                try self.resultsController.managedObjectContext.save()
                completion(true)
            } catch {
                print("save error")
                completion(false)
            }
        }
        action.backgroundColor = .green
        action.image = UIImage(named: "check")
        return UISwipeActionsConfiguration(actions: [action])
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        performSegue(withIdentifier: "TODOSegue", sender: tableView.cellForRow(at: indexPath))
    }
    
    @IBAction func addAction(_ sender: Any) {
        
    }
    
    // MARK: - Navigation
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if let _ = sender as? UIBarButtonItem, let vc = segue.destination as? AddToDoViewController {
            vc.mangeObjectContext = resultsController.managedObjectContext
        }
        if let cell = sender as? UITableViewCell, let vc = segue.destination as? AddToDoViewController {
            vc.mangeObjectContext = resultsController.managedObjectContext
            if let indexpath = tableView.indexPath(for: cell) {
                let todo =  resultsController.object(at: indexpath)
                vc.todo = todo
            }
        }
    }
}

extension ToDoTableViewController: NSFetchedResultsControllerDelegate {
    func controllerWillChangeContent(_ controller: NSFetchedResultsController<NSFetchRequestResult>) {
        
    }
    
    func controllerDidChangeContent(_ controller: NSFetchedResultsController<NSFetchRequestResult>) {
        
    }
    
    func controller(_ controller: NSFetchedResultsController<NSFetchRequestResult>, didChange anObject: Any, at indexPath: IndexPath?, for type: NSFetchedResultsChangeType, newIndexPath: IndexPath?) {
        
        switch type {
        case .insert:
            if let indexPath = newIndexPath {
                tableView.insertRows(at: [indexPath], with: .automatic)
            }
        case .delete:
            if let indexPath = newIndexPath {
                tableView.deleteRows(at: [indexPath], with: .automatic)
            }
        case .update:
            if let indexPath = indexPath, let cell = tableView.cellForRow(at: indexPath) {
                let todo = resultsController.object(at: indexPath)
                cell.textLabel?.text = todo.title
            }
        default:
            break
        }
    }
}
