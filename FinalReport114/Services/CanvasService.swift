//
//  CanvasService.swift
//  FinalReport114
//
//  Created by fai on 04/24/26.
//

import SwiftUI
import PencilKit

struct CanvasService {
    static func configureCanvas(_ canvasView: PKCanvasView, allowsFingerDrawing: Bool) {
        canvasView.drawingPolicy = allowsFingerDrawing ? .anyInput : .pencilOnly
        canvasView.backgroundColor = .white
        canvasView.isOpaque = true
        canvasView.minimumZoomScale = 0.5
        canvasView.maximumZoomScale = 5.0
        canvasView.bouncesZoom = true
    }
}
