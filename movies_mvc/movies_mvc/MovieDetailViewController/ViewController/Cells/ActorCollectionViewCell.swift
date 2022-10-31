// ActorCollectionViewCell.swift
// Copyright © RoadMap. All rights reserved.

import UIKit

/// Ячейка актера
final class ActorCollectionViewCell: UICollectionViewCell {
    // MARK: - Constants

    private enum Constants {
        static let fontMedium = "Urbanist-Medium"
    }

    // MARK: - Private properties

    private lazy var actorPhotoImageView = makeActorPhotoImageView()
    private lazy var actorNameLabel = makeActorNameLabel()

    // MARK: - Inits

    override init(frame: CGRect) {
        super.init(frame: frame)
        setupUI()
    }

    required init?(coder: NSCoder) {
        super.init(coder: coder)
        setupUI()
    }

    // MARK: - Public methods

    func configure(model: Actor) {
        actorNameLabel.text = model.name

        guard let posterPath = model.profilePath else { return }
        let moviePosterString = Api.posterUrlString + posterPath
        guard let url = URL(string: moviePosterString) else { return }
        actorPhotoImageView.loadImageWithUrl(url)
    }
}

// MARK: - SetipUI

private extension ActorCollectionViewCell {
    func setupUI() {
        [
            actorPhotoImageView,
            actorNameLabel
        ].forEach {
            contentView.addSubview($0)
        }

        setUpConstraints()
    }

    func setUpConstraints() {
        [
            actorPhotoImageView,
            actorNameLabel
        ].forEach {
            $0.translatesAutoresizingMaskIntoConstraints = false
        }

        NSLayoutConstraint.activate([
            actorPhotoImageView.widthAnchor.constraint(equalToConstant: 50),
            actorPhotoImageView.heightAnchor.constraint(equalToConstant: 50),
            actorPhotoImageView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 10),
            actorPhotoImageView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -10),
            actorPhotoImageView.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 10),

            actorNameLabel.topAnchor.constraint(equalTo: actorPhotoImageView.bottomAnchor, constant: -5),
            actorNameLabel.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 5),
            actorNameLabel.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -5),
            actorNameLabel.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: 5),
        ])
    }
}

// MARK: - Factory

private extension ActorCollectionViewCell {
    func makeActorPhotoImageView() -> ImageLoader {
        let imageView = ImageLoader()
        imageView.layer.cornerRadius = 25
        imageView.backgroundColor = .systemBackground
        imageView.clipsToBounds = true
        imageView.contentMode = .scaleAspectFill
        return imageView
    }

    func makeActorNameLabel() -> UILabel {
        let label = UILabel()
        label.font = UIFont(name: Constants.fontMedium, size: 12)
        label.numberOfLines = 0
        label.textAlignment = .center
        return label
    }
}
