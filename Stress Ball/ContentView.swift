import SwiftUI

struct ContentView: View {
    @State private var ballOffset: CGFloat = 0
    @State private var isBouncing = false
    @State private var selectedColor: Color = .yellow
    @State private var ballScale: CGFloat = 1.0
    
    let colors: [Color] = [.yellow, .green, .orange, .pink]
    
    var body: some View {
        ZStack {
            Wall3D()
            
            VStack {
                Picker("Ball Color", selection: $selectedColor) {
                    ForEach(colors, id: \.self) { color in
                        Text(color.description.capitalized)
                            .tag(color)
                    }
                }
                .pickerStyle(SegmentedPickerStyle())
                .padding()
                .background(Color.white.opacity(0.8))
                .cornerRadius(10)
                .shadow(color: .black.opacity(0.2), radius: 5, x: 0, y: 5)
                
                Spacer()
                
                TennisBall3D(color: selectedColor)
                    .frame(width: 100, height: 100)
                    .scaleEffect(ballScale)
                    .offset(y: ballOffset)
                    .animation(.spring(response: 0.5, dampingFraction: 0.5, blendDuration: 0.5), value: ballOffset)
                    .animation(.spring(response: 0.3, dampingFraction: 0.5, blendDuration: 0.3), value: ballScale)
                    .onTapGesture {
                        bounce()
                    }
                
                Spacer()
                    .frame(height: 100)
            }
        }
    }
    
    func bounce() {
        guard !isBouncing else { return }
        isBouncing = true
        
        withAnimation(.easeOut(duration: 0.3)) {
            ballOffset = -150
            ballScale = 0.9
        }
        
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.3) {
            withAnimation(.easeIn(duration: 0.3)) {
                ballOffset = 50
                ballScale = 1.1
            }
            
            DispatchQueue.main.asyncAfter(deadline: .now() + 0.3) {
                withAnimation(.easeInOut(duration: 0.2)) {
                    ballOffset = 0
                    ballScale = 1.0
                }
                isBouncing = false
            }
        }
    }
}

struct TennisBall3D: View {
    let color: Color
    
    var body: some View {
        ZStack {
            // Base ball
            Circle()
                .fill(
                    RadialGradient(gradient: Gradient(colors: [color.lighter(), color, color.darker()]),
                                   center: .topLeading,
                                   startRadius: 0,
                                   endRadius: 100)
                )
                .shadow(color: .black.opacity(0.4), radius: 10, x: 5, y: 5)
            
            // Tennis ball pattern
            Circle()
                .stroke(Color.white.opacity(0.5), lineWidth: 2)
                .rotationEffect(.degrees(45))
            
            Path { path in
                path.move(to: CGPoint(x: 0, y: 50))
                path.addQuadCurve(to: CGPoint(x: 100, y: 50), control: CGPoint(x: 50, y: 0))
                path.move(to: CGPoint(x: 0, y: 50))
                path.addQuadCurve(to: CGPoint(x: 100, y: 50), control: CGPoint(x: 50, y: 100))
            }
            .stroke(Color.white.opacity(0.5), lineWidth: 2)
            
            // Highlight
            Circle()
                .fill(RadialGradient(gradient: Gradient(colors: [Color.white.opacity(0.7), Color.clear]),
                                     center: .topLeading,
                                     startRadius: 0,
                                     endRadius: 60))
                .frame(width: 80, height: 80)
                .offset(x: -10, y: -10)
        }
    }
}
struct Wall3D: View {
    let gridSize: CGFloat = 20

    var body: some View {
        GeometryReader { geometry in
            ZStack {
                // Background gradient
                LinearGradient(gradient: Gradient(colors: [Color.gray.opacity(0.6), Color.gray.opacity(0.3)]),
                               startPoint: .topLeading,
                               endPoint: .bottomTrailing)
                
                // Grid lines
                ForEach(0..<Int(geometry.size.width / gridSize), id: \.self) { x in
                    ForEach(0..<Int(geometry.size.height / gridSize), id: \.self) { y in
                        Rectangle()
                            .fill(Color.black.opacity(0.1))
                            .frame(width: 1, height: 1)
                            .position(x: CGFloat(x) * gridSize, y: CGFloat(y) * gridSize)
                    }
                }
                
                // 3D effect overlay
                LinearGradient(gradient: Gradient(colors: [Color.white.opacity(0.2), Color.clear]),
                               startPoint: .topLeading,
                               endPoint: .bottomTrailing)
            }
        }
        .edgesIgnoringSafeArea(.all)
    }
}

extension Color {
        func lighter() -> Color {
            return self.opacity(0.8)
        }
        
        func darker() -> Color {
            return self.opacity(1.2)
        }
        
        func saturated() -> Color {
            return self // We'll return the color as is for now
        }
    }

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}

