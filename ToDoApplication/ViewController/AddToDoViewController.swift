//
//  AddToDoViewController.swift
//  ToDoApplication
//
//  Created by Tushar on 27/09/19.
//  Copyright © 2019 Tushar. All rights reserved.
//

import UIKit
import CoreData

class AddToDoViewController: UIViewController {
    
    // MARK: Properties
    
    var mangeObjectContext: NSManagedObjectContext!
    var todo: Todo?
    
    // MARK: IBOutlets
    @IBOutlet weak var textView: UITextView!
    @IBOutlet weak var segmentController: UISegmentedControl!
    @IBOutlet weak var canelButton: UIButton!
    @IBOutlet weak var doneButton: UIButton!
    @IBOutlet weak var bottomConstriants: NSLayoutConstraint!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        NotificationCenter.default.addObserver(self,
                                               selector: #selector(keyBoardWillShow(with: )),
                                               name: UIResponder.keyboardWillShowNotification,
                                               object: nil)
        textView.resignFirstResponder()
        if let todo = todo {
            textView.text = todo.title
            textView.text = todo.title

            segmentController.selectedSegmentIndex = Int(todo.priotity)
        }
    }
    
    // MARK: Actions
    @objc func keyBoardWillShow(with notification: Notification) {
        let key = "UIKeyboardFrameEndUserInfoKey"
        
        guard let keyboardFrame = notification.userInfo?[key] as? NSValue else { return }
        
        let keyBoardHeight = keyboardFrame.cgRectValue.height + 10
        bottomConstriants.constant = keyBoardHeight
        UIView.animate(withDuration: 0.3) {
            self.view.layoutIfNeeded()
        }
        textView.becomeFirstResponder()
    }
    
    fileprivate func dismissAndResign() {
        textView.resignFirstResponder()
        dismiss(animated: true, completion: nil)
    }
    
    @IBAction func cancelAction(_ sender: UIButton) {
        dismissAndResign()
    }
    
    @IBAction func done(_ sender: UIButton) {
        
        guard let title = self.textView.text, !title.isEmpty else {
            return
        }
        
        if let todo = self.todo {
            todo.title = textView.text
            todo.priotity = Int16(segmentController.selectedSegmentIndex)
        } else {
            let todo = Todo(context: self.mangeObjectContext)
            todo.title = textView.text
            todo.priotity = Int16(segmentController.selectedSegmentIndex)
            todo.date = Date()
        }
        
        do {
            try mangeObjectContext.save()
            self.dismissAndResign()
        } catch {
            print("ERROR::", error)
        }
    }
}

extension AddToDoViewController: UITextViewDelegate {
    func textViewDidChangeSelection(_ textView: UITextView) {
        if doneButton.isHidden {
            textView.text.removeAll()
            textView.textColor = .white
            doneButton.isHidden = false
            
            UIView.animate(withDuration: 0.3) {
                self.view.layoutIfNeeded()
            }
        }
    }
}
