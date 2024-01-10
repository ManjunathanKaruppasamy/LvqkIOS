//
//  SegmentControlExtension.swift
//  FintechBase
//
//  Created by Manjunathan Karuppasamy on 15/03/23.
//

import Foundation
import UIKit

extension UISegmentedControl {
    func replaceSegments(segments: [String]) {
        self.removeAllSegments()
        for segment in segments {
            self.insertSegment(withTitle: segment, at: self.numberOfSegments, animated: false)
        }
    }
}
