//
//  RateHistoryTableViewController.swift
//  Bitcoins
//
//  Created by SukPoet on 2022/10/21.
//

import UIKit
import CoreData

class RateHistoryTableViewController: UITableViewController {

    @IBOutlet var sortBarButtonItem: UIBarButtonItem!
    
    let appDelegate = UIApplication.shared.delegate as? AppDelegate
    var thaiDateFormater = DateFormatter()
    
    var fetchRequest: NSFetchRequest<Minute> = Minute.fetchRequest()
    
    private lazy var persistentContainer: NSPersistentContainer = {
        return appDelegate!.persistentContainer
    }()

    private lazy var fetchedResultsController: NSFetchedResultsController<Minute> = {
        fetchRequest.sortDescriptors = [NSSortDescriptor(key: "time", ascending: false)]
        let controller = NSFetchedResultsController(fetchRequest: fetchRequest,
                                                    managedObjectContext: persistentContainer.viewContext,
                                                    sectionNameKeyPath: nil, cacheName: nil)
        controller.delegate = self
    
        do {
            try controller.performFetch()
        } catch {
            fatalError("###\(#function): Failed to performFetch: \(error)")
        }
        return controller
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        thaiDateFormater.locale = Locale(identifier: "th-TH");
        thaiDateFormater.dateStyle = .medium
        thaiDateFormater.timeStyle = .medium
        // Uncomment the following line to preserve selection between presentations
        // self.clearsSelectionOnViewWillAppear = false

        // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
         self.navigationItem.rightBarButtonItems = [self.editButtonItem,sortBarButtonItem]
    }

    override func viewDidDisappear(_ animated: Bool) {
        super.viewDidDisappear(animated)
        appDelegate?.saveContext()
    }
    
    // MARK: - Table view data source
    override func numberOfSections(in tableView: UITableView) -> Int {
        return fetchedResultsController.sections?.count ?? 1
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        return fetchedResultsController.sections?[section].numberOfObjects ?? 0
    }

    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "CurrencyRateCell", for: indexPath) as? HistoryRateTableViewCell else {
            fatalError("###\(#function): Failed to dequeue a CurrencyRateCell. Check the cell reusable identifier in Main.storyboard.")
        }
        // Configure the cell...
        let minute = fetchedResultsController.object(at: indexPath)
        cell.refresh(with: minute)
        if let time = minute.time {
            cell.timeLabel.text = thaiDateFormater.string(from: time)
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
        if editingStyle == .delete {
            // Delete the row from the data source
            let minute = fetchedResultsController.object(at: indexPath)
            let context = persistentContainer.viewContext
            context.delete(minute)
            if context.hasChanges {
                do {
                    try context.save()
                } catch {
                    let nserror = error as NSError
                    print("Unresolved error \(nserror), \(nserror.userInfo)")
                    tableView.setEditing(false, animated: true)
                }
            }
        }
    }

    // MARK: - Navigation
    @IBAction func unwind2RecordPageAction(unwindSegue: UIStoryboardSegue) {
        if let source = unwindSegue.source as? BTCRecordSortViewController {
            if source.shouldResort {
                let sortKey = "\(source.currencyName2SortBy.rawValue).rate_float"
                fetchRequest.sortDescriptors = [NSSortDescriptor(key: sortKey, ascending: source.is2SortAscend)]
                do {
                    try fetchedResultsController.performFetch()
                } catch {
                    fatalError("###\(#function): Failed to performFetch: \(error)")
                }
                tableView.reloadData()
            }
        }
    }
    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
        if let destination = segue.destination as? BTCRecordSortViewController {
            destination.transitioningDelegate = self
            destination.modalPresentationStyle = .custom
        }
    }
}

// MARK: - NSFetchedResultsControllerDelegate
//
extension RateHistoryTableViewController: NSFetchedResultsControllerDelegate {
    func controllerWillChangeContent(_ controller: NSFetchedResultsController<NSFetchRequestResult>) {
        tableView.beginUpdates()
    }
    
    func controller(_ controller: NSFetchedResultsController<NSFetchRequestResult>, didChange sectionInfo: NSFetchedResultsSectionInfo, atSectionIndex sectionIndex: Int, for type: NSFetchedResultsChangeType) {
        switch type {
        case .insert:
            tableView.insertSections(IndexSet(integer: sectionIndex), with: .fade)
        case .delete:
            tableView.deleteSections(IndexSet(integer: sectionIndex), with: .fade)
        default:
            break
        }
    }
    
    func controller(_ controller: NSFetchedResultsController<NSFetchRequestResult>, didChange anObject: Any, at indexPath: IndexPath?, for type: NSFetchedResultsChangeType, newIndexPath: IndexPath?) {
        switch type {
        case .insert:
            tableView.insertRows(at: [newIndexPath!], with: .fade)
        case .delete:
            tableView.deleteRows(at: [indexPath!], with: .fade)
        case .update:
            tableView.reloadRows(at: [indexPath!], with: .fade)
        case .move:
            tableView.moveRow(at: indexPath!, to: newIndexPath!)
        @unknown default:
            print("unknown change")
        }
    }
    
    func controllerDidChangeContent(_ controller: NSFetchedResultsController<NSFetchRequestResult>) {
        tableView.endUpdates()
    }
}

//MARK: Custom transition animation to pop up BTC rate record sorting page
extension RateHistoryTableViewController: UIViewControllerTransitioningDelegate {
    
    func presentationController(forPresented presented: UIViewController, presenting: UIViewController?, source: UIViewController) -> UIPresentationController? {
        return BTCPresentationController(presentedViewController: presented, presenting: presenting)
    }
    
    func animationController(forDismissed dismissed: UIViewController) -> UIViewControllerAnimatedTransitioning? {
        return BTCPopDismissAnimationController()
    }
    
    func animationController(forPresented presented: UIViewController, presenting: UIViewController, source: UIViewController) -> UIViewControllerAnimatedTransitioning? {
        return nil
    }
    
    func interactionControllerForDismissal(using animator: UIViewControllerAnimatedTransitioning) -> UIViewControllerInteractiveTransitioning? {
        if let vc = presentedViewController as? BTCRecordSortViewController, vc.interactionInProgress {
            return vc.interactionController
        } else {
            return nil
        }
    }
}
