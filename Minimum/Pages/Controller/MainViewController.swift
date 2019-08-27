//
//  MainViewController.swift
//  Minimum
//
//  Created by Jessica Jacob on 22/08/19.
//  Copyright © 2019 nandamochammad. All rights reserved.
//

import UIKit

class MainViewController: UIViewController, UIScrollViewDelegate {
    
    @IBOutlet weak var mulaiButton: UIButton!
    @IBOutlet weak var onboardScrollView: UIScrollView!
    @IBOutlet weak var pageControl: UIPageControl!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        
        
        customizeElement()
        
        setupScrollView()
    }
    
    func setupScrollView(){
        onboardScrollView.delegate = self
        
        let guidelineSlides:[Onboard] = createSlides()
        setupSlideScrollView(guidelineSlides: guidelineSlides)
        
        pageControl.numberOfPages = guidelineSlides.count
        pageControl.currentPage = 0
        
        view.bringSubviewToFront(pageControl)
    }
    
    func createSlides() -> [Onboard]{
        
        let slide1: Onboard = Bundle.main.loadNibNamed( "Onboard", owner: self, options: nil)?.first as! Onboard
        slide1.onboardLabel.text = "Slide 1"
        
        let slide2: Onboard = Bundle.main.loadNibNamed( "Onboard", owner: self, options: nil)?.first as! Onboard
        slide2.onboardLabel.text = "Slide 2"
        
        let slide3: Onboard = Bundle.main.loadNibNamed( "Onboard", owner: self, options: nil)?.first as! Onboard
        slide3.onboardLabel.text = "Slide 3"
        
        slide1.customizeElement()
        slide2.customizeElement()
        slide3.customizeElement()
        
        return [slide1, slide2, slide3]
    }
    
    func setupSlideScrollView(guidelineSlides: [Onboard]){
        onboardScrollView.frame = CGRect(x: 0, y: 243, width: 414, height: 410)
        onboardScrollView.contentSize = CGSize(width: 414 * CGFloat(guidelineSlides.count), height: 410)
        onboardScrollView.isPagingEnabled = true
        
        for i in 0 ..< guidelineSlides.count{
            guidelineSlides[i].frame = CGRect(x: 414 * CGFloat(i), y: 0, width: 414, height: 410)
            
            onboardScrollView.addSubview(guidelineSlides[i])
        }
    }
    
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        let pageIndex = round(scrollView.contentOffset.x/414)
        pageControl.currentPage = Int(pageIndex)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        // Hide the Navigation Bar
        self.navigationController?.setNavigationBarHidden(true, animated: animated)
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        
        // Show the Navigation Bar
        self.navigationController?.setNavigationBarHidden(false, animated: animated)
    }
    
    func customizeElement(){
        mulaiButton.layer.cornerRadius = 11
    }
    
    @IBAction func unwindToMain(segue: UIStoryboardSegue){
        
    }

}
