// ImageLoader.swift
// Copyright © RoadMap. All rights reserved.

import UIKit.UIImageView

/// Кастомный UIImageView с кешированием картинок
class ImageLoader: UIImageView {
    // MARK: - Visual Components

    let activityIndicator = UIActivityIndicatorView()

    // MARK: - Public Properties

    private var imageURL: URL?
    private let cache = ImageCache()

    // MARK: - Public methods

    func loadImageWithUrl(_ url: URL) {
        activityIndicator.color = .darkGray
        addSubview(activityIndicator)
        activityIndicator.translatesAutoresizingMaskIntoConstraints = false
        activityIndicator.centerXAnchor.constraint(equalTo: centerXAnchor).isActive = true
        activityIndicator.centerYAnchor.constraint(equalTo: centerYAnchor).isActive = true

        imageURL = url

        image = nil
        activityIndicator.startAnimating()

        if let imageFromCache = cache[url] {
            image = imageFromCache
            activityIndicator.stopAnimating()
            return
        }

        URLSession.shared.dataTask(with: url, completionHandler: { data, _, error in
            if error != nil {
                print(error as Any)
                DispatchQueue.main.async {
                    self.activityIndicator.stopAnimating()
                }
                return
            }
            DispatchQueue.main.async {
                if let unwrappedData = data, let imageToCache = UIImage(data: unwrappedData) {
                    if self.imageURL == url {
                        self.image = imageToCache
                    }
                    self.cache[url] = self.image
                }
                self.activityIndicator.stopAnimating()
            }
        }).resume()
    }
}
