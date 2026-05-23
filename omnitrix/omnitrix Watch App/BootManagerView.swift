//
//  BootManagerView.swift
//  omnitrix
//
//  Created by Utsav Raj on 23/05/26.
//

import SwiftUI
import WatchKit

struct BootManagerView: View {
    @State private var lineOffset: CGFloat = 100
    @State private var isBooted = false

    var body: some View {
        ZStack {
            Color.black.edgesIgnoringSafeArea(.all)
            
            if isBooted {
                OmnitrixDialView()
                    .transition(.opacity)
            } else {
                HStack {
                    Capsule()
                        .fill(Color.green)
                        .frame(width: 12, height: 120)
                        .offset(x: -lineOffset)
                    Spacer()
                    Capsule()
                        .fill(Color.green)
                        .frame(width: 12, height: 120)
                        .offset(x: lineOffset)
                }
                .padding(.horizontal, 20)
                .onAppear {
                    executeBootSequence()
                }
            }
        }
    }
    
    private func executeBootSequence() {
        WKInterfaceDevice.current().play(.start)
        withAnimation(.spring(response: 0.6, dampingFraction: 0.7)) {
            lineOffset = 0
        }
        DispatchQueue.main.asyncAfter(deadline: .now() + 1.5) {
            withAnimation(.easeIn(duration: 0.3)) {
                isBooted = true
            }
        }
    }
}
