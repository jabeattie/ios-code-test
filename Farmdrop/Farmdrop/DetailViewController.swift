//
//  DetailViewController.swift
//  Farmdrop
//
//  Created by James Beattie on 15/02/2017.
//  Copyright © 2017 James Beattie. All rights reserved.
//

import UIKit
import Down
import ReactiveCocoa
import ReactiveSwift

class DetailViewController: UIViewController {
    
    @IBOutlet weak var scrollView: UIScrollView!
    @IBOutlet var producerImage: UIImageView!
    @IBOutlet var producerLocation: UILabel!
    @IBOutlet var producerDescription: UITextView!
    
    @IBOutlet weak var producerImageHeightConstraint: NSLayoutConstraint!
    
    @IBOutlet weak var producerImageTopConstraint: NSLayoutConstraint!
    var viewModel: DetailViewModel!
    fileprivate var imageHeight: CGFloat = 0

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        
        title = viewModel.nameText.value
        scrollView.delegate = self
        
        producerLocation.reactive.text <~ viewModel.locationText
        
        producerDescription.attributedText = try! Down(markdownString: viewModel.descriptionText.value!).toAttributedString()
        producerDescription.increaseFontSizeBy(pointSize: 6)
        producerDescription.changeFontFamilyToSystem()
        
        viewModel.fetchImage()
        
        producerImage.reactive.image <~ viewModel.image
        
        // When the viewModel.image updates, this recalculates the new height according to its aspect ratio (But limits it to 500)
        viewModel.image.producer.map({ (image) -> CGFloat in
            guard let image = image else { return 500 }
            let viewWidth = self.view.bounds.size.width
            let newHeight = (image.size.height / image.size.width) * viewWidth
            return newHeight < 500 ? newHeight : 500
        }).start { [unowned self] (event) in
            if let val = event.value {
                self.producerImageHeightConstraint.constant = val
                self.imageHeight = val
                self.view.layoutIfNeeded()
            }
        }
        
    }

}

extension DetailViewController: UIScrollViewDelegate {
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        //  Due to an issue with the scrollview and the navigationItem, everything here is offset by 64.
        // Performs the expanding image in the view.
        if (scrollView.contentOffset.y < -64) {
            let y = scrollView.contentOffset.y + 64
            
            producerImageTopConstraint.constant = y
            producerImageHeightConstraint.constant = imageHeight + (-y)
        } else {
            producerImageTopConstraint.constant = 0
            producerImageHeightConstraint.constant = imageHeight
        }
        view.layoutIfNeeded()
    }
}
