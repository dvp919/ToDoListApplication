//
//  CoreDataService.swift
//  ToDo
//
//  Created by Dhruv Patel.
//

import Foundation
import CoreData

var isUrgent = false
var isComplete = false

class CoreDataService {
    
    static var shared = CoreDataService()
    
    func myFetchedResultControllerArr() ->  NSFetchedResultsController<ToDoDB> {
        let fetch =  ToDoDB.fetchRequest()
          fetch.sortDescriptors = [NSSortDescriptor.init(key: "date", ascending: true)]
          if isUrgent {
             fetch.predicate = NSPredicate(format: "urgent = %d", true)
          }
          else if isComplete {
                 fetch.predicate = NSPredicate(format: "complete = %d", true)
         }
     
         
          let context = persistentContainer.viewContext
         
         let fetchController = NSFetchedResultsController(fetchRequest: fetch, managedObjectContext: context, sectionNameKeyPath: nil, cacheName: nil)
          
          return fetchController
          
    }
    
    var myFetchedResultController : NSFetchedResultsController<ToDoDB> = {
         
       var fetch =  ToDoDB.fetchRequest()
         fetch.sortDescriptors = [NSSortDescriptor.init(key: "date", ascending: true)]
         if isUrgent {
            fetch.predicate = NSPredicate(format: "urgent = %d && complete = %d", true,false)
             
         }
         else if isComplete {
                fetch.predicate = NSPredicate(format: "complete = %d", true)
        }
    
        
         let context = persistentContainer.viewContext
        
        let fetchController = NSFetchedResultsController(fetchRequest: fetch, managedObjectContext: context, sectionNameKeyPath: nil, cacheName: nil)
         
         return fetchController
         
     }()
     
    

    func insertTaskToDB(todo: ToDo){
     // check if the task is not in the database
        //select * from ToDoDB where task == task and date == date

        let fetchRequest = ToDoDB.fetchRequest()
        fetchRequest.predicate = NSPredicate(format: "task MATCHES [c] %@ AND date == %@", todo.taskName as CVarArg , todo.taskDate as CVarArg)

        do {
        var taskList =  try persistentContainer.viewContext.fetch(fetchRequest)
            if taskList.count > 0 {


            }else {
                let newTask = ToDoDB(context: persistentContainer.viewContext)
                newTask.task = todo.taskName
    
                newTask.urgent = todo.isUrgent
                
                newTask.date = todo.taskDate
                newTask.complete = todo.isComplete

                saveContext()
            }
        }
        catch{}
    }

    func updateToDo(toUpdateToDo: ToDo,taskname: String,taskdate: Date ){
        
           let fetchRequest = ToDoDB.fetchRequest()
           fetchRequest.predicate = NSPredicate(format: "task MATCHES [c] %@ AND date == %@", taskname as CVarArg , taskdate as CVarArg)
        
           do {
               let taskList =  try persistentContainer.viewContext.fetch(fetchRequest)
               if let task = taskList.first{

                   task.task = toUpdateToDo.taskName
                   task.urgent = toUpdateToDo.isUrgent
                   task.date = toUpdateToDo.taskDate
                   task.complete = toUpdateToDo.isComplete
                   
                   saveContext()

               }else {
                  
               }
           }
           catch{}

    }

    func getAllToDos() -> [ToDoDB]{
       
        var todos = [ToDoDB]()
        let fetchRequest = ToDoDB.fetchRequest()

        fetchRequest.sortDescriptors = [NSSortDescriptor.init(key: "date", ascending: true)]
        if isUrgent {
            fetchRequest.predicate = NSPredicate(format: "urgent = %d && complete = %d", true,false)
             
        }
        else if isComplete {
            fetchRequest.predicate = NSPredicate(format: "complete = %d", true)
       }
        do{
            todos = try persistentContainer.viewContext.fetch(fetchRequest)

        }catch {


        }

        return todos


    }

    func deleteToDo(todoToDelete: ToDoDB){

        persistentContainer.viewContext.delete(todoToDelete)
        saveContext()

    }

    
        
        
        
        func saveContext () {
            let context = persistentContainer.viewContext
            if context.hasChanges {
                do {
                    try context.save()
                } catch {
                    let nserror = error as NSError
                    fatalError("Unresolved error \(nserror), \(nserror.userInfo)")
                }
            }
        }

}
var persistentContainer: NSPersistentContainer = {
    
       let container = NSPersistentContainer(name: "ToDo")
       container.loadPersistentStores(completionHandler: { (storeDescription, error) in
           if let error = error as NSError? {
              
               fatalError("Unresolved error \(error), \(error.userInfo)")
           }
       })
       return container
   }()
