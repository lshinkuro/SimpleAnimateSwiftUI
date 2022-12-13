//
//  ContentView.swift
//  SimpleAnimation
//
//  Created by nur kholis on 11/12/22.
//

import SwiftUI

struct ContentView: View {
    @State private var half: Bool = false
    @State private var dim: Bool = false
    
    @State private var isSquare: Bool = false
    
    var duration: Double = 1.0
    
    var body: some View {
        VStack {
            ExtractedView(half: $half,
                          dim: $dim)
//
            
            withAnimation(.easeInOut(duration: duration)) {
                PolygonShape(sides: half ? 9 : 3, scale: 2.0).stroke(Color.purple, lineWidth: 4)

            }
        }
        .padding(40)
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}

struct ExtractedView: View {
    
    @Binding var half: Bool
    @Binding var dim: Bool
    
    var body: some View {
        Image("dian")
            .imageScale(.large)
            .foregroundColor(.accentColor)
            .cornerRadius(25)
            .shadow(color: .gray,
                    radius: 1.0,
                    x: 0.0,
                    y: 0.0)
            .scaleEffect(half ? 0.5 : 1.0)
            .opacity(dim ? 0.2 : 1.0)
          
            .onTapGesture {
                withAnimation(.easeInOut(duration: 1.0)) {
                    self.dim.toggle()
                    self.half.toggle()
                }
            
            }
    }
}

struct PolygonShape: Shape {
    var sides: Double
    var scale: Double

    
    var animatableData: AnimatablePair<Double, Double> {
        get { AnimatablePair(sides, scale) }
        set {
            sides = newValue.first
            scale = newValue.second
        }
    }
    
//
//    init(sides: Int) {
//        self.sides = sides
//        self.sidesAsDouble = Double(sides)
//    }
    
    func path(in rect: CGRect) -> Path {
        // hypotenuse
        let h = Double(min(rect.size.width, rect.size.height)) / 2.0
        
        // center
        let c = CGPoint(x: rect.size.width / 2.0, y: rect.size.height / 2.0)
        
        var path = Path()
        
        let extra: Int = Double(sides) != Double(Int(sides)) ? 1 : 0
                
        for i in 0..<Int(sides) + extra {
            let angle = (Double(i) * (360.0 / Double(sides))) * Double.pi / 180

            // Calculate vertex position
            let pt = CGPoint(x: c.x + CGFloat(cos(angle) * h), y: c.y + CGFloat(sin(angle) * h))
            
            if i == 0 {
                path.move(to: pt) // move to first vertex
            } else {
                path.addLine(to: pt) // draw line to next vertex
            }
        }
        
        path.closeSubpath()
        
        return path
    }
}

