//
//  ViewController.swift
//  CodingTest
//
//  Created by Andrés Padilla on 21/6/21.
//

import UIKit
import PKHUD
import Toaster

class CategoriesViewController: UITabBarController {
    
    var genres: [Genre] = []
    
    lazy var popularViewController: MoviesViewController = {
        var controller = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: ViewIdentifier.movies) as! MoviesViewController
        
        controller.currentCategory = .Popular
        controller.tabBarItem = UITabBarItem(title: "Popular", image: UIImage(systemName: "heart.fill"), tag: 0)
        
        return controller
    }()
    lazy var topRatedViewController: MoviesViewController = {
        var controller = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: ViewIdentifier.movies) as! MoviesViewController
        
        controller.currentCategory = .TopRated
        controller.tabBarItem = UITabBarItem(title: "Top Rated", image: UIImage(systemName: "star.fill"), tag: 1)
        
        return controller
    }()
    lazy var upcoomingViewController: MoviesViewController = {
        var controller = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: ViewIdentifier.movies) as! MoviesViewController
        
        controller.currentCategory = .Upcoming
        controller.tabBarItem = UITabBarItem(title: "Upcoming", image: UIImage(systemName: "pin.fill"), tag: 2)
        
        return controller
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let imageView: UIImageView = UIImageView(frame: CGRect(x: 0, y: 0, width: 20, height: 20))
        imageView.image = UIImage(named: "3d-glasses-short")
        
        navigationItem.titleView = imageView
        
        self.delegate = self
        
        self.viewControllers = [
            popularViewController,
            topRatedViewController,
            upcoomingViewController
        ]
        
        requestGenres()
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "OnlineSearch" {
            (segue.destination as! OnlineSearchViewController).genres = genres
        }
    }
    
    func requestGenres() {
        
        if !NetworkState.isConnected() {
            genres = PersistenceManager.loadGenres()
            assignGenres()
        }
        
        APIManager.sharedInstance.requestGenres { result, error in
            if (error == nil) {
                self.genres = result
                self.assignGenres()
                DispatchQueue.global().async {
                    PersistenceManager.saveGenres(genres: self.genres)
                }
            }
        }
    }
    
    func assignGenres() {
        viewControllers!.forEach { controller in
            (controller as! MoviesViewController).genres = genres
        }
    }
    
}

//MARK: -

extension CategoriesViewController: UITabBarControllerDelegate {
    
    override func tabBar(_ tabBar: UITabBar, didSelect item: UITabBarItem) {
        self.title = tabBarItem.title
    }
    
}
