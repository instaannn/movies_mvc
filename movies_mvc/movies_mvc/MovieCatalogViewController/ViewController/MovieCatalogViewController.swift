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

    private var results: Results?
    private var networkService: NetworkServiceProtocol?

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
        navigationController?.setNavigationBarHidden(true, animated: true)
    }

    override func viewDidDisappear(_ animated: Bool) {
        super.viewDidDisappear(animated)
        navigationController?.setNavigationBarHidden(false, animated: true)
    }

    // MARK: - Private methods

    private func loadData() {
        networkService = NetworkService()
        networkService?.fetchPopularResult(complition: { [weak self] item in
            guard let self = self else { return }
            print(Thread.current)
            DispatchQueue.main.async {
                switch item {
                case let .failure(error):
                    print(error)
                case let .success(data):
                    self.results = data
                    self.tableView.reloadData()
                }
                print(Thread.current)
            }
        })
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

    @objc private func segmentControlAction(_ sender: UISegmentedControl) {
        let selectIndex = sender.selectedSegmentIndex
        switch selectIndex {
        case 0:
            categorySegmentControl.underlinePosition()
            networkService = NetworkService()
            networkService?.fetchPopularResult(complition: { [weak self] item in
                guard let self = self else { return }
                print(Thread.current)
                DispatchQueue.main.async {
                    switch item {
                    case let .failure(error):
                        print(error)
                    case let .success(data):
                        self.results = data
                        self.tableView.reloadData()
                    }
                    print(Thread.current)
                }
            })
        case 1:
            categorySegmentControl.underlinePosition()
            networkService = NetworkService()
            networkService?.fetchTopRatedResult(complition: { [weak self] item in
                guard let self = self else { return }
                print(Thread.current)
                DispatchQueue.main.async {
                    switch item {
                    case let .failure(error):
                        print(error)
                    case let .success(data):
                        self.results = data
                        self.tableView.reloadData()
                    }
                    print(Thread.current)
                }
            })
        case 2:
            categorySegmentControl.underlinePosition()
            networkService = NetworkService()
            networkService?.fetchUpcomingResult(complition: { [weak self] item in
                guard let self = self else { return }
                print(Thread.current)
                DispatchQueue.main.async {
                    switch item {
                    case let .failure(error):
                        print(error)
                    case let .success(data):
                        self.results = data
                        self.tableView.reloadData()
                    }
                    print(Thread.current)
                }
            })
        default:
            break
        }
    }
}

extension MovieCatalogViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        guard let id = results?.results[indexPath.row].id else { return }
        goToDetailMoviewViewController(id: id)
    }
}

// MARK: - UITableViewDataSource

extension MovieCatalogViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        results?.results.count ?? 0
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(
            withIdentifier: Constants.cellIdentifier
        ) as? MovieCatalogTableViewCell else { return UITableViewCell() }
        guard let movie = results?.results[indexPath.row] else { return UITableViewCell() }
        cell.configure(movie: movie)
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
        loadData()
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
