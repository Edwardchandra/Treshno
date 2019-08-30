//
//  OnboardViewController.swift
//  Minimum
//
//  Created by Edward Chandra on 26/08/19.
//  Copyright © 2019 nandamochammad. All rights reserved.
//

import UIKit

class OnboardViewController: UIViewController, UIScrollViewDelegate {

    @IBOutlet weak var signInButton: UIButton!
    @IBOutlet weak var signUpButton: UIButton!
    @IBOutlet weak var scrollView: UIScrollView!
    @IBOutlet weak var pageControll: UIPageControl!
    
    var slides:[Onboard] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        if UserDefaults.standard.bool(forKey: "isLoggedIn") == true {
            let homeVC = self.storyboard?.instantiateViewController(withIdentifier: "MainViewController") as? MainViewController
            self.navigationController?.pushViewController(homeVC!, animated: false)
        }else{
            print("No Data Founde Please Login")
        }
        
        pageControll.isEnabled = false
        
        
        setupScrollView()
    }

    
    func setupScrollView(){
        scrollView.delegate = self
        
        slides = createSlides()
        setupSlideScrollView(guidelineSlides: slides)
        
        pageControll.numberOfPages = slides.count
        pageControll.currentPage = 0
        
        view.bringSubviewToFront(pageControll)
    }
    
    func createSlides() -> [Onboard]{
        
        let slide1: Onboard = Bundle.main.loadNibNamed( "Onboard", owner: self, options: nil)?.first as! Onboard
        slide1.onboardLabel.text = "Pilah dan kumpulkan sampah anorganikmu \n dalam satu tempat."
        slide1.onboardImageView.image = UIImage(named: "Slide1")
        
        let slide2: Onboard = Bundle.main.loadNibNamed( "Onboard", owner: self, options: nil)?.first as! Onboard
        slide2.onboardLabel.text = "Kami siap membantumu dalam mengambil sampahmu."
        slide2.onboardImageView.image = UIImage(named: "Slide2")
        
        let slide3: Onboard = Bundle.main.loadNibNamed( "Onboard", owner: self, options: nil)?.first as! Onboard
        slide3.onboardLabel.text = "Bersama kami, sampah anorganikmu \n siap diolah menjadi lebih bermanfaat."
        slide3.onboardImageView.image = UIImage(named: "Slide3")
        
        return [slide1, slide2, slide3]
        
    }
    
    func setupSlideScrollView(guidelineSlides: [Onboard]){
        
        scrollView.frame = CGRect(x: 0, y: 243, width: 414, height: 410)
        scrollView.contentSize = CGSize(width: 414 * CGFloat(guidelineSlides.count), height: 410)
        scrollView.isPagingEnabled = true
        
        for i in 0 ..< guidelineSlides.count{
            guidelineSlides[i].frame = CGRect(x: 414 * CGFloat(i), y: 0, width: 414, height: 410)
            
            scrollView.addSubview(guidelineSlides[i])
        }
    }
    
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        let pageIndex = round(scrollView.contentOffset.x/414)
        pageControll.currentPage = Int(pageIndex)
        
//        let maximumHorizontalOffset: CGFloat = scrollView.contentSize.width - scrollView.frame.width
//        let currentHorizontalOffset: CGFloat = scrollView.contentOffset.x
//
//        // vertical
//        let maximumVerticalOffset: CGFloat = scrollView.contentSize.height - scrollView.frame.height
//        let currentVerticalOffset: CGFloat = scrollView.contentOffset.y
//
//        let percentageHorizontalOffset: CGFloat = currentHorizontalOffset / maximumHorizontalOffset
//        let percentageVerticalOffset: CGFloat = currentVerticalOffset / maximumVerticalOffset
//
//        let percentOffset: CGPoint = CGPoint(x: percentageHorizontalOffset, y: percentageVerticalOffset)
//
//        if(percentOffset.x > 0 && percentOffset.x <= 0.33) {
//            slides[0].onboardImageView.transform = CGAffineTransform(
//                scaleX: (0.33-percentOffset.x)/0.33,
//                y: (0.33-percentOffset.x)/0.33)
//            slides[1].onboardImageView.transform = CGAffineTransform(
//                scaleX: percentOffset.x/0.33,
//                y: percentOffset.x/0.33)
//
//        } else if(percentOffset.x > 0.33 && percentOffset.x <= 0.66) {
//            slides[1].onboardImageView.transform = CGAffineTransform(
//                scaleX: (0.66-percentOffset.x)/0.33,
//                y: (0.66-percentOffset.x)/0.33)
//            slides[2].onboardImageView.transform = CGAffineTransform(
//                scaleX: percentOffset.x/0.66,
//                y: percentOffset.x/0.66)
//        }
    }
    
    func scrollView(_ scrollView: UIScrollView, didScrollToPercentageOffset percentageHorizontalOffset: CGFloat) {
        if(pageControll.currentPage == 0) {
            
            let pageUnselectedColor: UIColor = fade(fromRed: 255/255, fromGreen: 255/255, fromBlue: 255/255, fromAlpha: 1, toRed: 103/255, toGreen: 58/255, toBlue: 183/255, toAlpha: 1, withPercentage: percentageHorizontalOffset * 3)
            pageControll.pageIndicatorTintColor = pageUnselectedColor
//
//
            let bgColor: UIColor = fade(fromRed: 103/255, fromGreen: 58/255, fromBlue: 183/255, fromAlpha: 1, toRed: 255/255, toGreen: 255/255, toBlue: 255/255, toAlpha: 1, withPercentage: percentageHorizontalOffset * 3)
            slides[pageControll.currentPage].backgroundColor = bgColor
//
            let pageSelectedColor: UIColor = fade(fromRed: 81/255, fromGreen: 36/255, fromBlue: 152/255, fromAlpha: 1, toRed: 103/255, toGreen: 58/255, toBlue: 183/255, toAlpha: 1, withPercentage: percentageHorizontalOffset * 3)
            pageControll.currentPageIndicatorTintColor = pageSelectedColor
        }
    }
    
    func fade(fromRed: CGFloat,
              fromGreen: CGFloat,
              fromBlue: CGFloat,
              fromAlpha: CGFloat,
              toRed: CGFloat,
              toGreen: CGFloat,
              toBlue: CGFloat,
              toAlpha: CGFloat,
              withPercentage percentage: CGFloat) -> UIColor {
        
        let red: CGFloat = (toRed - fromRed) * percentage + fromRed
        let green: CGFloat = (toGreen - fromGreen) * percentage + fromGreen
        let blue: CGFloat = (toBlue - fromBlue) * percentage + fromBlue
        let alpha: CGFloat = (toAlpha - fromAlpha) * percentage + fromAlpha
        
        // return the fade colour
        return UIColor(red: red, green: green, blue: blue, alpha: alpha)
    }
    
    override func traitCollectionDidChange(_ previousTraitCollection: UITraitCollection?) {

        setupSlideScrollView(guidelineSlides: slides)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        navigationController?.setNavigationBarHidden(true, animated: animated)
    }
    
    @IBAction func unwindToOnboard(segue: UIStoryboardSegue){
        
    }

}
