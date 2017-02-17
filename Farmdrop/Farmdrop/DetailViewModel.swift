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
    
    private let provider = ReactiveSwiftMoyaProvider<ImageService>()
    private var producer: Producer
    
    var nameText = MutableProperty<String?>(nil)
    var shortDescriptionText = MutableProperty<String?>(nil)
    var descriptionText = MutableProperty<String?>(nil)
    var locationText = MutableProperty<String>("")
    var isViaWholesaler = MutableProperty<Bool?>(nil)
    var wholesalerNameText = MutableProperty<String?>(nil)
    var imagePath = MutableProperty<String?>(nil)
    var image = MutableProperty<UIImage?>(nil)
    
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
        provider.request(.downloadImage(path: path))
            .mapImage()
            .start { event in
                switch event {
                case .value(let response):
                    self.image.value = response
                default:
                    break
                }
        }
        
    }
}
