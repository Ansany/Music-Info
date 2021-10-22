//
//  AlbumCollectionViewCell.swift
//  Evaluation Test (Fora Soft)
//
//  Created by Andrey Alymov on 20.10.2021.
//

import UIKit

class AlbumCollectionViewCell: UICollectionViewCell {

    static let identifier = String(describing: AlbumCollectionViewCell.self)

    @IBOutlet weak var albumImage: UIImageView!
    @IBOutlet weak var albumNameLabel: UILabel!
    @IBOutlet weak var artistNameLabel: UILabel!
    @IBOutlet weak var numberOfTracksLabel: UILabel!
    @IBOutlet weak var dateOfRelease: UILabel!
    
}

