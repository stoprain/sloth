//
//  PageViewController.swift
//  sloth
//
//  Created by Rain Qian on 2022/11/18.
//

import SwiftUI

struct PageViewController: UIViewControllerRepresentable {
    
    var controller: [UIViewController]
    
    func makeUIViewController(context: Context) -> UIPageViewController {
        let pageViewController = UIPageViewController(transitionStyle: .scroll, navigationOrientation: .horizontal)
        return pageViewController
    }
    
    func updateUIViewController(_ uiViewController: UIPageViewController, context: Context) {
        
    }
    
    typealias UIViewControllerType = UIPageViewController
    
    
}
