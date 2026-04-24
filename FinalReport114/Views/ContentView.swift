//
//  ContentView.swift
//  FinalReport114
//
//  Created by Fai on 24/04/26.
//

import SwiftUI

struct ContentView: View {
    @State private var viewModel = DrawingViewModel()
    @Environment(\.horizontalSizeClass) private var horizontalSizeClass

    var body: some View {
        ZStack {
            // Background
            Color(.systemGray6)
                .ignoresSafeArea()

            // Canvas - adaptive padding based on layout
            CanvasView(viewModel: viewModel)
                .clipShape(RoundedRectangle(cornerRadius: 16))
                .shadow(color: .black.opacity(0.1), radius: 10, y: 4)
                .padding(.horizontal, horizontalSizeClass == .compact ? 12 : 70)
                .padding(.vertical, 12)

            // Floating toolbars (adapts to size class)
            ToolbarView(viewModel: viewModel)
        }
        .onAppear { viewModel.applyTool() }
        // MARK: - Keyboard Shortcuts (via menu commands so they work even when canvas has focus)
        .overlay {
            VStack {
                // Hidden buttons that register keyboard shortcuts globally
                Button("") { viewModel.selectTool(.pen) }
                    .keyboardShortcut("1", modifiers: [])
                Button("") { viewModel.selectTool(.marker) }
                    .keyboardShortcut("2", modifiers: [])
                Button("") { viewModel.selectTool(.eraser) }
                    .keyboardShortcut("3", modifiers: [])
                Button("") { viewModel.allowsFingerDrawing.toggle() }
                    .keyboardShortcut("4", modifiers: [])
                Button("") { viewModel.undo() }
                    .keyboardShortcut("z", modifiers: .command)
                Button("") { viewModel.redo() }
                    .keyboardShortcut("z", modifiers: [.command, .shift])
                Button("") { viewModel.clearCanvas() }
                    .keyboardShortcut(.delete, modifiers: .command)
                Button("") {
                    viewModel.lineWidth = min(30, viewModel.lineWidth + 2)
                    viewModel.applyTool()
                }
                .keyboardShortcut("=", modifiers: .command)
                Button("") {
                    viewModel.lineWidth = max(1, viewModel.lineWidth - 2)
                    viewModel.applyTool()
                }
                .keyboardShortcut("-", modifiers: .command)
            }
            .opacity(0)
            .allowsHitTesting(false)
        }
    }
}

#Preview {
    ContentView()
}
