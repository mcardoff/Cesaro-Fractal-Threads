//
//  CesaroView.swift
//  CesaroView
//
//  Created by Jeff_Terry on 1/19/22.
//

import Foundation
import SwiftUI

struct CesaroView: View {
    
    @Binding var cesaroVertices : [(xPoint: Double, yPoint: Double)]
    
    var body: some View {
        
        //Create the displayed View
        CesaroFractalShape(CesaroPoints: cesaroVertices)
            .stroke(Color.red, lineWidth: 1)
            .frame(width: 600, height: 600)
            .background(Color.white)
        
    }
    
    
    
    /// CesaroFractalShape
    ///
    /// calculates the Shape displayed in the Cesaro Fractal View
    ///
    /// - Parameters:
    ///   - CesaroPoints: array of tuples containing the Cesaro Fractal Vertices
    ///
    struct CesaroFractalShape: Shape {
        
        var CesaroPoints: [(xPoint: Double, yPoint: Double)] = []  ///Array of tuples
        
        /// path
        ///
        /// - Parameter rect: rect in which to draw the path
        /// - Returns: path for the Shape
        ///
        func path(in rect: CGRect) -> Path {
            // Create the Path for the Cesaro Fractal
            
            var path = Path()
            
            if CesaroPoints.isEmpty {
                return path
            }
            
            // move to the initial position
            path.move(to: CGPoint(x: CesaroPoints[0].xPoint, y: CesaroPoints[0].yPoint))
            
            // loop over all our points to draw create the paths
            for item in 1..<(CesaroPoints.endIndex) {
                path.addLine(to: CGPoint(x: CesaroPoints[item].xPoint, y: CesaroPoints[item].yPoint))
                
            }
            
            return (path)
        }
    }
}


struct CesaroView_Previews: PreviewProvider {
    
    @State static var myCesaroVertices = [(xPoint:75.0, yPoint:25.0), (xPoint:32.0, yPoint:22.0), (xPoint:210.0, yPoint:78.0), (xPoint:75.0, yPoint:25.0)]
    
    static var previews: some View {
    
        CesaroView(cesaroVertices: $myCesaroVertices)
        
    }
}


