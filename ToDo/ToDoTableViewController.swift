//
//  ToDoTableViewController.swift
//  ToDo
//
//  Created by Dhruv Patel.
//

import UIKit
import CoreData

class ToDoTableViewController: UITableViewController,AddingDelegate,UpdatingDelegate,
                               NSFetchedResultsControllerDelegate {

    override func viewDidLoad() {
        super.viewDidLoad()
        
        CoreDataService.shared.myFetchedResultController.delegate
         = self
       
        do {
           try CoreDataService.shared.myFetchedResultController.performFetch()
            tableView.reloadData()
        }catch {
            
        }
        
        tableView.register(TableViewCell.self, forCellReuseIdentifier: "cell")
        
        
    }

    @IBAction func onSegmentSelect(_ sender: UISegmentedControl) {
        isUrgent = false
        isComplete = false
        
        if sender.selectedSegmentIndex == 1 {
            isUrgent = true
        }
        else if sender.selectedSegmentIndex == 2 {
            isComplete = true
        }
        do {
            try CoreDataService.shared.myFetchedResultController.performFetch()
            
            tableView.reloadData()
        }catch {

        }
    }
    // MARK: - Table view data source
    
   
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        return CoreDataService.shared.getAllToDos().count
        guard let sections = CoreDataService.shared.myFetchedResultController.sections else {
              return 0
           }
           let sectionInfo = sections[section]
           return sectionInfo.numberOfObjects
    }

    func taskAdded(todo: ToDo) {

        do {
            try CoreDataService.shared.myFetchedResultController.performFetch()
            tableView.reloadData()
        }catch {

        }
        
    }
    
    func taskUpdated(todo: ToDo) {
        do {
            try CoreDataService.shared.myFetchedResultController.performFetch()
            tableView.reloadData()
            
        }catch {

        }
    }
    
    
    func taskDidCancel() {
        
    }
    
    func taskUpdateDidCancel() {
        
    }
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath) as! TableViewCell

        let object = CoreDataService.shared.getAllToDos()[indexPath.row] //CoreDataService.shared.myFetchedResultController.object(at: indexPath)
        
        
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-dd h:mm"

        let optionalDate: Date? = (object as ToDoDB).date

        var optionalDateString: String?

        if let unwrappedDate = optionalDate {
            optionalDateString = dateFormatter.string(from: unwrappedDate)
        } else {
            optionalDateString = nil
        }

        cell.textLabel?.text = (object as ToDoDB).task
        cell.detailTextLabel?.text = optionalDateString
        
        
        if (object as ToDoDB).complete{
            
            let image = UIImage(systemName: "checkmark.circle.fill")
            cell.imageView?.image = image
            cell.imageView?.tintColor = UIColor.systemGreen
        }
        else{
            if (object as ToDoDB).urgent
            {
                let image = UIImage(systemName: "circle")
                cell.imageView?.image = image
                cell.imageView?.tintColor = UIColor.red
                
                
            }else{
               
                let image = UIImage(systemName: "circle")
                cell.imageView?.image = image
                cell.imageView?.tintColor = UIColor.blue
            }
        }
        return cell
    }
    

    
    // Override to support conditional editing of the table view.
    override func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        // Return false if you do not want the specified item to be editable.
        return true
    }
    

    
    // Override to support editing the table view.
    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        let object = CoreDataService.shared.myFetchedResultController.object(at: indexPath)
        
        if editingStyle == .delete {
            CoreDataService.shared.deleteToDo(todoToDelete: object as ToDoDB)

            do {
                try CoreDataService.shared.myFetchedResultController.performFetch()
                tableView.reloadData()
            }catch {

            }
            

        } else if editingStyle == .insert {
            // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
        }
    }
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        performSegue(withIdentifier: "toUpdate", sender: self)
    }

    /*
    // Override to support rearranging the table view.
    override func tableView(_ tableView: UITableView, moveRowAt fromIndexPath: IndexPath, to: IndexPath) {

    }
    */

    /*
    // Override to support conditional rearranging of the table view.
    override func tableView(_ tableView: UITableView, canMoveRowAt indexPath: IndexPath) -> Bool {
        // Return false if you do not want the item to be re-orderable.
        return true
    }
    */


    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
        
        if segue.identifier == "toAddTask"{
            let SVC = segue.destination as! AddTaskViewController
            SVC.delegate = self
        }
        else {

            let index = (tableView.indexPathForSelectedRow)!
            let UVC = segue.destination as! UpdateTaskViewController
            UVC.delegate = self
            let object = CoreDataService.shared.myFetchedResultController.object(at: index)

            UVC.selectedTask = ToDo(task: (object as ToDoDB).task!, urgent:  (object as ToDoDB).urgent, complete: (object as ToDoDB).complete, date:  (object as ToDoDB).date!)



        }
        
        
    }
    
    


}
