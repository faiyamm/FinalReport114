//
//  DrawingViewModel.swift
//  FinalReport114
//
//  Created by fai on 04/24/26.
//

import SwiftUI
import PencilKit

@Observable
class DrawingViewModel {
    var canvasView = PKCanvasView()
    var allowsFingerDrawing = true
    var selectedColor: Color = .black
    var lineWidth: CGFloat = 5.0
    var currentTool: DrawingTool = .pen

    let presetColors: [Color] = [.black, .red, .blue, .green, .orange, .purple, .yellow, .brown]

    func applyTool() {
        let uiColor = UIColor(selectedColor)
        switch currentTool {
        case .pen:
            canvasView.tool = PKInkingTool(.pen, color: uiColor, width: lineWidth)
        case .marker:
            canvasView.tool = PKInkingTool(.marker, color: uiColor, width: lineWidth)
        case .eraser:
            canvasView.tool = PKEraserTool(.bitmap)
        }
    }

    func selectTool(_ tool: DrawingTool) {
        currentTool = tool
        applyTool()
    }

    func selectColor(_ color: Color) {
        selectedColor = color
        if currentTool == .eraser { currentTool = .pen }
        applyTool()
    }

    func undo() {
        canvasView.undoManager?.undo()
    }

    func redo() {
        canvasView.undoManager?.redo()
    }

    func clearCanvas() {
        canvasView.drawing = PKDrawing()
    }
}
