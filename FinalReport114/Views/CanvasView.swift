//
//  CanvasView.swift
//  FinalReport114
//
//  Created by fai on 04/24/26.
//

import SwiftUI
import PencilKit

struct CanvasView: UIViewRepresentable {
    @Bindable var viewModel: DrawingViewModel

    func makeUIView(context: Context) -> PKCanvasView {
        let canvas = viewModel.canvasView
        canvas.drawingPolicy = viewModel.allowsFingerDrawing ? .anyInput : .pencilOnly
        canvas.backgroundColor = .white
        canvas.isOpaque = true
        canvas.minimumZoomScale = 0.5
        canvas.maximumZoomScale = 5.0
        canvas.bouncesZoom = true

        // Add two-finger pan gesture for trackpad navigation
        let panGesture = UIPanGestureRecognizer(target: context.coordinator, action: #selector(Coordinator.handlePan(_:)))
        panGesture.minimumNumberOfTouches = 2
        panGesture.maximumNumberOfTouches = 2
        canvas.addGestureRecognizer(panGesture)

        return canvas
    }

    func updateUIView(_ uiView: PKCanvasView, context: Context) {
        uiView.drawingPolicy = viewModel.allowsFingerDrawing ? .anyInput : .pencilOnly
    }

    func makeCoordinator() -> Coordinator {
        Coordinator()
    }

    class Coordinator: NSObject {
        @objc func handlePan(_ gesture: UIPanGestureRecognizer) {
            guard let scrollView = gesture.view as? UIScrollView else { return }
            let translation = gesture.translation(in: scrollView)
            let currentOffset = scrollView.contentOffset
            scrollView.contentOffset = CGPoint(
                x: currentOffset.x - translation.x,
                y: currentOffset.y - translation.y
            )
            gesture.setTranslation(.zero, in: scrollView)
        }
    }
}
