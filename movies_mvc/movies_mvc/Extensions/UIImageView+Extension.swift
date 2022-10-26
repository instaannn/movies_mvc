// UIImageView+Extension.swift
// Copyright © RoadMap. All rights reserved.

import UIKit.UIImageView

extension UIImageView {
    func load(url: URL) {
        DispatchQueue.global().async { [weak self] in
            guard let self = self,
                  let data = try? Data(contentsOf: url),
                  let image = UIImage(data: data) else { return }

            DispatchQueue.main.async {
                self.image = image
            }
        }
    }
}
