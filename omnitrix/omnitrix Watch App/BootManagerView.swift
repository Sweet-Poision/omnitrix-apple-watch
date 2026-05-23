import SwiftUI
import AVKit
import WatchKit

struct CustomLineShape: Shape {
    func path(in rect: CGRect) -> Path {
        var path = Path()
        let width = rect.width
        let height = rect.height
        
        path.move(to: CGPoint(x: 0, y: 0))
        path.addLine(to: CGPoint(x: width - 20, y: height / 2))
        path.addLine(to: CGPoint(x: 0, y: height))
        path.addLine(to: CGPoint(x: 40, y: height))
        path.addLine(to: CGPoint(x: width, y: height / 2))
        path.addLine(to: CGPoint(x: 40, y: 0))
        path.closeSubpath()
        
        return path
    }
}

struct BootManagerView: View {
    private let lineWidth: CGFloat = 85
    @State private var edgeOffset: CGFloat = 150
    
    // 1. Interaction lock state
    @State private var isInteractable: Bool = false
    
    var body: some View {
        ZStack {
            Color.black.ignoresSafeArea()
            
            VideoPlayer(player: nil, videoOverlay: {})
                .frame(width: 0, height: 0)
                .position(x: -500, y: -500)
                .focusable(false)
                .disabled(true)
                .opacity(0)
                .allowsHitTesting(false)
                .accessibilityHidden(true)
            
            HStack {
                CustomLineShape()
                    .fill(Color.green)
                    .frame(width: lineWidth)
                    .frame(maxHeight: .infinity)
                    .offset(x: -edgeOffset)
                
                Spacer()
                
                CustomLineShape()
                    .fill(Color.green)
                    .frame(width: lineWidth)
                    .frame(maxHeight: .infinity)
                    .scaleEffect(x: -1, y: 1)
                    .offset(x: edgeOffset)
            }
            .padding(.horizontal, -10)
            .ignoresSafeArea(edges: .vertical)
        }
        // 2. Disables all touch and gesture inputs globally on this view until true
        .allowsHitTesting(isInteractable)
        .onAppear {
            executeAnimation()
        }
    }
    
    private func executeAnimation() {
        // Initial hardware wake delay
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) {
            
            // 1. Execute visual animation (Duration: 0.35s)
            withAnimation(.timingCurve(0.1, 0.9, 0.2, 1.0, duration: 0.35)) {
                edgeOffset = 0
            }
            
            // 2. Pre-fire the Taptic Engine 100ms before the visual stop
            // 0.35 total duration - 0.10 pre-fire offset = 0.25 execution delay
            DispatchQueue.main.asyncAfter(deadline: .now() + 0.25) {
                WKInterfaceDevice.current().play(.stop)
            }
            
            // 3. Unlock the UI exactly when the visual animation concludes
            DispatchQueue.main.asyncAfter(deadline: .now() + 0.35) {
                isInteractable = true
            }
        }
    }
}

#Preview {
    BootManagerView()
}
