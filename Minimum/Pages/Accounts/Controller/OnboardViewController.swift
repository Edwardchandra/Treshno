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
    }
    
    override func viewWillAppear(_ animated: Bool) {
        navigationController?.setNavigationBarHidden(true, animated: animated)
        
        if UserDefaults.standard.bool(forKey: "isLoggedIn") == true {
            self.performSegue(withIdentifier: "goToMain", sender: self)
            
        }else{
            print("No Data Founde Please Login")
        }
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        navigationController?.setNavigationBarHidden(false, animated: animated)
    }
    
    @IBAction func unwindToOnboard(segue: UIStoryboardSegue){
        
    }

}
