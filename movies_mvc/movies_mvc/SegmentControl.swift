// SegmentControl.swift
// Copyright © RoadMap. All rights reserved.

import UIKit

///
class SegmentControl: UISegmentedControl {}

extension UIImage {
    class func getSegRect(color: CGColor, andSize size: CGSize) -> UIImage {
        UIGraphicsBeginImageContextWithOptions(size, false, 0.0)
        let context = UIGraphicsGetCurrentContext()
        context?.setFillColor(color)
        let rectangle = CGRect(x: 0.0, y: 0.0, width: size.width, height: size.height)
        context?.fill(rectangle)
        guard let rectangleImage = UIGraphicsGetImageFromCurrentImageContext() else { return UIImage() }
        UIGraphicsEndImageContext()
        return rectangleImage
    }
}

extension UISegmentedControl {
    func removeBorder() {
        let background = UIImage.getSegRect(
            color: UIColor.systemBackground.cgColor,
            andSize: frame.size
        )

        setBackgroundImage(background, for: .normal, barMetrics: .default)
        setBackgroundImage(background, for: .selected, barMetrics: .default)
        setBackgroundImage(background, for: .highlighted, barMetrics: .default)

        let deviderLine = UIImage.getSegRect(
            color: UIColor.systemBackground.cgColor,
            andSize: CGSize(width: 1.0, height: 5)
        )

        setDividerImage(deviderLine, forLeftSegmentState: .selected, rightSegmentState: .normal, barMetrics: .default)
        setTitleTextAttributes([NSAttributedString.Key.foregroundColor: UIColor.secondaryLabel], for: .normal)
        setTitleTextAttributes([NSAttributedString.Key.foregroundColor: UIColor.systemRed], for: .selected)
    }

    func highlightSelectedSegment() {
        removeBorder()
        let lineWidth: CGFloat = bounds.size.width / CGFloat(numberOfSegments)
        let lineHeight: CGFloat = 7.0
        let lineXPosition = CGFloat(selectedSegmentIndex * Int(lineWidth))
        let lineYPosition = bounds.size.height - 6.0
        let underlineFrame = CGRect(x: lineXPosition, y: lineYPosition, width: lineWidth, height: lineHeight)
        let underLine = UIView(frame: underlineFrame)
        underLine
            .backgroundColor = .systemRed
        underLine.tag = 1
        addSubview(underLine)
    }

    func underlinePosition() {
        guard let underLine = viewWithTag(1) else { return }
        let xPosition = (bounds.width / CGFloat(numberOfSegments)) * CGFloat(selectedSegmentIndex)
        UIView.animate(
            withDuration: 0.5,
            delay: 0.0,
            usingSpringWithDamping: 0.5,
            initialSpringVelocity: 0.8,
            options: .curveEaseInOut,
            animations: {
                underLine.frame.origin.x = xPosition
            }
        )
    }
}
