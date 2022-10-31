// MovieCatalogViewController.swift
// Copyright © RoadMap. All rights reserved.

import UIKit

/// Каталог фильмов
final class MovieCatalogViewController: UIViewController {
    // MARK: - Constants

    private enum Constants {
        static let segmentControlItems = ["Popular", "TopRated", "Upcoming"]
        static let cellIdentifier = "Cell"
    }

    // MARK: - Private visual Components

    private lazy var tableView = makeTableView()
    private lazy var containerView = UIView()
    private lazy var categorySegmentControl = SegmentControl(items: Constants.segmentControlItems)

    // MARK: - Private properties

    private var networkService = NetworkService()
    private var movies: [Movie] = []
    private var currentPage = 1
    private var hasNextPage = true
    private var currentRequestType: RequestType = .popular

    // MARK: - Lifecycle

    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
        setupBinding()
        setupNavigationController()
        setupCategorySegmentControl()
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        setNavigationBarHidden(true)
    }

    override func viewDidDisappear(_ animated: Bool) {
        super.viewDidDisappear(animated)
        setNavigationBarHidden(false)
    }

    // MARK: - Private methods

    func update() {
        if hasNextPage {
            currentPage += 1
            loadData(requestType: currentRequestType)
            hasNextPage = false
        }
    }

    private func loadData(requestType: RequestType) {
        networkService.fetchResult(page: currentPage, requestType: requestType, complition: { [weak self] item in
            guard let self = self else { return }
            DispatchQueue.main.async {
                switch item {
                case let .success(data):
                    self.movies += data.movies
                    self.hasNextPage = true
                    self.tableView.reloadData()
                case let .failure(error):
                    print(error)
                }
            }
        })
    }

    private func setNavigationBarHidden(_ isHidden: Bool) {
        navigationController?.setNavigationBarHidden(isHidden, animated: true)
    }

    private func setupNavigationController() {
        view.backgroundColor = .systemBackground
        navigationItem.backBarButtonItem = UIBarButtonItem(title: "", style: .plain, target: nil, action: nil)
    }

    private func setupCategorySegmentControl() {
        categorySegmentControl.highlightSelectedSegment()
        categorySegmentControl.addTarget(self, action: #selector(segmentControlAction(_:)), for: .valueChanged)
        categorySegmentControl.selectedSegmentIndex = 0
        categorySegmentControl.underlinePosition()
    }

    private func goToDetailMoviewViewController(id: Int) {
        let movieDetailViewController = MovieDetailViewController()
        movieDetailViewController.movieId = id
        navigationController?.pushViewController(movieDetailViewController, animated: true)
    }

    private func updateForSegment() {
        movies.removeAll()
        currentPage = 1
        categorySegmentControl.underlinePosition()
    }

    @objc private func segmentControlAction(_ sender: UISegmentedControl) {
        let selectIndex = sender.selectedSegmentIndex
        switch selectIndex {
        case 0:
            updateForSegment()
            currentRequestType = .popular
            loadData(requestType: currentRequestType)
        case 1:
            updateForSegment()
            currentRequestType = .topRated
            loadData(requestType: currentRequestType)
        case 2:
            updateForSegment()
            currentRequestType = .upcoming
            loadData(requestType: currentRequestType)
        default:
            break
        }
    }
}

// MARK: - UITableViewDelegate

extension MovieCatalogViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        goToDetailMoviewViewController(id: movies[indexPath.row].id)
    }
}

// MARK: - UITableViewDataSource

extension MovieCatalogViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        movies.count
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(
            withIdentifier: Constants.cellIdentifier
        ) as? MovieCatalogTableViewCell else { return UITableViewCell() }
        if indexPath.row == movies.count - 1 {
            update()
        }
        cell.configure(movie: movies[indexPath.row])
        return cell
    }
}

// MARK: - SetupUI

private extension MovieCatalogViewController {
    func setupUI() {
        view.addSubview(tableView)
        view.addSubview(containerView)
        containerView.addSubview(categorySegmentControl)

        setUpConstraints()
    }

    func setupBinding() {
        loadData(requestType: currentRequestType)
    }

    func setUpConstraints() {
        [
            tableView,
            containerView,
            categorySegmentControl
        ].forEach {
            $0.translatesAutoresizingMaskIntoConstraints = false
        }

        NSLayoutConstraint.activate([
            containerView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            containerView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            containerView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            containerView.heightAnchor.constraint(equalToConstant: 50),

            categorySegmentControl.centerXAnchor.constraint(equalTo: containerView.centerXAnchor),
            categorySegmentControl.centerYAnchor.constraint(equalTo: containerView.centerYAnchor),
            categorySegmentControl.heightAnchor.constraint(equalToConstant: 30),
            categorySegmentControl.widthAnchor.constraint(equalToConstant: 250),

            tableView.topAnchor.constraint(equalTo: containerView.bottomAnchor),
            tableView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            tableView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            tableView.bottomAnchor.constraint(equalTo: view.bottomAnchor),
        ])
    }
}

// MARK: - Factory

private extension MovieCatalogViewController {
    func makeTableView() -> UITableView {
        let tableView = UITableView()
        tableView.showsVerticalScrollIndicator = false
        tableView.separatorStyle = .none
        tableView.register(MovieCatalogTableViewCell.self, forCellReuseIdentifier: Constants.cellIdentifier)
        tableView.dataSource = self
        tableView.delegate = self
        return tableView
    }
}
