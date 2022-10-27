// MovieCatalogTableViewCell.swift
// Copyright © RoadMap. All rights reserved.

import UIKit

/// Ячейка каталога фильмов
final class MovieCatalogTableViewCell: UITableViewCell {
    // MARK: - Constants

    private enum Constants {
        static let placeholderImageName = "filmPosterPlaceholder"
        static let fontExtraBold = "Urbanist-ExtraBold"
        static let fontBold = "Urbanist-Bold"
        static let fontMedium = "Urbanist-Medium"
        static let releaseDateLabelName = "Дата релиза:"
        static let starImageViewName = "star"
        static let stringFormat = "%.1f"
    }

    // MARK: - Private visual Components

    private lazy var posterImageView = makePosterImageView()
    private lazy var titleLabel = makeTitleLabel()
    private lazy var voteAverageStackView = makeStackView()
    private lazy var starImageView = makeStarImageView()
    private lazy var voteAverageLabel = makeBoldLabel()
    private lazy var releaseDateStackView = makeReleaseDateStackView()
    private lazy var releaseDateNameLabel = makeReleaseDateNameLabel()
    private lazy var releaseDateLabel = makeBoldLabel()

    // MARK: - Lifecycle

    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        setupUI()
    }

    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }

    // MARK: - Public methods

    func configure(movie: Movie) {
        titleLabel.text = movie.title
        setPosterImageView(movie: movie)
        setVoteAverageLabel(movie: movie)
        setReleaseDateLabel(movie: movie)
    }

    // MARK: - Private methods

    private func setPosterImageView(movie: Movie) {
        guard let posterPath = movie.posterPath else { return }
        let moviePosterString = Url.urlPoster + posterPath
        guard let url = URL(string: moviePosterString) else { return }
        posterImageView.loadImageWithUrl(url)
    }

    private func setVoteAverageLabel(movie: Movie) {
        let vote = String(format: Constants.stringFormat, movie.voteAverage)
        voteAverageLabel.text = vote
        voteAverageLabel.textColor = movie.voteAverage < 7.0 ? .systemRed : .label
    }

    private func setReleaseDateLabel(movie: Movie) {
        guard let date = DateFormatter.apiDateFormatter.date(from: movie.releaseDate) else { return }
        releaseDateLabel.text = DateFormatter.dateLongFormatter.string(from: date)
    }
}

// MARK: - SetupUI

private extension MovieCatalogTableViewCell {
    func setupUI() {
        contentView.addSubview(posterImageView)
        contentView.addSubview(titleLabel)
        contentView.addSubview(voteAverageStackView)
        voteAverageStackView.addArrangedSubview(starImageView)
        voteAverageStackView.addArrangedSubview(voteAverageLabel)
        contentView.addSubview(releaseDateStackView)
        releaseDateStackView.addArrangedSubview(releaseDateNameLabel)
        releaseDateStackView.addArrangedSubview(releaseDateLabel)

        setUpConstraints()
    }

    func setUpConstraints() {
        [
            posterImageView,
            titleLabel,
            voteAverageStackView,
            releaseDateStackView
        ].forEach {
            $0.translatesAutoresizingMaskIntoConstraints = false
        }

        NSLayoutConstraint.activate([
            posterImageView.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 6),
            posterImageView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 12),
            posterImageView.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -6),
            posterImageView.widthAnchor.constraint(equalToConstant: 114),
            posterImageView.heightAnchor.constraint(equalToConstant: 170),

            titleLabel.topAnchor.constraint(equalTo: posterImageView.topAnchor, constant: 34),
            titleLabel.leadingAnchor.constraint(equalTo: posterImageView.trailingAnchor, constant: 20),
            titleLabel.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -30),

            voteAverageStackView.topAnchor.constraint(equalTo: titleLabel.bottomAnchor, constant: 15),
            voteAverageStackView.leadingAnchor.constraint(equalTo: posterImageView.trailingAnchor, constant: 20),
            voteAverageStackView.heightAnchor.constraint(equalToConstant: 16),

            starImageView.widthAnchor.constraint(equalToConstant: 16),
            starImageView.heightAnchor.constraint(equalToConstant: 16),

            releaseDateStackView.topAnchor.constraint(equalTo: voteAverageStackView.bottomAnchor, constant: 15),
            releaseDateStackView.leadingAnchor.constraint(equalTo: posterImageView.trailingAnchor, constant: 20)
        ])
    }
}

// MARK: - Factory

private extension MovieCatalogTableViewCell {
    func makePosterImageView() -> ImageLoader {
        let imageView = ImageLoader()
        imageView.layer.cornerRadius = 5
        imageView.clipsToBounds = true
        imageView.image = UIImage(named: Constants.placeholderImageName)
        return imageView
    }

    func makeTitleLabel() -> UILabel {
        let label = UILabel()
        label.numberOfLines = 0
        label.font = UIFont(name: Constants.fontExtraBold, size: 18)
        return label
    }

    func makeStackView() -> UIStackView {
        let stackView = UIStackView()
        stackView.spacing = 8
        stackView.axis = .horizontal
        stackView.distribution = .fill
        return stackView
    }

    func makeStarImageView() -> UIImageView {
        let imageView = UIImageView()
        imageView.image = UIImage(named: Constants.starImageViewName)
        return imageView
    }

    func makeBoldLabel() -> UILabel {
        let label = UILabel()
        label.font = UIFont(name: Constants.fontBold, size: 16)
        return label
    }

    func makeReleaseDateStackView() -> UIStackView {
        let stackView = UIStackView()
        stackView.axis = .vertical
        stackView.distribution = .fillEqually
        return stackView
    }

    func makeReleaseDateNameLabel() -> UILabel {
        let label = UILabel()
        label.font = UIFont(name: Constants.fontMedium, size: 14)
        label.textColor = .label
        label.text = Constants.releaseDateLabelName
        return label
    }
}
