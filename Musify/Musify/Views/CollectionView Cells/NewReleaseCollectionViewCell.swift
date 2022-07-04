//
//  NewReleaseCollectionViewCell.swift
//  Musify
//
//  Created by Noam Kurtzer on 30/06/2022.
//

import UIKit
import SDWebImage

class NewReleaseCollectionViewCell: UICollectionViewCell {
    static let identifier = Constants.Cells.NEW_RELEASES
    
    private var albumCoverImageView: UIImageView = {
       let imageView = UIImageView()
        imageView.image = UIImage(systemName: "photo")
        imageView.layer.cornerRadius = 8
        imageView.layer.masksToBounds = true
        imageView.contentMode = .scaleToFill
        return imageView
    }()
    
    private let albumNameLabel: UILabel = {
        let label = UILabel()
        label.font = .systemFont(ofSize: 20, weight: .semibold)
        label.numberOfLines = 0
        return label
    }()
    
    private let tracksNumberLabel: UILabel = {
        let label = UILabel()
        label.font = .systemFont(ofSize: 18, weight: .thin)
        //label.numberOfLines = 0
        return label
    }()
    
    private let artistNameLabel: UILabel = {
        let label = UILabel()
        label.font = .systemFont(ofSize: 18, weight: .light)
        label.numberOfLines = 0
        return label
    }()
    
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        contentView.backgroundColor = .white //hexStringToUIColor(hex: "#F5F5F5")
        contentView.layer.cornerRadius = 8
        contentView.layer.masksToBounds = true
        contentView.layer.borderWidth = 1
        contentView.layer.borderColor = UIColor.lightGray.cgColor
        
        contentView.addSubview(albumCoverImageView)
        contentView.addSubview(artistNameLabel)
        contentView.addSubview(tracksNumberLabel)
        contentView.addSubview(albumNameLabel)
        contentView.clipsToBounds = true
    }
    
    required init?(coder: NSCoder) {
        fatalError()
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        
        artistNameLabel.sizeToFit()
        albumNameLabel.sizeToFit()
        tracksNumberLabel.sizeToFit()
        
        // Album Image
        let imageSize: CGFloat = contentView.frame.height - 10
        albumCoverImageView.frame = CGRect(x: 5, y: 5, width: imageSize, height: imageSize)
        
        
        // Album Name Label
        let albumLabelSize = albumNameLabel.sizeThatFits(CGSize(width: contentView.width-imageSize-10,
                                                                height: contentView.height-10))
        albumNameLabel.frame = CGRect(x: albumCoverImageView.right + 10,
                                      y: 5,
                                      width: albumLabelSize.width,
                                      height: min(60,albumLabelSize.height))
        
        
        
        // Artist Name Label
        artistNameLabel.frame = CGRect(x: albumCoverImageView.right + 10,
                                       y: albumNameLabel.bottom,
                                       width: contentView.width - albumCoverImageView.right - 10,
                                      height: 30)
        
        // Number of Tracks Label
        tracksNumberLabel.frame = CGRect(x: albumCoverImageView.right + 10,
                                         y: contentView.bottom - 44,
                                         width: tracksNumberLabel.width,
                                         height: 44)
    }
    
    override func prepareForReuse() {
        super.prepareForReuse()
        albumNameLabel.text = nil
        artistNameLabel.text = nil
        tracksNumberLabel.text = nil
        albumCoverImageView.image = nil
    }
    
    func configure(with viewModel: NewReleasesCellViewModel) {
        albumNameLabel.text = viewModel.name
        artistNameLabel.text = viewModel.artistName
        tracksNumberLabel.text = "\(viewModel.numberOfTracks) track\(viewModel.numberOfTracks > 1 ? "s" : "")"
        albumCoverImageView.sd_setImage(with: viewModel.artWorkURL, completed: nil)
    }
}
