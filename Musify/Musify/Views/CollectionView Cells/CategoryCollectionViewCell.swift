//
//  GenreCollectionViewCell.swift
//  Musify
//
//  Created by Noam Kurtzer on 04/07/2022.
//

import UIKit
import SDWebImage

class CategoryCollectionViewCell: UICollectionViewCell {
    static let identifier = "GenreCollectionViewCell"
    
    private let colors: [UIColor] = [
        .systemPink,
        .systemBlue,
        .systemMint,
        .systemTeal,
        .systemCyan,
        .systemPurple,
        .systemGreen,
        .systemYellow
    ]
    
    private let imageView: UIImageView = {
        let image = UIImageView()
        image.contentMode = .scaleAspectFit
        image.tintColor = .darkGray
        image.image = UIImage(systemName: "music.quarternote.3", withConfiguration: UIImage.SymbolConfiguration(pointSize: 50, weight: .regular))
        return image
    }()
    
    private let label: UILabel = {
      let label = UILabel()
        return label
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        contentView.layer.cornerRadius = 8
        contentView.layer.masksToBounds = true
        contentView.addSubview(imageView)
        contentView.addSubview(label)
    }
    
    required init?(coder: NSCoder) {
        fatalError()
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        
        label.frame = CGRect(x: 10, y: contentView.height/2, width: contentView.width-20, height: contentView.height/2)
        imageView.frame = CGRect(x: contentView.width/2, y: 10, width: contentView.width/2, height: contentView.height/2)
    }
    
    override func prepareForReuse() {
        super.prepareForReuse()
        label.text = nil
        imageView.image = UIImage(systemName: "music.quarternote.3", withConfiguration: UIImage.SymbolConfiguration(pointSize: 50, weight: .regular))
    }
    
    func configure(with viewModel: CategoryCollectionViewCellViewModel) {
        label.text = viewModel.title
        imageView.sd_setImage(with: viewModel.artworkURL, completed: nil)
        contentView.backgroundColor = colors.randomElement()
    }
}
