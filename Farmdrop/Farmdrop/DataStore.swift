//
//  DataStore.swift
//  Farmdrop
//
//  Created by James Beattie on 17/02/2017.
//  Copyright © 2017 James Beattie. All rights reserved.
//
//  This class stores the producer objects to a plist file in the document directory. 
//
//  CoreData seemed overkill for this solution as the number of producers + their size is not a 
//  lot of data and there are effectively no relationships to store.
//

import Foundation
import ReactiveSwift
import Result


class DataStore {
    
    var dateStored: Date?
    
    var downloadedAllData = false
    
    // Used to decide whether the stored data needs updating.
    var isUpToDate: Bool {
        guard let dateStored = dateStored else { return false }
        return downloadedAllData && (Date().timeIntervalSince(dateStored) < Time.DayInSeconds)
    }
    
    static var sharedInstance = DataStore()
    
    var savedProducers = MutableProperty<[Producer]>([])
    
    init() {
        preparePlistForUse()
    }
    
    func loadProducers() -> Result<AnyObject?, NSError> {
        guard let destination = destPath else { return Result.failure(generateError(code: Errors.NoDest.code, domain: Errors.NoDest.domain)) }
        guard let savedData = FileManager.default.contents(atPath: destination.path) else { return Result.failure(generateError(code: Errors.NoFile.code, domain: Errors.NoFile.domain))}
        
        if let si = NSKeyedUnarchiver.unarchiveObject(with: savedData) as? [Producer] {
            savedProducers.value = si
            
            return Result.success(nil)
        }
        return Result.failure(generateError(code: Errors.CNUnarc.code, domain: Errors.CNUnarc.domain))
    }
    
    func saveProducers() -> Result<AnyObject?, NSError> {
        guard let destination = destPath else { return Result.failure(generateError(code: Errors.NoDest.code, domain: Errors.NoDest.domain)) }
        let si = NSKeyedArchiver.archiveRootObject(savedProducers.value, toFile: destination.path)
        switch si {
        case true:
            dateStored = Date()
            return Result.success(nil)
        case false:
            downloadedAllData = false
            return Result.failure(generateError(code: Errors.CNSave.code, domain: Errors.CNSave.domain))
        }
    }
    
    func preparePlistForUse() {
        let fm = FileManager.default
        guard let source = sourcePath else { return }
        guard let destination = destPath else { return }
        
        guard let _ = NSArray(contentsOf: source) else { return }
        
        if !fm.fileExists(atPath: destination.path) {
            do {
                try fm.copyItem(atPath: source.path, toPath: destination.path)
            } catch let error as NSError {
                print("Unable to copy file. ERROR: \(error.localizedDescription)")
                return
            }
        }
    }
    
    var sourcePath: URL? {
        guard let path = Bundle.main.url(forResource: FileNames.ProducersPlist, withExtension: ".plist") else { return .none }
        return path
    }
    
    var destPath: URL? {
        guard sourcePath != .none else { return .none }
        let dirPath = NSSearchPathForDirectoriesInDomains(.documentDirectory, .userDomainMask, true)[0]
        let dir = NSURL(fileURLWithPath: dirPath)
        return dir.appendingPathComponent("\(FileNames.ProducersPlist).plist")
        
    }
    
    func synchroniseProducers(producers: [Producer], completed: Bool) {
        var tempProducers = savedProducers.value
        
        let producersToDelete = savedProducers.value.filter{ !producers.contains($0) }
        
        for producerToDelete in producersToDelete {
            _ = tempProducers.removeObject(object: producerToDelete)
        }
        
        let producersToAdd = producers.filter { !tempProducers.contains($0) }
        
        tempProducers.append(contentsOf: producersToAdd)
        
        let producersToAmend = producers.filter { prod in
            if let index = tempProducers.index(of: prod) {
                let savedProd = tempProducers[index]
                return !(prod === savedProd)
            }
            return false
        }
        
        for producerToAmend in producersToAmend {
            if let index = tempProducers.index(of: producerToAmend) {
                tempProducers[index] = producerToAmend
            }
        }
        
        downloadedAllData = completed
        savedProducers.value = tempProducers
        
    }
    
    func generateError(code: Int, domain: String) -> NSError {
        return NSError(domain: domain, code: code, userInfo: nil)
    }
}
