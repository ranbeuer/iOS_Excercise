//
//  LoadingMoreCollectionViewCell.swift
//  iOS_Exercise
//
//  Created by Leonardo Cid on 4/10/19.
//  Copyright © 2019 iTexico. All rights reserved.
//

import UIKit

class LoadingMoreCollectionViewCell : UICollectionViewCell {
    static let identifier = "loadingCell"
    @IBOutlet weak var loadingView : UIActivityIndicatorView!
    
    override func willMove(toSuperview newSuperview: UIView?) {
        if (newSuperview == nil) {
            loadingView.stopAnimating()
        }
    }
}
