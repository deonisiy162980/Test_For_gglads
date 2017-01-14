//
//  CoreDataClass.swift
//  CoreDataTEST
//
//  Created by Denis on 03.09.16.
//  Copyright © 2016 Denis. All rights reserved.
//

import Foundation
import CoreData

class CoreDataManager
{
    //----------Settings------------\\
    static let instance = CoreDataManager()
    let nameOfCoreDataFile = "Test_for_gglads"
    
    //==============================\\
    
    
    lazy var applicationDocumentsDirectory: NSURL = {
        /*Здесь четыре переменные, все они инициализируются с помощью замыкания. Однако, первая из них, applicationDocumentsDirectory — просто вспомогательный метод, который возвращает директорию для хранения данных. По умолчанию, это Document Directory, можно изменить, но маловероятно, что вам это действительно надо. Реализация проста и не должна вызывать затруднений для понимания.*/
        let urls = NSFileManager.defaultManager().URLsForDirectory(.DocumentDirectory, inDomains: .UserDomainMask)
//        print(urls[urls.count-1])
        return urls[urls.count-1]
    }()
    
    lazy var managedObjectModel: NSManagedObjectModel = {
        /*Логика программного кода незамысловата — получаем из сборки приложения некий файл с расширением momd и создаем на основании его объектную модель данных. Осталось выяснить, что это за файл такой. Посмотрите на файлы в Навигаторе проекта (Project navigator), там вы найдете файл с расширением xdatamodel — это наша модель данных Core Data (как с ней работать мы рассмотрим чуть позже), которая при компиляции проекта включается в файл-сборку приложения с расширением momd.*/
        let modelURL = NSBundle.mainBundle().URLForResource(self.nameOfCoreDataFile, withExtension: "momd")!
        return NSManagedObjectModel(contentsOfURL: modelURL)!
    }()
    
    lazy var persistentStoreCoordinator: NSPersistentStoreCoordinator = {
        /*Здесь на основе объектной управляемой модели создается координатор постоянного хранилища. Затем мы определяем, где именно должны храниться данные. И в заключении подключаем собственно само хранилище (coordinator.addPersistentStoreWithType), передав соответствующему методу в качестве параметров тип хранилища и его расположение. По умолчанию используется SQLite. В двух других параметрах могут передаваться дополнительные параметры и опции, но на данном этапе нам это не надо, поэтому просто передадим nil.*/
        let coordinator = NSPersistentStoreCoordinator(managedObjectModel: self.managedObjectModel)
        let url = self.applicationDocumentsDirectory.URLByAppendingPathComponent("SingleViewCoreData.sqlite")
        var failureReason = "There was an error creating or loading the application's saved data."
        do {
            try coordinator.addPersistentStoreWithType(NSSQLiteStoreType, configuration: nil, URL: url, options: nil)
        } catch {
            // Report any error we got.
            var dict = [String: AnyObject]()
            dict[NSLocalizedDescriptionKey] = "Failed to initialize the application's saved data"
            dict[NSLocalizedFailureReasonErrorKey] = failureReason
            
            dict[NSUnderlyingErrorKey] = error as NSError
            let wrappedError = NSError(domain: "YOUR_ERROR_DOMAIN", code: 9999, userInfo: dict)
            
            NSLog("Unresolved error \(wrappedError), \(wrappedError.userInfo)")
            abort()
        }
        
        return coordinator
    }()
    
    lazy var managedObjectContext: NSManagedObjectContext = {
        /*Здесь мы создаем новый контекст управляемого объекта и присваиваем ему ссылку на наш координатор постоянного хранилища, с помощью которого он и будет читать и писать необходимые нам данные. Деталь, заслуживающая внимания — аргумент конструктора NSManagedObjectContext. В общем случае, может быть несколько рабочих контекстов выполняемых в разных потоках (например, один для интерактивной работы, другой — для фоновой подгрузки данных). Передавая в качестве аргумента MainQueueConcurrencyType, мы указываем, что данный контекст должен быть создан в основном потоке.*/
        let coordinator = self.persistentStoreCoordinator
        var managedObjectContext = NSManagedObjectContext(concurrencyType: .MainQueueConcurrencyType)
        managedObjectContext.persistentStoreCoordinator = coordinator
        return managedObjectContext
    }()
    
    //MARK: Core Data Saving support
    func saveContext ()
    {
        if managedObjectContext.hasChanges
        {
            do {
                try managedObjectContext.save()
            } catch
            {
                let nserror = error as NSError
                NSLog("Unresolved error \(nserror), \(nserror.userInfo)")
                abort()
            }
        }
    }
    
    //MARK: Entity for name
    func entityForName(entityName: String) -> NSEntityDescription
    {
        return NSEntityDescription.entityForName(entityName, inManagedObjectContext: self.managedObjectContext)!
    }
}

//MARK: инициализация FRC
extension CoreDataManager
{
    func configureAndReturnFRC (
        
        withEntityName name : String ,
                       sortDescriptorKey key : String ,
                                         accendingFlag accending : Bool ,
                                                       managedContext context : NSManagedObjectContext,
                                                                      withPredicate predicate : NSPredicate?,
                                                                                    withBatchSize batchSize : Int?
        
        ) -> NSFetchedResultsController
    {
        let entityDescription = NSEntityDescription.entityForName(name, inManagedObjectContext: context)
        let sortDescriptor = NSSortDescriptor(key: key, ascending: accending)
        
        let fetchRequest = NSFetchRequest()
        fetchRequest.entity = entityDescription
        fetchRequest.sortDescriptors = [sortDescriptor]
        fetchRequest.predicate = predicate
        if let size = batchSize {
            fetchRequest.fetchBatchSize = size
        }
        
        let frc = NSFetchedResultsController(fetchRequest: fetchRequest, managedObjectContext: context, sectionNameKeyPath: nil, cacheName: nil)
        
        return frc
    }
}


//MARK: Очистка устаревших данных
extension CoreDataManager
{
    func deleteProducts (context : NSManagedObjectContext)
    {
        let insideSemaphore = dispatch_semaphore_create(0)
        
        let fetchRequest = NSFetchRequest(entityName: "Product")
        
        do
        {
            let fetchedEntities = try context.executeFetchRequest(fetchRequest)
            
            for product in fetchedEntities {
                context.deleteObject(product as! NSManagedObject)
            }
            
            dispatch_semaphore_signal(insideSemaphore)
        }
        catch{}
        
        dispatch_semaphore_wait(insideSemaphore, DISPATCH_TIME_FOREVER)
    }
    
    
    func deleteCategories (context : NSManagedObjectContext)
    {
        let insideSemaphore = dispatch_semaphore_create(0)
        
        let fetchRequest = NSFetchRequest(entityName: "Category")
        
        do
        {
            let fetchedEntities = try context.executeFetchRequest(fetchRequest)
            
            for category in fetchedEntities {
                context.deleteObject(category as! NSManagedObject)
            }
            
            dispatch_semaphore_signal(insideSemaphore)
        }
        catch{}
        
        dispatch_semaphore_wait(insideSemaphore, DISPATCH_TIME_FOREVER)
        
    }
}