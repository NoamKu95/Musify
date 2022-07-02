//
//  RecommendedTrackCollectionViewCell.swift
//  Musify
//
//  Created by Noam Kurtzer on 30/06/2022.
//

import UIKit

class RecommendedTrackCollectionViewCell: UICollectionViewCell {
    static let identifier = Constants.Cells.RECOMMENDATION
    
    private var albumCoverImageView: UIImageView = {
       let imageView = UIImageView()
        imageView.image = UIImage(systemName: "photo")
        imageView.layer.masksToBounds = true
        imageView.layer.cornerRadius = 8
        imageView.contentMode = .scaleToFill
        return imageView
    }()
    
    private let trackNameLabel: UILabel = {
        let label = UILabel()
        label.font = .systemFont(ofSize: 18, weight: .regular)
        label.numberOfLines = 0
        return label
    }()
    
    private let artistNameLabel: UILabel = {
        let label = UILabel()
        label.font = .systemFont(ofSize: 15, weight: .thin)
        label.numberOfLines = 0
        return label
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        contentView.backgroundColor = .secondarySystemBackground
        contentView.addSubview(albumCoverImageView)
        contentView.addSubview(trackNameLabel)
        contentView.addSubview(artistNameLabel)
        contentView.clipsToBounds = true
    }
    
    required init?(coder: NSCoder) {
        fatalError()
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        
        albumCoverImageView.frame = CGRect(x: 5,
                                           y: 2,
                                           width: contentView.height-4,
                                           height: contentView.height-4)
        
        trackNameLabel.frame = CGRect(x: albumCoverImageView.right + 10,
                                        y: 0,
                                      width: contentView.width - albumCoverImageView.right - 15,
                                        height: contentView.height / 2)
       
        artistNameLabel.frame = CGRect(x: albumCoverImageView.right + 10,
                                        y: contentView.height / 2,
                                      width: contentView.width - albumCoverImageView.right - 15,
                                        height: contentView.height / 2)
    }
    
    
    override func prepareForReuse() {
        super.prepareForReuse()
        artistNameLabel.text = nil
        trackNameLabel.text = nil
        albumCoverImageView.image = nil
    }
    
    func configure(with viewModel: RecommendedTrackCellViewModel) {
        trackNameLabel.text = viewModel.name
        artistNameLabel.text = viewModel.aristName
        albumCoverImageView.sd_setImage(with: viewModel.artworkURL, completed: nil)
    }
}
