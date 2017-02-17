//
//  ProducerViewModelTest.swift
//  Farmdrop
//
//  Created by James Beattie on 15/02/2017.
//  Copyright © 2017 James Beattie. All rights reserved.
//

import XCTest
import JASON
import ReactiveSwift
import Moya
@testable import Farmdrop

class ProducerViewModelTest: XCTestCase {
    
    override func setUp() {
        super.setUp()
        // Put setup code here. This method is called before the invocation of each test method in the class.
        
    }
    
    override func tearDown() {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
        super.tearDown()
    }
    
    func testDetailViewModel() {
        // This is an example of a functional test case.
        // Use XCTAssert and related functions to verify your tests produce the correct results.
        
        guard let json = loadJson(file: "producerJson") else  { return }
        
        guard let producer = try? Producer(json) else { return }
        
        let detailViewModel = DetailViewModel(producer: producer)
        XCTAssertEqual(detailViewModel.nameText.value, "Purton House Organics")
        XCTAssertEqual(detailViewModel.shortDescriptionText.value, "Mother and daughter-­run Purton House Organics supplies much of our fruit and vegetables, as well as organic beef, pork and eggs")
        XCTAssertEqual(detailViewModel.descriptionText.value, "Description Text")
        XCTAssertEqual(detailViewModel.locationText.value, "Purton, Wiltshire")
        XCTAssertEqual(detailViewModel.isViaWholesaler.value, true)
        XCTAssertEqual(detailViewModel.wholesalerNameText.value, "Purton House Organics")
        XCTAssertEqual(detailViewModel.imagePath.value, "33ceef48bff5238c88ccda3eecd3d04d3f13d618fcfb59815b0cef31350c65d1/purton_rally_540by415.jpg")
        
    }
    
    func testProducerNoShortDescription() {
        // This is an example of a functional test case.
        // Use XCTAssert and related functions to verify your tests produce the correct results.
        
        guard let json = loadJson(file: "producerNoShortDescription") else  { return }
        
        guard let producer = try? Producer(json) else { return }
        
        let detailViewModel = DetailViewModel(producer: producer)
        XCTAssertEqual(detailViewModel.nameText.value, "Purton House Organics")
        XCTAssertEqual(detailViewModel.shortDescriptionText.value, "Only a longer description")
        XCTAssertEqual(detailViewModel.descriptionText.value, "Only a longer description")
        XCTAssertEqual(detailViewModel.locationText.value, "Purton, Wiltshire")
        XCTAssertEqual(detailViewModel.isViaWholesaler.value, true)
        XCTAssertEqual(detailViewModel.wholesalerNameText.value, "Purton House Organics")
        XCTAssertEqual(detailViewModel.imagePath.value, "33ceef48bff5238c88ccda3eecd3d04d3f13d618fcfb59815b0cef31350c65d1/purton_rally_540by415.jpg")
        
    }
    
    func testProducerNoDescription() {
        // This is an example of a functional test case.
        // Use XCTAssert and related functions to verify your tests produce the correct results.
        
        guard let json = loadJson(file: "producerNoDescription") else  { return }
        
        guard let producer = try? Producer(json) else { return }
        
        let detailViewModel = DetailViewModel(producer: producer)
        XCTAssertEqual(detailViewModel.nameText.value, "Purton House Organics")
        XCTAssertEqual(detailViewModel.shortDescriptionText.value, "Eh, that's a short one")
        XCTAssertEqual(detailViewModel.descriptionText.value, "Eh, that's a short one")
        XCTAssertEqual(detailViewModel.locationText.value, "Purton, Wiltshire")
        XCTAssertEqual(detailViewModel.isViaWholesaler.value, true)
        XCTAssertEqual(detailViewModel.wholesalerNameText.value, "Purton House Organics")
        XCTAssertEqual(detailViewModel.imagePath.value, "33ceef48bff5238c88ccda3eecd3d04d3f13d618fcfb59815b0cef31350c65d1/purton_rally_540by415.jpg")
        
    }
    
    func testPerformanceExample() {
        // This is an example of a performance test case.
        self.measure {
            // Put the code you want to measure the time of here.
        }
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
