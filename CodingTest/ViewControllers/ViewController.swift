//
//  ViewController.swift
//  CodingTest
//
//  Created by Andrés Padilla on 21/6/21.
//

import UIKit
import PKHUD

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
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        loadLanguages()
        
        APIManager.sharedInstance.requestGenres { result, error in
            self.genres = result
        }
        
        if let searchTextField = searchBar.value(forKey: "searchField") as? UITextField , let clearButton = searchTextField.value(forKey: "_clearButton")as? UIButton {
            clearButton.addTarget(self, action: #selector(self.dismissSearch), for: .touchUpInside)
        }
        
        downloadCurrentListType()
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        
        if (segue.identifier == "ToDetail") {
            let destination = segue.destination as! DetailViewController
            destination.movie = selectedMovie
            destination.genres = genres
            destination.languages = languages
        }
    }
    
    func downloadCurrentListType() {
        HUD.show(.progress)
        
        APIManager.sharedInstance.requestMovies(type: currentType) { result, error in
            HUD.hide()
            
            self.movies = result
            self.allMovies = result
            
            self.collectionView.isHidden = self.movies.count == 0
            self.emptyLabel.isHidden = self.movies.count != 0
            
            self.collectionView.reloadData()
            
            switch self.currentType {
            case .Popular:
                self.title = "Popular"
            case .TopRated:
                self.title = "Top Rated"
            case .Upcoming:
                self.title = "Upcoming"
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
        selectedMovie = movies[indexPath.row]
        performSegue(withIdentifier: "ToDetail", sender: self)
    }
    
    func collectionView(_ collectionView: UICollectionView, willDisplay cell: UICollectionViewCell, forItemAt indexPath: IndexPath) {
        cell.alpha = 0
        UIView.animate(withDuration: 0.4) {
            cell.alpha = 1
        }
    }
    
}

extension ViewController: UICollectionViewDataSource {
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return movies.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: Constants.CellIdentifier.Movie, for: indexPath) as! MovieCell
        
        cell.loadMovie(movie: movies[indexPath.row])
        
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
            downloadCurrentListType()
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
