//
//  OnboardingViewController.swift
//  Bread Box
//
//  Created by macOS on 11/23/20.
//  Copyright © 2020 Nathan Ellis. All rights reserved.
//

import UIKit

class OnboardingViewController: UIViewController, UIScrollViewDelegate {

    @IBOutlet weak var scrollView: UIScrollView!
    @IBOutlet weak var pageControl: UIPageControl!
    @IBOutlet weak var btnSkip: UIButton!
    @IBOutlet weak var btnNext: UIButton!

    var scrollWidth: CGFloat! = 0.0
    var scrollHeight: CGFloat! = 0.0

    //data for the slides
    var imgs = [R.image.onBoarding01(), R.image.onBoarding02(), R.image.onBoarding03(), R.image.onBoarding04(), R.image.onBoarding05()]

    override func viewDidLoad() {
        super.viewDidLoad()

        self.view.layoutIfNeeded()
        self.scrollView.delegate = self
        scrollView.isPagingEnabled = true
        scrollView.showsHorizontalScrollIndicator = false
        scrollView.showsVerticalScrollIndicator = false

        //create the slides and add them
        var frame = CGRect(x: 0, y: 0, width: 0, height: 0)

        let subViews = self.scrollView.subviews
        for subview in subViews {
            subview.removeFromSuperview()
        }

        for index in 0..<imgs.count {
            frame.origin.x = scrollWidth * CGFloat(index)
            frame.size = CGSize(width: scrollWidth, height: scrollHeight)

            let slide = UIView(frame: frame)

            //subviews
            let imageView = UIImageView.init(image: imgs[index])
            imageView.frame = CGRect(x:0, y:0, width:scrollWidth, height:scrollHeight)
            imageView.contentMode = .scaleToFill
//            imageView.center = CGPoint(x:scrollWidth/2,y: scrollHeight/2 - 50)

            slide.addSubview(imageView)
            scrollView.addSubview(slide)
        }

        //set width of scrollview to accomodate all the slides
        scrollView.contentSize = CGSize(width: scrollWidth * CGFloat(imgs.count), height: scrollHeight)

        //disable vertical scroll/bounce
        self.scrollView.contentSize.height = 1.0

        //initial state
        pageControl.numberOfPages = imgs.count
        pageControl.currentPage = 0
    }

    override func viewDidLayoutSubviews() {
        scrollWidth = scrollView.frame.size.width
        scrollHeight = scrollView.frame.size.height
    }

    //indicator
    @IBAction func pageChanged(_ sender: Any) {
        scrollView!.scrollRectToVisible(CGRect(x: scrollWidth * CGFloat ((pageControl?.currentPage)!), y: 0, width: scrollWidth, height: scrollHeight), animated: true)
    }

    func scrollViewDidEndDecelerating(_ scrollView: UIScrollView) {
        let page = (scrollView.contentOffset.x)/scrollWidth
        setIndiactorForCurrentPage(page: Int(page))
    }

    func setIndiactorForCurrentPage(page: Int) {
        pageControl?.currentPage = Int(page)
        if (pageControl.currentPage == imgs.count-1) {
            btnNext.setTitle("Get Started", for: .normal)
        } else {
            btnNext.setTitle("Next", for: .normal)
        }
        if (pageControl.currentPage == 3 || pageControl.currentPage == 4) {
            btnNext.setTitleColor(UIColor.black, for: .normal)
            btnSkip.setTitleColor(UIColor.black, for: .normal)
            pageControl.currentPageIndicatorTintColor = UIColor.black
            pageControl.pageIndicatorTintColor = UIColor.darkGray
        } else {
            btnNext.setTitleColor(UIColor.white, for: .normal)
            btnSkip.setTitleColor(UIColor.white, for: .normal)
            pageControl.currentPageIndicatorTintColor = UIColor.white
            pageControl.pageIndicatorTintColor = UIColor.lightGray
        }
    }

    @IBAction func clickSkip(_ sender: Any) {
        let vc = R.storyboard.main().instantiateViewController(withIdentifier: "DashboardViewController") as! DashboardViewController
        vc.modalPresentationStyle = .fullScreen
        self.present(vc, animated: true, completion: nil)
    }

    @IBAction func clickNext(_ sender: Any) {
        let page = (scrollView?.contentOffset.x)!/scrollWidth
        if (Int(page) == imgs.count-1) {
            let vc = R.storyboard.main().instantiateViewController(withIdentifier: "DashboardViewController") as! DashboardViewController
            vc.modalPresentationStyle = .fullScreen
            self.present(vc, animated: true, completion: nil)
            return
        }

        var frame: CGRect = scrollView.frame
        frame.origin.x = frame.size.width * CGFloat(page + 1)
        frame.origin.y = 0
        scrollView.scrollRectToVisible(frame, animated: true)

        setIndiactorForCurrentPage(page: Int(page) + 1)
    }
}
