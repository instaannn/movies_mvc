// MovieDetailViewController.swift
// Copyright © RoadMap. All rights reserved.

import SafariServices
import UIKit

/// Экран детального описания фильма
final class MovieDetailViewController: UIViewController {
    // MARK: - Constants

    private enum Constants {
        static let fontExtraBold = "Urbanist-ExtraBold"
        static let fontBold = "Urbanist-Bold"
        static let fontMedium = "Urbanist-Medium"
        static let releaseDateLabelName = "Дата релиза:"
        static let starImageViewName = "star"
        static let cellId = "Cell"
        static let shareButtonImageName = "square.and.arrow.up"
        static let alertTitle = "Ой!"
        static let alertMessage = "Трейлера пока нет"
        static let watchTrailerButtonTitle = "Смотреть трейлер"
        static let goToImdbButtonImageName = "chevron.right"
        static let gradientImageViewName = "gradient"
        static let stringFormat = "%.1f"
        static let genresLabelText = "Жанры:"
    }

    // MARK: - Visual Components

    private lazy var backgroundImageView = makeBackgroundImageView()
    private lazy var gradientImageView = makeGradientImageView()
    private lazy var posterImageView = makePosterImageView()
    private lazy var titleLabel = makeTitleLabel()
    private lazy var runtimeLabel = makeBoldLabel(size: 18)
    private lazy var voteAverageStackView = makeStackView()
    private lazy var starImageView = makeStarImageView()
    private lazy var voteAverageLabel = makeBoldLabel(size: 18)
    private lazy var goToImdbButton = makeGoToImdbButton()
    private lazy var releaseDateLabel = makeBoldLabel(size: 18)
    private lazy var watchTrailerButton = makeWatchTrailerButton()
    private lazy var genresLabel = makeBoldLabel(size: 16)
    private lazy var overviewLabel = makeOverviewLabel()
    private lazy var collectionView = makeCollectionView()
    private lazy var collectionViewFlowLayout = makeCollectionViewFlowLayout()

    // MARK: - Public Properties

    var movieId = 0

    // MARK: - Private properties

    private var movieDetail: MovieDetail?
    private var trailers: Videos?
    private var networkService = NetworkService()
    private var actors: Actors?
    private var shareUrlImdb = ""

    // MARK: - Lifecycle

    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
        setupBinding()
        setupNavigationController()
        view.backgroundColor = .systemBackground
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        navigationController?.setNavigationBarHidden(false, animated: true)
    }

    // MARK: - Private Methods

    private func loadData() {
        networkService.fetchDetails(for: movieId, complition: { [weak self] item in
            guard let self = self else { return }
            DispatchQueue.main.async {
                switch item {
                case let .success(data):
                    self.movieDetail = data
                    self.setUI(movieDetail: self.movieDetail)
                case let .failure(error):
                    print(error)
                }
            }
        })
    }

    private func loadTrailers() {
        networkService.fetchTrailer(for: movieId, complition: { [weak self] item in
            guard let self = self else { return }
            DispatchQueue.main.async {
                switch item {
                case let .success(data):
                    self.trailers = data
                case let .failure(error):
                    print(error)
                }
            }
        })
    }

    private func loadCast() {
        networkService.fetchCast(for: movieId, complition: { [weak self] item in
            guard let self = self else { return }
            DispatchQueue.main.async {
                switch item {
                case let .success(data):
                    self.actors = data
                    self.collectionView.reloadData()
                case let .failure(error):
                    print(error)
                }
            }
        })
    }

    private func setupNavigationController() {
        let navigationBarAppearace = UINavigationBar.appearance()
        navigationBarAppearace.tintColor = .systemRed
        navigationItem.rightBarButtonItem = UIBarButtonItem(
            image: UIImage(systemName: Constants.shareButtonImageName),
            style: .plain,
            target: self,
            action: #selector(shareButtonAction)
        )
    }

    private func setUI(movieDetail: MovieDetail?) {
        guard let movieDetail = movieDetail else { return }
        setPostersImageView(movieDetail: movieDetail)
        setPosterImageView(movieDetail: movieDetail)
        titleLabel.text = movieDetail.title
        setTimeLabel(movieDetail: movieDetail)
        setVoteAverageLabel(movieDetail: movieDetail)
        shareUrlImdb = "\(Api.imdbUrlString)\(movieDetail.imdbId ?? "")"
        overviewLabel.text = movieDetail.overview
    }

    private func setPostersImageView(movieDetail: MovieDetail) {
        let moviePosterString = Api.posterUrlString + movieDetail.backdropPath
        guard let url = URL(string: moviePosterString) else { return }
        backgroundImageView.loadImageWithUrl(url)
    }

    private func setPosterImageView(movieDetail: MovieDetail) {
        guard let posterPath = movieDetail.posterPath else { return }
        let moviePosterString = Api.posterUrlString + posterPath
        guard let url = URL(string: moviePosterString) else { return }
        posterImageView.loadImageWithUrl(url)
    }

    private func setTimeLabel(movieDetail: MovieDetail) {
        guard let time = movieDetail.runtime else { return }
        runtimeLabel.text = "\(time / 60)ч \(time % 60)мин"
    }

    private func setVoteAverageLabel(movieDetail: MovieDetail) {
        let vote = String(format: Constants.stringFormat, movieDetail.voteAverage)
        voteAverageLabel.text = vote
        voteAverageLabel.textColor = movieDetail.voteAverage < 7.0 ? .systemRed : .label
    }

    private func setGenresLabel(movieDetail: MovieDetail) {
        var genres: [String] = []
        for index in movieDetail.genres {
            genres.append(index.name)
        }
        genresLabel.text = "\(Constants.genresLabelText) \(genres.joined(separator: ", "))"
    }

    @objc private func goToImdbButtonAction() {
        guard let movieDetail = movieDetail?.imdbId,
              let url = URL(string: "\(Api.imdbUrlString)\(movieDetail)") else { return }
        let vc = SFSafariViewController(url: url)
        present(vc, animated: true, completion: .none)
    }

    @objc private func watchTrailerButtonAction() {
        guard let key = trailers?.videos.first?.key,
              let url = URL(string: "\(Api.youtubeUrlString)\(key)")
        else {
            showAlert(title: Constants.alertTitle, message: Constants.alertMessage)
            return
        }
        let safariViewController = SFSafariViewController(url: url)
        present(safariViewController, animated: true, completion: .none)
    }

    @objc private func shareButtonAction() {
        let activityViewController = UIActivityViewController(
            activityItems: [movieDetail?.title ?? "", shareUrlImdb],
            applicationActivities: nil
        )
        present(activityViewController, animated: true)
    }
}

// MARK: - UICollectionViewDataSource

extension MovieDetailViewController: UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        actors?.actors.count ?? 0
    }

    func collectionView(
        _ collectionView: UICollectionView,
        cellForItemAt indexPath: IndexPath
    ) -> UICollectionViewCell {
        guard let cell = collectionView
            .dequeueReusableCell(withReuseIdentifier: Constants.cellId, for: indexPath) as? ActorCollectionViewCell
        else { return UICollectionViewCell() }
        guard let actor = actors?.actors[indexPath.row] else { return UICollectionViewCell() }
        cell.configure(model: actor)
        return cell
    }
}

// MARK: - SetupUI

private extension MovieDetailViewController {
    func setupUI() {
        view.addSubview(backgroundImageView)
        backgroundImageView.addSubview(gradientImageView)

        [
            posterImageView,
            titleLabel,
            runtimeLabel,
            voteAverageStackView,
            goToImdbButton,
            watchTrailerButton,
            genresLabel,
            overviewLabel,
            collectionView
        ].forEach {
            view.addSubview($0)
        }

        voteAverageStackView.addArrangedSubview(starImageView)
        voteAverageStackView.addArrangedSubview(voteAverageLabel)

        setUpConstraints()
    }

    func setupBinding() {
        loadData()
        loadTrailers()
        loadCast()
    }

    func setUpConstraints() {
        [
            backgroundImageView,
            gradientImageView,
            posterImageView,
            titleLabel,
            runtimeLabel,
            voteAverageStackView,
            goToImdbButton,
            watchTrailerButton,
            genresLabel,
            overviewLabel,
            collectionView
        ].forEach {
            $0.translatesAutoresizingMaskIntoConstraints = false
        }

        NSLayoutConstraint.activate([
            backgroundImageView.topAnchor.constraint(equalTo: view.topAnchor),
            backgroundImageView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            backgroundImageView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            backgroundImageView.widthAnchor.constraint(equalToConstant: 280),

            gradientImageView.leadingAnchor.constraint(equalTo: backgroundImageView.leadingAnchor),
            gradientImageView.trailingAnchor.constraint(equalTo: backgroundImageView.trailingAnchor),
            gradientImageView.bottomAnchor.constraint(equalTo: backgroundImageView.bottomAnchor, constant: 3),
            gradientImageView.widthAnchor.constraint(equalToConstant: 283),

            posterImageView.widthAnchor.constraint(equalToConstant: 140),
            posterImageView.heightAnchor.constraint(equalToConstant: 170),
            posterImageView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -20),
            posterImageView.bottomAnchor.constraint(equalTo: backgroundImageView.bottomAnchor, constant: 56),

            titleLabel.topAnchor.constraint(equalTo: posterImageView.topAnchor),
            titleLabel.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 20),
            titleLabel.trailingAnchor.constraint(equalTo: posterImageView.leadingAnchor, constant: -20),

            runtimeLabel.topAnchor.constraint(equalTo: titleLabel.bottomAnchor, constant: 10),
            runtimeLabel.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 20),
            runtimeLabel.trailingAnchor.constraint(equalTo: posterImageView.leadingAnchor, constant: -20),

            starImageView.widthAnchor.constraint(equalToConstant: 16),
            starImageView.heightAnchor.constraint(equalToConstant: 16),

            voteAverageStackView.topAnchor.constraint(equalTo: runtimeLabel.bottomAnchor, constant: 10),
            voteAverageStackView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 20),
            voteAverageStackView.heightAnchor.constraint(equalToConstant: 16),

            goToImdbButton.centerYAnchor.constraint(equalTo: voteAverageStackView.centerYAnchor),
            goToImdbButton.widthAnchor.constraint(equalToConstant: 16),
            goToImdbButton.heightAnchor.constraint(equalToConstant: 16),
            goToImdbButton.leadingAnchor.constraint(equalTo: voteAverageStackView.trailingAnchor, constant: 10),

            watchTrailerButton.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 20),
            watchTrailerButton.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -180),
            watchTrailerButton.topAnchor.constraint(equalTo: view.topAnchor, constant: 304),
            watchTrailerButton.heightAnchor.constraint(equalToConstant: 36),

            genresLabel.topAnchor.constraint(equalTo: watchTrailerButton.bottomAnchor, constant: 35),
            genresLabel.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 20),
            genresLabel.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -20),

            overviewLabel.topAnchor.constraint(equalTo: genresLabel.bottomAnchor, constant: 10),
            overviewLabel.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 20),
            overviewLabel.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -20),

            collectionView.topAnchor.constraint(equalTo: overviewLabel.bottomAnchor, constant: 10),
            collectionView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            collectionView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            collectionView.heightAnchor.constraint(equalToConstant: 110)
        ])
    }
}

// MARK: - Factory

private extension MovieDetailViewController {
    func makeBackgroundImageView() -> ImageLoader {
        let imageView = ImageLoader()
        imageView.backgroundColor = .systemBackground
        imageView.contentMode = .scaleAspectFill
        return imageView
    }

    func makeGradientImageView() -> ImageLoader {
        let imageView = ImageLoader()
        imageView.image = UIImage(named: Constants.gradientImageViewName)
        return imageView
    }

    func makePosterImageView() -> ImageLoader {
        let imageView = ImageLoader()
        imageView.layer.cornerRadius = 5
        imageView.clipsToBounds = true
        imageView.backgroundColor = .systemBackground
        imageView.contentMode = .scaleAspectFill
        return imageView
    }

    func makeTitleLabel() -> UILabel {
        let label = UILabel()
        label.numberOfLines = 0
        label.font = UIFont(name: Constants.fontExtraBold, size: 22)
        return label
    }

    func makeBoldLabel(size: CGFloat) -> UILabel {
        let label = UILabel()
        label.font = UIFont(name: Constants.fontBold, size: size)
        return label
    }

    func makeOverviewLabel() -> UILabel {
        let label = UILabel()
        label.font = UIFont(name: Constants.fontMedium, size: 16)
        label.numberOfLines = 0
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

    func makeGoToImdbButton() -> UIButton {
        let button = UIButton()
        button.setImage(UIImage(systemName: Constants.goToImdbButtonImageName), for: .normal)
        button.tintColor = .systemRed
        button.addTarget(self, action: #selector(goToImdbButtonAction), for: .touchUpInside)
        return button
    }

    func makeWatchTrailerButton() -> UIButton {
        let button = UIButton()
        button.backgroundColor = .clear
        button.layer.cornerRadius = 18
        button.layer.borderWidth = 1
        button.layer.borderColor = UIColor.systemRed.cgColor
        button.titleLabel?.font = UIFont(name: Constants.fontMedium, size: 15)
        button.setTitle(Constants.watchTrailerButtonTitle, for: .normal)
        button.setTitleColor(UIColor.systemRed, for: .normal)
        button.addTarget(self, action: #selector(watchTrailerButtonAction), for: .touchUpInside)
        return button
    }

    func makeCollectionView() -> UICollectionView {
        let collectionView = UICollectionView(frame: .zero, collectionViewLayout: collectionViewFlowLayout)
        collectionView.register(ActorCollectionViewCell.self, forCellWithReuseIdentifier: Constants.cellId)
        collectionView.backgroundColor = .clear
        collectionView.dataSource = self
        collectionView.scrollsToTop = false
        collectionView.showsHorizontalScrollIndicator = false
        return collectionView
    }

    func makeCollectionViewFlowLayout() -> UICollectionViewFlowLayout {
        let layout = UICollectionViewFlowLayout()
        layout.scrollDirection = .horizontal
        layout.minimumInteritemSpacing = 0
        layout.minimumLineSpacing = 12
        layout.itemSize = CGSize(width: 70, height: 110)
        layout.sectionInset = UIEdgeInsets(top: 0, left: 10, bottom: 0, right: 0)
        return layout
    }
}
