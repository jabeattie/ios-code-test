//
//  DataStoreTest.swift
//  Farmdrop
//
//  Created by James Beattie on 17/02/2017.
//  Copyright © 2017 James Beattie. All rights reserved.
//

import XCTest
import JASON
import Result
@testable import Farmdrop

class DataStoreTest: XCTestCase {
    
    override func setUp() {
        super.setUp()
    }
    
    override func tearDown() {
        super.tearDown()
    }
    
    func testExample() {
        
        guard let json = loadJson(file: "producerJson") else  { return }
        
        guard let producer = try? Producer(json) else { return }
        
        let store = DataStore.sharedInstance
        
        store.synchroniseProducers(producers: [producer], completed: false)
        
        XCTAssertEqual(store.savedProducers.value, [producer])
        
        store.synchroniseProducers(producers: [producer], completed: true)
        
        store.savedProducers.value = []
        
        let result = store.loadProducers()
        
        XCTAssertNotNil(result)
    }
    
    func loadJson(file: String) -> JSON? {
        guard let pathString = Bundle(for: type(of: self)).path(forResource: file, ofType: "json") else {
            fatalError("\(file + ".json") not found")
        }
        
        guard let jsonString = try? NSString(contentsOfFile: pathString, encoding: String.Encoding.utf8.rawValue) else {
            fatalError("Unable to convert \(file + ".json")  to String")
        }
        
        print("The JSON string is: \(jsonString)")
        
        guard let jsonData = jsonString.data(using: String.Encoding.utf8.rawValue) else {
            fatalError("Unable to convert \(file + ".json")  to NSData")
        }
        
        guard let jsonDictionary = try? JSONSerialization.jsonObject(with: jsonData, options: []) as? [String:AnyObject] else {
            fatalError("Unable to convert \(file + ".json")  to JSON dictionary")
        }
        
        return JSON(jsonDictionary)
    }
    
}
