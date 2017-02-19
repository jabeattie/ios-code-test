//
//  ProducerViewModel.swift
//  Farmdrop
//
//  Created by James Beattie on 15/02/2017.
//  Copyright © 2017 James Beattie. All rights reserved.
//

import Foundation
import Moya
import ReactiveSwift
import Result

class DetailViewModel {
    
    private var producer: Producer
    
    var nameText = MutableProperty<String?>(nil)
    var shortDescriptionText = MutableProperty<String?>(nil)
    var descriptionText = MutableProperty<String?>(nil)
    var locationText = MutableProperty<String>("")
    var isViaWholesaler = MutableProperty<Bool?>(nil)
    var wholesalerNameText = MutableProperty<String?>(nil)
    var imagePath = MutableProperty<String?>(nil)
    var image = MutableProperty<UIImage?>(nil)
    
    var downloadInProgress = MutableProperty<Bool>(false)
    var downloadProgress = MutableProperty<Double>(0)
    
    init(producer: Producer) {
        self.producer = producer
        nameText <~ producer.name
        locationText <~ producer.location
        shortDescriptionText <~ producer.shortDescription.producer.map({ $0 == nil || $0!.removeWhitespace().isEmpty ? producer.longDescription.value : $0 })
        descriptionText <~ producer.longDescription.producer.map({ $0 == nil || $0!.removeWhitespace().isEmpty ? producer.shortDescription.value : $0 })
        isViaWholesaler <~ producer.viaWholesaler
        wholesalerNameText <~ producer.wholesalerName
        imagePath <~ producer.images.producer.map({ $0?.first?.path.value })
    }
    
    func fetchImage() {
        guard let path = imagePath.value else { return }
        guard image.value == nil else { return }
        DispatchQueue.global(qos: DispatchQoS.QoSClass.background).async { [weak self] _ in
            
            if let image = self?.loadImage(imagePath: path) {
                self?.image.value = image
            } else {
                self?.downloadImage(imagePath: path)
            }
        }
    }
    
    func loadImage(imagePath: String) -> UIImage? {
        return DataStore.sharedInstance.getImageFromDocumentDirectory(imageName: imagePath)
    }
    
    func downloadImage(imagePath: String) {
        let networkActivityPlugin = NetworkActivityPlugin(networkActivityClosure: { [weak self] (changeType) in
            switch changeType {
            case .began:
                self?.downloadInProgress.value = true
            case .ended:
                self?.downloadInProgress.value = false
            }
        })
        
        let provider = ReactiveSwiftMoyaProvider<ImageService>(plugins: [networkActivityPlugin])
        
        provider.request(.downloadImage(path: imagePath)).mapImage().start({ [weak self] (event) in
            switch event {
            case .value(let response):
                DataStore.sharedInstance.saveImageToDocumentDirectory(imageName: imagePath, image: response)
                self?.image.value = response
            default:
                break
            }
        })
    }
}
