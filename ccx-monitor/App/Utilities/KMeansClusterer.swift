//
//  KMeansClusterer.swift
//  ccx-monitor
//
//  Created by Jason Goodney on 3/28/21.
//

import UIKit

class KMeansClusterer {
    
    func cluster(points: [Point], into k: Int) -> [Cluster] {
        var clusters: [Cluster] = []
        for _ in 0 ..< k {
            var point = points.randomElement()
            while point == nil || clusters.contains(where: { $0.center == point }) {
                point = points.randomElement()
            }
            
            clusters.append(Cluster(center: point!))
        }
        
//        for i in 0 ..< 10 {
//            clusters.forEach { $0.points.removeAll() }
//
            for point in points {
                let closest = findClosest(for: point, from: clusters)
                closest.points.append(point)
            }
            
//            var converged = true
            clusters.forEach {
//                let oldCenter = $0.center
                $0.updateCenter()
//                if oldCenter.distanceSquared(to: $0.center) > 0.001 {
//                    converged = false
//                }
            }
//
//            if converged {
//                print("Converged. Took \(i) iterations")
//                break
//            }
            
//        }
        
        return clusters
    }
    
    private func findClosest(for point: Point, from clusters: [Cluster]) -> Cluster {
        return clusters.min(by: {
            $0.center.distanceSquared(to: point) < $1.center.distanceSquared(to: point)
        })!
    }
    
}

extension KMeansClusterer {
    
    class Cluster {
        var points: [Point] = []
        var center: Point
        
        init(center: Point) {
            self.center = center
        }
        
        func calculateCurrentCenter() -> Point {
            if points.isEmpty {
                return Point.zero
            }
            return points.reduce(Point.zero, +) / CGFloat(points.count)
        }
        
        func updateCenter() {
            if points.isEmpty {
                return
            }
            let currentCenter = calculateCurrentCenter()
            center = points.min(by: {
                $0.distanceSquared(to: currentCenter) < $1.distanceSquared(to: currentCenter)
            })!
        }
    }
}

extension KMeansClusterer {
    struct Point : Equatable {
        let x : CGFloat
        let y : CGFloat
        let z : CGFloat
        init(_ x: CGFloat, _ y : CGFloat, _ z : CGFloat) {
            self.x = x
            self.y = y
            self.z = z
        }
        init(from color : UIColor) {
            var r : CGFloat = 0
            var g : CGFloat = 0
            var b : CGFloat = 0
            var a : CGFloat = 0
            if color.getRed(&r, green: &g, blue: &b, alpha: &a) {
                x = r
                y = g
                z = b
            } else {
                x = 0
                y = 0
                z = 0
            }
        }
        static let zero = Point(0, 0, 0)
        static func == (lhs: Point, rhs: Point) -> Bool {
            return lhs.x == rhs.x && lhs.y == rhs.y && lhs.z == rhs.z
        }
        static func +(lhs : Point, rhs : Point) -> Point {
            return Point(lhs.x + rhs.x, lhs.y + rhs.y, lhs.z + rhs.z)
        }
        static func /(lhs : Point, rhs : CGFloat) -> Point {
            return Point(lhs.x / rhs, lhs.y / rhs, lhs.z / rhs)
        }
        static func /(lhs : Point, rhs : Int) -> Point {
            return lhs / CGFloat(rhs)
        }
        func distanceSquared(to p : Point) -> CGFloat {
            return (self.x - p.x) * (self.x - p.x)
                + (self.y - p.y) * (self.y - p.y)
                + (self.z - p.z) * (self.z - p.z)
        }
        func toUIColor() -> UIColor {
            return UIColor(red: x, green: y, blue: z, alpha: 1)
        }
    }
}
