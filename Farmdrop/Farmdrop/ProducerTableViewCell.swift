//
//  ProducerTableViewCell.swift
//  Farmdrop
//
//  Created by James Beattie on 15/02/2017.
//  Copyright © 2017 James Beattie. All rights reserved.
//

import UIKit
import ReactiveSwift

class ProducerTableViewCell: UITableViewCell {
    
    @IBOutlet weak var producerName: UILabel!
    @IBOutlet weak var producerDescription: UILabel!
    @IBOutlet weak var producerImage: UIImageView!
    @IBOutlet weak var activityIndicator: UIActivityIndicatorView!
    
    var viewModel: DetailViewModel!
    
    func setupViewModel(viewModel: DetailViewModel) {
        self.viewModel = viewModel
        producerName.reactive.text <~ viewModel.nameText.producer.take(until: self.reactive.prepareForReuse)
        producerDescription.reactive.text <~ viewModel.shortDescriptionText.producer.take(until: self.reactive.prepareForReuse)
        producerImage.reactive.image <~ viewModel.image.producer.take(until: self.reactive.prepareForReuse)
        viewModel.fetchImage()
        
        viewModel.downloadInProgress.producer.start { [weak self] event in
            switch event {
            case .value(let val):
                if val {
                    self?.activityIndicator.startAnimating()
                } else {
                    self?.activityIndicator.stopAnimating()
                }
            default:
                break
            }
        }
    }

}
