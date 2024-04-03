import Foundation

// Defines precision for x and y values. Higher value increases significant digits
let interval = 10000

func estimatePiSequential(interval: Int) -> Double {
    print("Estimating PI sequentially...")
    var circlePoints = 0
    var squarePoints = 0

    for _ in 0..<interval * interval {
      let randX = Double.random(in: 0.0...Double(interval)) / Double(interval)
      let randY = Double.random(in: 0.0...Double(interval)) / Double(interval)
      
    let originDist = randX * randX + randY * randY

    if originDist <= 1 {
      circlePoints += 1
    }

    squarePoints += 1
      
  }

  return 4.0 * Double(circlePoints) / Double(squarePoints) // Final estimated Pi
}

func estimatePiParallel(interval: Int, iterations: Int) -> Double {
    print("Estimating PI concurrently, with \(iterations) threads...")
    var circlePoints = 0
    var squarePoints = 0
    
    let dispatchGroup = DispatchGroup()
    
    let queue = DispatchQueue(label: "PiQueue", qos: .utility, attributes: .concurrent)
    
    for _ in 0..<iterations {
        dispatchGroup.enter()
        
        queue.async {
            for _ in 0..<interval*interval/iterations {
                
                let randX = Double.random(in: 0.0...Double(interval)) / Double(interval)
                let randY = Double.random(in: 0.0...Double(interval)) / Double(interval)
            
                let originDist = randX * randX + randY * randY
            
                if originDist <= 1 {
                    circlePoints += 1
                }
            
                squarePoints += 1
            }
            dispatchGroup.leave()
        }
    }
    
    dispatchGroup.wait()
    return 4.0 * Double(circlePoints) / Double(squarePoints) // Final estimated Pi
}

let args = CommandLine.arguments
var pi = 0.0
var elapsed : Duration = .zero

let clock = ContinuousClock()

if args.count > 0 && Int(args[1]) == 0 {
    elapsed = clock.measure {
        pi = estimatePiSequential(interval: interval)
    }
} else if args.count > 0 && Int(args[1]) == 1 {
    elapsed = clock.measure {
        pi = estimatePiParallel(interval: interval, iterations: 100)
    }
    
}

print("Final Estimation of Pi = \(pi)\nCompleted in \(elapsed) seconds")

