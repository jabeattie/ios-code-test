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
        guard let destination = destPath(filePath: "\(FileNames.ProducersPlist).plist") else { return Result.failure(generateError(code: Errors.NoDest.code, domain: Errors.NoDest.domain)) }
        guard let savedData = FileManager.default.contents(atPath: destination.path) else { return Result.failure(generateError(code: Errors.NoFile.code, domain: Errors.NoFile.domain))}
        
        if let si = NSKeyedUnarchiver.unarchiveObject(with: savedData) as? [Producer] {
            savedProducers.value = si
            
            return Result.success(nil)
        }
        return Result.failure(generateError(code: Errors.CNUnarc.code, domain: Errors.CNUnarc.domain))
    }
    
    func saveProducers() -> Result<AnyObject?, NSError> {
        guard let destination = destPath(filePath: "\(FileNames.ProducersPlist).plist") else { return Result.failure(generateError(code: Errors.NoDest.code, domain: Errors.NoDest.domain)) }
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
        guard sourcePath != .none else { return }
        guard let destination = destPath(filePath: "\(FileNames.ProducersPlist).plist") else { return }
        
        guard let _ = NSArray(contentsOf: source) else { return }
        
        if !fm.fileExists(atPath: destination.path) {
            do {
                try fm.copyItem(atPath: source.path, toPath: destination.path)
            } catch let error as NSError {
                print("Unable to copy file. ERROR: \(error.localizedDescription)")
                return
            }
        }
        
        let dirPath = NSSearchPathForDirectoriesInDomains(.cachesDirectory, .userDomainMask, true)[0]
        
        var isDir : ObjCBool = false
        if !fm.fileExists(atPath: dirPath, isDirectory: &isDir) {
            do {
                try fm.createDirectory(atPath: dirPath, withIntermediateDirectories: false, attributes: nil)
            } catch let error as NSError {
                print("Unable to create cache directory. ERROR: \(error.localizedDescription)")
            }
        }
    }
    
    var sourcePath: URL? {
        guard let path = Bundle.main.url(forResource: FileNames.ProducersPlist, withExtension: ".plist") else { return .none }
        return path
    }
    
    func destPath(filePath: String) -> URL? {
        let dirPath = NSSearchPathForDirectoriesInDomains(.cachesDirectory, .userDomainMask, true)[0]
        let dir = URL(fileURLWithPath: dirPath)
        return dir.appendingPathComponent(filePath)
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
    
    func saveImageToDocumentDirectory(imageName: String, image: UIImage){
        let imageName = imageName.replacingOccurrences(of: "/", with: "")
        guard let imagePath = destPath(filePath: imageName) else { return }
        let fileManager = FileManager.default
        guard let imageData = UIImageJPEGRepresentation(image, 0.7) else { return }
        do {
            try imageData.write(to: imagePath, options: Data.WritingOptions.atomicWrite)
        } catch let error as NSError {
            print(error.localizedDescription)
        }
    }
    
    func getImageFromDocumentDirectory(imageName: String) -> UIImage? {
        let imageName = imageName.replacingOccurrences(of: "/", with: "")
        guard let imagePath = destPath(filePath: imageName) else { return nil }
        let fileManager = FileManager.default
        if fileManager.fileExists(atPath: imagePath.path) {
            return UIImage(contentsOfFile: imagePath.path)
        }
        return nil
    }
}
