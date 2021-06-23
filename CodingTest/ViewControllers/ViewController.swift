//
//  ViewController.swift
//  CodingTest
//
//  Created by Andrés Padilla on 21/6/21.
//

import UIKit
import PKHUD
import Toaster

enum ListType: Int {
    case Popular = 0
    case TopRated
    case Upcoming
}

class ViewController: UIViewController {
    
    @IBOutlet weak var searchBar: UISearchBar!
    @IBOutlet weak var collectionView: UICollectionView!
    @IBOutlet weak var emptyLabel: UILabel!
    
    var genres: [Genre] = []
    var languages: [Languaje] = []
    
    var allMovies: [Movie] = []
    var movies: [Movie] = []
    var currentType: ListType = .Popular
    var selectedMovie: Movie?
    var waiting = false
    
    var data: [ListType: [String: Any]] = [
        ListType.Popular: ["page": 1, "data": [], "max": 0],
        ListType.TopRated: ["page": 1, "data": [], "max": 0],
        ListType.Upcoming: ["page": 1, "data": [], "max": 0],
    ]
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        loadLanguages()
        
        APIManager.sharedInstance.requestGenres { result, error in
            self.genres = result
        }
        
        if let searchTextField = searchBar.value(forKey: "searchField") as? UITextField , let clearButton = searchTextField.value(forKey: "_clearButton")as? UIButton {
            clearButton.addTarget(self, action: #selector(self.dismissSearch), for: .touchUpInside)
        }
        
        requestMovies(loadMore: false)
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        
        if (segue.identifier == "ToDetail") {
            let destination = segue.destination as! DetailViewController
            destination.movie = selectedMovie
            destination.genres = genres
            destination.languages = languages
        }
    }
    
    func requestMovies(loadMore: Bool) {
        // Checks if data was already loaded
        if let array = self.data[self.currentType]!["data"] as? [Movie] {
            if !loadMore && !array.isEmpty {
                return
            }
        }
        
        HUD.show(.progress)
        
        var page = 1
        
        // Checks if already loaded all pages
        if let currentPage = data[currentType]?["page"] as? Int, let max = data[currentType]!["max"] as? Int {
            page = currentPage
            if currentPage == max {
                return
            }
        }
        
        if loadMore {
            page += 1
        }
        
        APIManager.sharedInstance.requestMovies(type: currentType, page: page) { result, page, max, error in
            HUD.hide()
            
            if (error != nil) {
                Toast(text: error?.localizedDescription, duration: Delay.long).show()
            } else {
                if var array = self.data[self.currentType]!["data"] as? [Movie] {
                    array.append(contentsOf: result)
                    self.data[self.currentType]?["data"] = array
                }
                
                self.data[self.currentType]?["page"] = page
                self.data[self.currentType]?["max"] = max
                
                self.collectionView.isHidden = result.count == 0
                self.emptyLabel.isHidden = result.count != 0
                
                self.collectionView.reloadData()
                
                switch self.currentType {
                case .Popular:
                    self.title = "Popular"
                case .TopRated:
                    self.title = "Top Rated"
                case .Upcoming:
                    self.title = "Upcoming"
                }
                
                self.waiting = false
            }
        }
    }
    
    func filterData(text: String) {
        movies = (text.count != 0) ? allMovies.filter { movie in
            if movie.title.range(of: text, options: .caseInsensitive) != nil {
                return true
            }
            return false
        } : allMovies
        collectionView.reloadData()
    }
    
    @objc func dismissSearch() {
        view.endEditing(true)
    }
    
    func loadLanguages() {
        do {
            if let bundlePath = Bundle.main.path(forResource: "languages", ofType: "json"),
               let jsonData = try String(contentsOfFile: bundlePath).data(using: .utf8) {
                let decoder = JSONDecoder()
                decoder.keyDecodingStrategy = .convertFromSnakeCase
                let response = try decoder.decode([Languaje].self, from: jsonData)
                languages = response
            }
        } catch {
            print(error)
        }
    }
    
}

extension ViewController: UICollectionViewDelegate {
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        if let array = data[currentType]!["data"] as? [Movie] {
            selectedMovie = array[indexPath.row]
            performSegue(withIdentifier: "ToDetail", sender: self)
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, willDisplay cell: UICollectionViewCell, forItemAt indexPath: IndexPath) {
        cell.alpha = 0
        UIView.animate(withDuration: 0.4) {
            cell.alpha = 1
        }
        
        if let array = data[currentType]!["data"] as? [Movie] {
            if indexPath.row == array.count - 1 && !waiting{
                waiting = true;
                requestMovies(loadMore: true)
            }
        }
        
    }
    
}

extension ViewController: UICollectionViewDataSource {
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        if let array = data[currentType]!["data"] as? [Movie] {
            return array.count
        }
        
        return 0
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: Constants.CellIdentifier.Movie, for: indexPath) as! MovieCell
        
        if let array = data[currentType]!["data"] as? [Movie] {
            cell.loadMovie(movie: array[indexPath.row])
        }
        
        return cell
    }
    
}

extension ViewController: UICollectionViewDelegateFlowLayout {
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        
        let width = (view.frame.width - 3 * 16) / 2
        return .init(width: width, height: width + 66)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {
        return UIEdgeInsets(top: 16, left: 16, bottom: 16, right: 16)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return 16
    }
    
}

extension ViewController: UITabBarDelegate {
    func tabBar(_ tabBar: UITabBar, didSelect item: UITabBarItem) {
        if let index = tabBar.items?.firstIndex(of: item) {
            currentType = ListType.init(rawValue: index as Int)!
            collectionView.scrollToItem(at: IndexPath(row: 0, section: 0), at: .top, animated: false)
            requestMovies(loadMore: false)
        }
    }
}

extension ViewController: UISearchBarDelegate {
    
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        print(searchText)
        filterData(text: searchText)
    }
    
    func searchBarCancelButtonClicked(_ searchBar: UISearchBar) {
        print("Cancel")
    }
    
}
