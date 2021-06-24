//
//  ViewController.swift
//  CodingTest
//
//  Created by Andrés Padilla on 21/6/21.
//

import UIKit
import PKHUD
import Toaster

class MoviesViewController: UIViewController {
    
    @IBOutlet weak var searchBar: UISearchBar!
    @IBOutlet weak var collectionView: UICollectionView!
    @IBOutlet weak var emptyLabel: UILabel!
    
    var genres: [Genre] = []
    var languages: [Languaje] = []
    
    var allMovies: [Movie] = []
    var movies: [Movie] = []
    
    var currentPage = 1
    var maxPage = 0
    
    var currentCategory: Categories = .Popular
    var selectedMovie: Movie?
    var waiting = false
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        loadLanguages()
        
        requestMovies(loadMore: false)
        
        if let searchTextField = searchBar.value(forKey: "searchField") as? UITextField , let clearButton = searchTextField.value(forKey: "_clearButton")as? UIButton {
            searchTextField.placeholder = "Type to search"
            clearButton.addTarget(self, action: #selector(self.dismissSearch), for: .touchUpInside)
        }
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
        
        if !NetworkState.isConnected() {
            Toast(text: "Check your internet connection!").show()
            
            PersistenceManager.loadMovieCategory(category: currentCategory) { movies, currentIndex, maxIndex in
                self.allMovies = movies
                self.movies = movies
                self.currentPage = currentIndex
                self.maxPage = maxIndex
                self.emptyLabel.isHidden = !movies.isEmpty
                self.collectionView.reloadData()
            }
            
            return
        } else {
            ToastCenter.default.cancelAll()
        }
        
        if (!allMovies.isEmpty && !loadMore) || // Checks if data was already loaded
            currentPage == maxPage { // Checks if already loaded all pages
            return
        }
        
        
        HUD.show(.progress)
        
        var page = currentPage
        
        if loadMore {
            page += 1
        }
        
        APIManager.sharedInstance.requestMovies(type: currentCategory, page: page) { result, page, max, error in
            HUD.hide()
            
            if (error != nil) {
                Toast(text: error?.localizedDescription, duration: Delay.long).show()
            } else {
                self.allMovies.append(contentsOf: result)
                self.movies = self.allMovies
                self.currentPage = page
                self.maxPage = max
                
                self.collectionView.isHidden = result.count == 0
                self.emptyLabel.isHidden = result.count != 0
                
                self.collectionView.reloadData()
                
                self.waiting = false
                
                DispatchQueue.global().async {
                    PersistenceManager.saveMovieCategory(category: self.currentCategory, movies: self.allMovies, currentIndex: self.currentPage, maxIndex: self.maxPage)
                }
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

extension MoviesViewController: UICollectionViewDelegate {
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        selectedMovie = movies[indexPath.row]
        performSegue(withIdentifier: "ToDetail", sender: self)
    }
    
    func collectionView(_ collectionView: UICollectionView, willDisplay cell: UICollectionViewCell, forItemAt indexPath: IndexPath) {
        cell.alpha = 0
        UIView.animate(withDuration: 0.4) {
            cell.alpha = 1
        }
        
        if indexPath.row == allMovies.count - 1 && !waiting && NetworkState.isConnected(){
            waiting = true;
            requestMovies(loadMore: true)
        }
        
    }
    
}

extension MoviesViewController: UICollectionViewDataSource {
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return movies.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: Constants.CellIdentifier.Movie, for: indexPath) as! MovieCell
        
        cell.loadMovie(movie: movies[indexPath.row])
        
        return cell
    }
    
}

extension MoviesViewController: UICollectionViewDelegateFlowLayout {
    
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

extension MoviesViewController: UISearchBarDelegate {
    
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        print(searchText)
        filterData(text: searchText)
    }
    
    func searchBarCancelButtonClicked(_ searchBar: UISearchBar) {
        print("Cancel")
    }
    
}
