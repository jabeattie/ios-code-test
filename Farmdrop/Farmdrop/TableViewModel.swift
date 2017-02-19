//
//  ProducersViewModel.swift
//  Farmdrop
//
//  Created by James Beattie on 15/02/2017.
//  Copyright © 2017 James Beattie. All rights reserved.
//

import Foundation
import Moya
import ReactiveSwift
import Changeset
import Result

class TableViewModel {
    
    let provider = ReactiveSwiftMoyaProvider<NetworkService>()
    let producerChangeset = MutableProperty<Any>([Edit<Producer>]())
    
    private var producers = MutableProperty<[Producer]>([])
    
    private var filteredProducers: [Producer] = [] {
        didSet {
            producerChangeset.value = Changeset.edits(from: oldValue, to: filteredProducers)
        }
    }
    
    private var previousFiltered: [Producer] = []
    
    private var page = 1
    
    private var canFetchMoreProducers = false
    
    var searchString = MutableProperty<String?>(nil)
    
    init() {
        
        searchString.producer.map({ [unowned self] (string) -> [Producer] in
            return string != nil && string!.characters.count > 0 ? self.producers.value.filter({ $0.name.value.contains(string!) }) : self.producers.value
        }).start({ [unowned self] (event) in
            if let val = event.value {
                self.filteredProducers = val
            }
        })
        producers.producer.start { [unowned self] (event) in
            if let val = event.value {
                self.filteredProducers = self.searchString.value != nil && self.searchString.value!.characters.count > 0 ? val.filter({ $0.name.value.contains(self.searchString.value!) }) : val
            }
        }
        
        DataStore.sharedInstance.savedProducers.producer.start { [unowned self] (event) in
            if let val = event.value {
                self.filteredProducers = self.searchString.value != nil && self.searchString.value!.characters.count > 0 ? val.filter({ $0.name.value.contains(self.searchString.value!) }) : val
            }
        }
        
        _ = DataStore.sharedInstance.loadProducers()
        if !DataStore.sharedInstance.isUpToDate {
            fetchProducers(atPage: page)
        }
        
        NotificationCenter.default.addObserver(self, selector: #selector(synchroniseProducers), name: Notification.Name.UIApplicationWillResignActive, object: nil)
    }
    
    
    // Tells the datastore to save the producers if the app is resigning active
    @objc func synchroniseProducers(notification: NSNotification) {
        DataStore.sharedInstance.synchroniseProducers(producers: self.producers.value, completed: !canFetchMoreProducers)
    }
    
    func fetchProducers(atPage page: Int) {
        canFetchMoreProducers = false
        DispatchQueue.global(qos: DispatchQoS.QoSClass.userInitiated).async { [unowned self] in
            self.provider
                .request(.showPagedProducers(page: page, numberOfProducers: Fetching.Limit))
                .observe(on: QueueScheduler.init(qos: DispatchQoS.userInteractive, name: "UserInteractive", targeting: DispatchQueue.global(qos: .userInteractive)))
                .mapArray(type: Producer.self, keyPath: ["response"])
                .start { [unowned self] event in
                    switch event {
                    case .value(let producers):
                        self.producers.value.append(contentsOf: producers)
                        if (producers.count > 0) {
                            self.canFetchMoreProducers = true
                        } else {
                            DataStore.sharedInstance.synchroniseProducers(producers: self.producers.value, completed: true)
                        }
                        
                    case let .failed(error):
                        self.canFetchMoreProducers = true
                        print(error)
                    default:
                        break
                    }
            }
        }
        
    }
    
    func getProducersCount() -> Int {
        return filteredProducers.count
    }
    
    func createDetailViewModel(forIndex index: Int) -> DetailViewModel {
        return DetailViewModel(producer: filteredProducers[index])
    }
    
    func fetchMoreProducers() {
        guard canFetchMoreProducers else { return }
        page += 1
        fetchProducers(atPage: page)
    }
    
    func search(searchString: String) {
        guard searchString.characters.count > 0 else { self.searchString.value = nil; return }
        self.searchString.value = searchString
    }
    
}
