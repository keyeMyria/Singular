//
//  TutorialViewController.swift
//  Singular
//
//  Created by dlr4life on 8/9/17.
//  Copyright © 2017 dlr4life. All rights reserved.
//

import UIKit
import Crashlytics

class TutorialViewController: UIPageViewController, UIPageViewControllerDataSource, UIPageViewControllerDelegate {
    
    lazy var VCArr: [UIViewController] = {
        return [self.VCInstance(name: "FirstVC"),
                self.VCInstance(name: "SecondVC"),
                self.VCInstance(name: "ThirdVC"),
                self.VCInstance(name: "FourthVC"),
                self.VCInstance(name: "FifthVC"),
                self.VCInstance(name: "SixthVC")]
//                self.VCInstance(name: "SeventhVC")]
    }()
    
    private func VCInstance(name: String) -> UIViewController {
        return UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: name)
    }
    //MARK: - Page Control
    
    let pageControl = UIPageControl()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        Answers.logContentView(withName: "Tutorial",
                               contentType: "Destination on First Launch",
                               contentId: "Tutoriel View",
                               customAttributes: nil)
        
        self.dataSource = self
        self.delegate = self
        
        pageControl.numberOfPages = VCArr.count
        pageControl.currentPage = 0
        pageControl.currentPageIndicatorTintColor = .blue
        pageControl.pageIndicatorTintColor = UIColor.black.withAlphaComponent(0.9)
        
        if let firstVC = VCArr.first {
            setViewControllers([firstVC], direction: .forward, animated: true, completion: nil)
        }
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        
        for view in self.view.subviews {
            if view is UIScrollView {
                view.frame = UIScreen.main.bounds
            } else if view is UIPageControl {
                view.backgroundColor = .clear
            }
        }
    }
    
    //MARK: - View Instructions
    
    public func pageViewController(_ pageViewController: UIPageViewController, viewControllerBefore viewController: UIViewController) -> UIViewController? {
        
        guard let viewControllerIndex = VCArr.index(of: viewController) else {
            return nil
        }
        
        let previousIndex = viewControllerIndex - 1
        guard previousIndex >= 0 else {
            return nil
            //return VCArr.last
        }
        
        guard VCArr.count > previousIndex else {
            return nil
        }
        
//        print("The \(self.VCInstance) is being viewed.")
        return VCArr[previousIndex]
    }
    
    public func pageViewController(_ pageViewController: UIPageViewController, viewControllerAfter viewController: UIViewController) -> UIViewController? {
        guard let viewControllerIndex = VCArr.index(of: viewController) else {
            return nil
        }
        
        let nextIndex = viewControllerIndex + 1
        
        guard nextIndex < VCArr.count else {
            return nil
        }
        
        guard VCArr.count > nextIndex else {
            return VCArr.last
        }
        return VCArr[nextIndex]
    }
    
    public func presentationCount(for pageViewController: UIPageViewController) -> Int {
        return VCArr.count
    }
    
    
    public func presentationIndex(for pageViewController: UIPageViewController) -> Int {
        guard let firstViewController = viewControllers?.first,
            let firstViewControllerIndex = VCArr.index(of: firstViewController) else {
                return 0
        }
        return firstViewControllerIndex
    }
}
