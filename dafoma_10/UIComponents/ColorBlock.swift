//
//  ColorBlock.swift
//  ColorHarmony: Blink
//
//  Created by Вячеслав on 7/26/25.
//

import SwiftUI

struct ColorBlock: View {
    let color: Color
    let title: String
    let subtitle: String?
    var size: BlockSize = .medium
    var isSelected: Bool = false
    var onTap: (() -> Void)?
    
    enum BlockSize {
        case small, medium, large
        
        var dimensions: CGSize {
            switch self {
            case .small: return CGSize(width: 80, height: 80)
            case .medium: return CGSize(width: 120, height: 120)
            case .large: return CGSize(width: 160, height: 160)
            }
        }
        
        var titleFont: Font {
            switch self {
            case .small: return .caption
            case .medium: return .footnote
            case .large: return .body
            }
        }
        
        var subtitleFont: Font {
            switch self {
            case .small: return .caption2
            case .medium: return .caption
            case .large: return .footnote
            }
        }
    }
    
    var body: some View {
        VStack(spacing: 8) {
            // Color block
            RoundedRectangle(cornerRadius: 16)
                .fill(color)
                .frame(width: size.dimensions.width, height: size.dimensions.height)
                .overlay(
                    RoundedRectangle(cornerRadius: 16)
                        .stroke(
                            isSelected ? ColorTheme.supportive : Color.clear,
                            lineWidth: isSelected ? 3 : 0
                        )
                )
                .shadow(color: .black.opacity(0.2), radius: 8, x: 0, y: 4)
                .scaleEffect(isSelected ? 1.05 : 1.0)
                .animation(.spring(response: 0.3, dampingFraction: 0.7), value: isSelected)
            
            // Text labels
            VStack(spacing: 2) {
                Text(title)
                    .font(size.titleFont)
                    .fontWeight(.semibold)
                    .foregroundColor(ColorTheme.primaryText)
                    .multilineTextAlignment(.center)
                
                if let subtitle = subtitle {
                    Text(subtitle)
                        .font(size.subtitleFont)
                        .foregroundColor(ColorTheme.primaryText.opacity(0.7))
                        .multilineTextAlignment(.center)
                }
            }
        }
        .onTapGesture {
            withAnimation(.spring(response: 0.3, dampingFraction: 0.7)) {
                onTap?()
            }
        }
    }
}

struct ColorPalette: View {
    @EnvironmentObject var themeManager: ThemeManager
    let colors: [(Color, String, String)] = [
        (ColorTheme.backgroundMain, "Ocean Blue", "#2490ad"),
        (ColorTheme.backgroundAccent1, "Deep Purple", "#3c166d"),
        (ColorTheme.backgroundAccent2, "Navy Blue", "#1a2962"),
        (ColorTheme.primaryButton, "Golden Orange", "#fbaa1a"),
        (ColorTheme.secondaryButton, "Vibrant Pink", "#f0048d"),
        (ColorTheme.supportive, "Electric Green", "#01ff00"),
        (ColorTheme.neutral, "Soft Gray", "#f7f7f7")
    ]
    
    @State private var selectedColorIndex: Int? = nil
    
    var body: some View {
        LazyVGrid(columns: Array(repeating: GridItem(.flexible()), count: 3), spacing: 16) {
            ForEach(colors.indices, id: \.self) { index in
                let (color, name, hex) = colors[index]
                ColorBlock(
                    color: color,
                    title: name,
                    subtitle: hex,
                    size: .medium,
                    isSelected: selectedColorIndex == index
                ) {
                    selectedColorIndex = selectedColorIndex == index ? nil : index
                    
                    // Add haptic feedback
                    let impactFeedback = UIImpactFeedbackGenerator(style: .medium)
                    impactFeedback.impactOccurred()
                }
            }
        }
        .padding()
    }
}

struct ColorBlock_Previews: PreviewProvider {
    static var previews: some View {
        VStack(spacing: 20) {
            ColorBlock(
                color: ColorTheme.primaryButton,
                title: "Primary",
                subtitle: "#fbaa1a",
                size: .medium,
                isSelected: true
            )
            
            ColorPalette()
                .environmentObject(ThemeManager())
        }
        .background(ColorTheme.backgroundMain)
        .previewLayout(.sizeThatFits)
    }
} 