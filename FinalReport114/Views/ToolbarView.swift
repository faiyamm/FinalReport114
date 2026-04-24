//
//  ToolbarView.swift
//  FinalReport114
//
//  Created by fai on 04/24/26.
//

import SwiftUI

// MARK: - Adaptive Toolbar

struct ToolbarView: View {
    @Bindable var viewModel: DrawingViewModel
    @Environment(\.horizontalSizeClass) private var horizontalSizeClass

    var body: some View {
        if horizontalSizeClass == .compact {
            // Compact layout: single bottom toolbar
            CompactToolbar(viewModel: viewModel)
        } else {
            // Regular layout: side toolbars
            RegularToolbar(viewModel: viewModel)
        }
    }
}

// MARK: - Regular (Side Toolbars) Layout

struct RegularToolbar: View {
    @Bindable var viewModel: DrawingViewModel

    var body: some View {
        HStack(spacing: 0) {
            // Left sidebar - tools
            VStack(spacing: 14) {
                ToolButton(icon: "pencil.tip", color: .blue,
                           isSelected: viewModel.currentTool == .pen)
                    { viewModel.selectTool(.pen) }

                ToolButton(icon: "paintbrush.pointed.fill", color: .green,
                           isSelected: viewModel.currentTool == .marker)
                    { viewModel.selectTool(.marker) }

                ToolButton(icon: "eraser.fill", color: .orange,
                           isSelected: viewModel.currentTool == .eraser)
                    { viewModel.selectTool(.eraser) }

                Divider().frame(width: 40)

                ToolButton(icon: "arrow.uturn.backward", color: .purple)
                    { viewModel.undo() }
                ToolButton(icon: "arrow.uturn.forward", color: .purple)
                    { viewModel.redo() }

                Divider().frame(width: 40)

                ToolButton(icon: "hand.draw.fill",
                           color: viewModel.allowsFingerDrawing ? .cyan : .gray,
                           isSelected: viewModel.allowsFingerDrawing)
                    { viewModel.allowsFingerDrawing.toggle() }

                ToolButton(icon: "trash.fill", color: .red)
                    { viewModel.clearCanvas() }

                Spacer()

                // Thickness indicator
                VStack(spacing: 4) {
                    Circle()
                        .fill(viewModel.selectedColor)
                        .frame(width: max(8, viewModel.lineWidth),
                               height: max(8, viewModel.lineWidth))
                        .frame(width: 40, height: 40)

                    Text("\(Int(viewModel.lineWidth))")
                        .font(.caption2.weight(.semibold))
                        .foregroundStyle(.secondary)
                }
            }
            .padding(.vertical, 16)
            .padding(.horizontal, 8)
            .background(
                RoundedRectangle(cornerRadius: 20)
                    .fill(.ultraThinMaterial)
                    .shadow(color: .black.opacity(0.1), radius: 8, y: 2)
            )
            .padding(.leading, 10)
            .padding(.vertical, 10)

            Spacer()

            // Right sidebar - colors & thickness
            VStack(spacing: 14) {
                ForEach(viewModel.presetColors, id: \.self) { color in
                    Circle()
                        .fill(color)
                        .frame(width: 36, height: 36)
                        .overlay(
                            Circle()
                                .strokeBorder(.white, lineWidth: 3)
                                .opacity(viewModel.selectedColor == color ? 1 : 0)
                        )
                        .shadow(color: color.opacity(0.4),
                                radius: viewModel.selectedColor == color ? 4 : 0)
                        .onTapGesture { viewModel.selectColor(color) }
                }

                ColorPicker("", selection: Binding(
                    get: { viewModel.selectedColor },
                    set: { viewModel.selectColor($0) }
                ))
                .labelsHidden()
                .frame(width: 36, height: 36)

                Spacer()

                VStack(spacing: 6) {
                    Image(systemName: "line.diagonal")
                        .font(.title3)
                        .foregroundStyle(.secondary)

                    VerticalSlider(value: Binding(
                        get: { viewModel.lineWidth },
                        set: { viewModel.lineWidth = $0; viewModel.applyTool() }
                    ), range: 1...30)
                    .frame(width: 36, height: 120)

                    Image(systemName: "line.diagonal")
                        .font(.caption2)
                        .foregroundStyle(.secondary)
                }
            }
            .padding(.vertical, 16)
            .padding(.horizontal, 8)
            .background(
                RoundedRectangle(cornerRadius: 20)
                    .fill(.ultraThinMaterial)
                    .shadow(color: .black.opacity(0.1), radius: 8, y: 2)
            )
            .padding(.trailing, 10)
            .padding(.vertical, 10)
        }
    }
}

// MARK: - Compact (Bottom Toolbar) Layout

struct CompactToolbar: View {
    @Bindable var viewModel: DrawingViewModel
    @State private var showColorPicker = false

    var body: some View {
        VStack {
            Spacer()

            // Color strip (shown when toggled)
            if showColorPicker {
                ScrollView(.horizontal, showsIndicators: false) {
                    HStack(spacing: 10) {
                        ForEach(viewModel.presetColors, id: \.self) { color in
                            Circle()
                                .fill(color)
                                .frame(width: 32, height: 32)
                                .overlay(
                                    Circle()
                                        .strokeBorder(.white, lineWidth: 2)
                                        .opacity(viewModel.selectedColor == color ? 1 : 0)
                                )
                                .onTapGesture { viewModel.selectColor(color) }
                        }

                        ColorPicker("", selection: Binding(
                            get: { viewModel.selectedColor },
                            set: { viewModel.selectColor($0) }
                        ))
                        .labelsHidden()
                        .frame(width: 32, height: 32)

                        Divider().frame(height: 28)

                        // Inline thickness slider
                        HStack(spacing: 4) {
                            Image(systemName: "minus")
                                .font(.caption2)
                                .foregroundStyle(.secondary)
                            Slider(value: Binding(
                                get: { viewModel.lineWidth },
                                set: { viewModel.lineWidth = $0; viewModel.applyTool() }
                            ), in: 1...30)
                            .frame(width: 100)
                            Image(systemName: "plus")
                                .font(.caption2)
                                .foregroundStyle(.secondary)
                        }
                    }
                    .padding(.horizontal, 16)
                }
                .padding(.vertical, 8)
                .background(
                    RoundedRectangle(cornerRadius: 16)
                        .fill(.ultraThinMaterial)
                        .shadow(color: .black.opacity(0.1), radius: 6)
                )
                .padding(.horizontal, 8)
                .transition(.move(edge: .bottom).combined(with: .opacity))
            }

            // Main bottom bar
            HStack(spacing: 16) {
                ToolButton(icon: "pencil.tip", color: .blue,
                           isSelected: viewModel.currentTool == .pen)
                    { viewModel.selectTool(.pen) }

                ToolButton(icon: "paintbrush.pointed.fill", color: .green,
                           isSelected: viewModel.currentTool == .marker)
                    { viewModel.selectTool(.marker) }

                ToolButton(icon: "eraser.fill", color: .orange,
                           isSelected: viewModel.currentTool == .eraser)
                    { viewModel.selectTool(.eraser) }

                Divider().frame(height: 32)

                ToolButton(icon: "arrow.uturn.backward", color: .purple)
                    { viewModel.undo() }
                ToolButton(icon: "arrow.uturn.forward", color: .purple)
                    { viewModel.redo() }

                Divider().frame(height: 32)

                // Color toggle
                Button {
                    withAnimation(.spring(response: 0.3)) {
                        showColorPicker.toggle()
                    }
                } label: {
                    Circle()
                        .fill(viewModel.selectedColor)
                        .frame(width: 32, height: 32)
                        .overlay(Circle().strokeBorder(.white, lineWidth: 2))
                }

                ToolButton(icon: "hand.draw.fill",
                           color: viewModel.allowsFingerDrawing ? .cyan : .gray,
                           isSelected: viewModel.allowsFingerDrawing)
                    { viewModel.allowsFingerDrawing.toggle() }

                ToolButton(icon: "trash.fill", color: .red)
                    { viewModel.clearCanvas() }
            }
            .padding(.vertical, 10)
            .padding(.horizontal, 16)
            .background(
                RoundedRectangle(cornerRadius: 20)
                    .fill(.ultraThinMaterial)
                    .shadow(color: .black.opacity(0.15), radius: 8, y: -2)
            )
            .padding(.horizontal, 8)
            .padding(.bottom, 8)
        }
    }
}

// MARK: - Tool Button

struct ToolButton: View {
    let icon: String
    let color: Color
    var isSelected: Bool = false
    let action: () -> Void

    var body: some View {
        Button(action: action) {
            Image(systemName: icon)
                .font(.system(size: 18, weight: .semibold))
                .foregroundStyle(.white)
                .frame(width: 44, height: 44)
                .background(
                    Circle()
                        .fill(color.gradient)
                        .shadow(color: color.opacity(isSelected ? 0.5 : 0.2),
                                radius: isSelected ? 6 : 2)
                )
                .overlay(
                    Circle()
                        .strokeBorder(.white.opacity(isSelected ? 0.6 : 0), lineWidth: 3)
                )
                .scaleEffect(isSelected ? 1.1 : 1.0)
                .animation(.spring(response: 0.3), value: isSelected)
        }
    }
}

// MARK: - Vertical Slider

struct VerticalSlider: View {
    @Binding var value: CGFloat
    let range: ClosedRange<CGFloat>

    var body: some View {
        GeometryReader { geo in
            let height = geo.size.height
            let normalized = (value - range.lowerBound) / (range.upperBound - range.lowerBound)
            let yPos = height - (normalized * height)

            ZStack(alignment: .bottom) {
                RoundedRectangle(cornerRadius: 4)
                    .fill(Color.gray.opacity(0.2))
                    .frame(width: 6)
                    .frame(maxHeight: .infinity)

                RoundedRectangle(cornerRadius: 4)
                    .fill(Color.accentColor.gradient)
                    .frame(width: 6, height: normalized * height)
            }
            .frame(maxWidth: .infinity)
            .overlay(
                Circle()
                    .fill(.white)
                    .frame(width: 20, height: 20)
                    .shadow(radius: 2)
                    .position(x: geo.size.width / 2, y: yPos)
            )
            .gesture(
                DragGesture(minimumDistance: 0)
                    .onChanged { drag in
                        let ratio = 1.0 - (drag.location.y / height)
                        let clamped = min(max(ratio, 0), 1)
                        value = range.lowerBound + clamped * (range.upperBound - range.lowerBound)
                    }
            )
        }
    }
}
