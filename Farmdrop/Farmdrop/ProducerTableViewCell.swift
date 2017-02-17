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
    
    var viewModel: DetailViewModel! {
        didSet {
            producerName.reactive.text <~ viewModel.nameText
            producerDescription.reactive.text <~ viewModel.shortDescriptionText
        }
    }

}
