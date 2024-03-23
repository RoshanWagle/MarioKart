//
//  ViewController.swift
//  Mario Kart
// Roshan Wagle ioS Project
//

import UIKit

class ViewController: UIViewController,
                      UIGestureRecognizerDelegate 
{
  
  // Bowser
  @IBOutlet weak var kartView0: UIImageView!
  // Mario
  @IBOutlet weak var kartView1: UIImageView!
  // Toad
  @IBOutlet weak var kartView2: UIImageView!
  
  // Keeps track of the original position of the karts when the view is initially loaded
  private var originalKartCenters = [CGPoint]()
  
  // Called when the view controller has awakened and is finished
  // setting up it's views
  override func viewDidLoad() {
    super.viewDidLoad()
    
    originalKartCenters = [kartView0.center,
                           kartView1.center,
                           kartView2.center]
  }
  
  //  Called when user double-taps a kart
  @IBAction func didDoubleTapKart(_ sender: UITapGestureRecognizer)
    {
    // Move the kart forward past the edge of the screen
      guard let kartView = sender.view else { return }
      // This uses the screen's width to ensure the kart moves entirely off the visible area.
          let screenWidth = view.frame.size.width
          let moveDistance = screenWidth - kartView.center.x + kartView.frame.size.width
      // The xPosition is set to moveDistance to ensure the kart moves past the screen edge using 'translate' below.
          translate(kart: kartView, by: Double(moveDistance), animationDuration: 0.6, completion: nil)
      // Assuming the kart is at its original position and view.frame.width will move it off-screen to the right
          if let kart = sender.view {
              translate(kart: kart, by: Double(self.view.frame.width)) {
                  // Once the kart is off-screen, this completion block will move it back to its original position.
                  // Note: You might need to adjust the by value if the kart's original position is not at 0.
                  self.translate(kart: kart, by: -Double(self.view.frame.width))
              }
          }
  }
  
  private func translate(kart: UIView?,
                         by xPosition: Double,
                         animationDuration: Double = 0.6,
                         completion: (() -> Void)? = nil) 
    {
    guard let kart = kart else { return }
    UIView.animateKeyframes(withDuration: animationDuration, delay: 0.0) 
      {
      kart.center.x = kart.center.x + xPosition
    } completion: { finished in
      completion?()
    }
  }
  
  // Called when the user rotates a kart
  @IBAction func didRotateKart(_ sender: UIRotationGestureRecognizer) 
    {
    // Rotating the kart
      rotate(kart: sender.view, gestureRecognizer: sender)
  }
  
  private func rotate(kart: UIView?,
                      gestureRecognizer: UIRotationGestureRecognizer)
    {
    guard let kart = kart else { return }
    kart.transform = kart.transform.rotated(by: gestureRecognizer.rotation)
    gestureRecognizer.rotation = 0
  }
  
  // Called when the user pinches a kart
  @IBAction func didPinchKart(_ sender: UIPinchGestureRecognizer) 
    {
    //Use the `scale` function below
      scale(kart: sender.view, gestureRecognizer: sender)
  }
  
  private func scale(kart: UIView?,
                     gestureRecognizer: UIPinchGestureRecognizer) 
    {
    guard let kart = kart else { return }
    kart.transform = kart.transform.scaledBy(x: gestureRecognizer.scale,
                                             y: gestureRecognizer.scale)
    gestureRecognizer.scale = 1
  }
  
  // Called when the user pans on a kart
  @IBAction func didPanKart(_ sender: UIPanGestureRecognizer) 
    {
    //Implement the `moveKart` function to move the kart based on the
    moveKart(using: sender)
  }

  // location of the location of the gesture in the view
  private func moveKart(using gestureRecognizer: UIPanGestureRecognizer)
    {
      // Get the location of the gesture in the view's coordinate system.
        let location = gestureRecognizer.location(in: view)
        
        // Get a reference to the kart being interacted with.
        let kartView = gestureRecognizer.view
        
        // Check the state of the gesture to begin tracking or updating the position.
        if gestureRecognizer.state == .began || gestureRecognizer.state == .changed {
          // Move the kart to the location of the gesture.
          kartView?.center = location
        }
  }
  
  @IBAction func didLongPressBackground(_ sender: UILongPressGestureRecognizer) 
    {
    // Implement `resetKarts` to reset the size and positioning of the karts
    if sender.state == .began 
      {
      resetKarts()
    }
  }
  
  
  private func resetKarts() 
    {
      UIView.animate(withDuration: 0.4)
      {
          // Reset the transformations for the karts to their original state.
          self.kartView0.transform = .identity
          self.kartView1.transform = .identity
          self.kartView2.transform = .identity
          
          // Reset the positions of the karts to their initial positions.
          self.kartView0.center = self.originalKartCenters[0]
          self.kartView1.center = self.originalKartCenters[1]
          self.kartView2.center = self.originalKartCenters[2]
        }
  }
  
  // Called whenever the view becomes visible on the screen
  override func viewDidAppear(_ animated: Bool) 
    {
    super.viewDidAppear(animated)
      // For Exercise 8
          //runStartingAnimationsOneByOne {
              // For Exercise 9
              // self.raceKartsWithSameSpeed()

              // For Exercise 10
              //self.raceKartsWithRandomizedSpeed()
      self.raceKartsWithRandomizedSpeed()
  }
  
  private func getKartReadyToRace(kart: UIImageView,
                                  completion: (() -> Void)? = nil) 
    {
    UIView.animateKeyframes(
      withDuration: 0.6,
      delay: 0.0,
      animations: {
        kart.center.x = kart.center.x + 20
      },
      completion: { _ in
        completion?()
      })
  }
  
  // Animate all karts all at once as if they were getting ready for a race
  // Tip: Use `getKartReadyToRace`
  private func runStartingAnimationsAllAtOnce() 
    {
      //getKartReadyToRace(kart: kartView0) {
      //self.getKartReadyToRace(kart: self.kartView1) {
          //self.getKartReadyToRace(kart: self.kartView2) {
             // completion?()
         // }
     // }
  //This above code after // works for runStartingAnimationsAllAtOnce
         

  }
  
  // Animate all karts one-by-one
  // Tip: Use `getKartReadyToRace` and its completion closure
  private func runStartingAnimationsOneByOne(completion: (() -> Void)? = nil) 
    {
     // let raceDistance = view.bounds.width * 2 // Assuming you want to move twice the width of the screen
     //  translate(kart: kartView0, by: raceDistance, animationDuration: 2.0, completion: nil)
     //   translate(kart: kartView1, by: raceDistance, animationDuration: 2.0, completion: nil)
     // translate(kart: kartView2, by: raceDistance, animationDuration: 2.0, completion: nil)
  }
  
  // Exercise 9: Have the karts race all at once to the finish line!
  // Tip: Use the `translate` function above
  private func raceKartsWithSameSpeed() 
    {
      //translate(kart: kartView0, by: view.frame.width)
       // translate(kart: kartView1, by: view.frame.width)
        //translate(kart: kartView2, by: view.frame.width)
      
  }
  
  // Exercise 10: Have the karts race all at once to the finish line!
  // Tip: Use the `translate` function above
  private func raceKartsWithRandomizedSpeed() 
    {
      let raceDistance = view.bounds.width * 2 // Assuming you want to move twice the width of the screen
      translate(kart: kartView0, by: raceDistance, animationDuration: 3, completion: nil)
      translate(kart: kartView1, by: raceDistance, animationDuration: 8, completion: nil)
      translate(kart: kartView2, by: raceDistance, animationDuration: 12, completion: nil)
  }
  }


