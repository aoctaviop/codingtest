//
//  ViewController.swift
//  CodingTest
//
//  Created by Andrés Padilla on 23/6/21.
//

import UIKit
import PKHUD
import Toaster

class OnlineSearchViewController: UIViewController {
    
    @IBOutlet weak var searchBar: UISearchBar!
    @IBOutlet weak var collectionView: UICollectionView!
    @IBOutlet weak var emptyLabel: UILabel!
    
    var genres: [Genre] = []
    var languages: [Languaje] = []
    
    var allMovies: [Movie] = []
    var movies: [Movie] = []
    
    var currentPage = 1
    var maxPage = 0
    
    var selectedMovie: Movie?
    var waiting = false
    
    var searchText: String = ""
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
//        collectionView.register(MovieCell.self, forCellWithReuseIdentifier: Constants.CellIdentifier.Movie)

        loadLanguages()
        
        if let searchTextField = searchBar.value(forKey: "searchField") as? UITextField , let clearButton = searchTextField.value(forKey: "_clearButton")as? UIButton {
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
    
    @objc func dismissSearch() {
        view.endEditing(true)
    }
    
    func requestMovies(loadMore: Bool) {
        
        if !NetworkState.isConnected() {
            Toast(text: "Check your internet connection!").show()
            return
        }
        
        if currentPage == maxPage { // Checks if already loaded all pages
            return
        }
        
        HUD.show(.progress)
        
        var page = currentPage
        
        if loadMore {
            page += 1
        }
        
        APIManager.sharedInstance.searchMovies(query: searchText, page: page) { result, page, max, error in
            HUD.hide()
            
            if (error != nil) {
                Toast(text: error?.localizedDescription, duration: Delay.long).show()
            } else {
                if (loadMore) {
                    self.allMovies.append(contentsOf: result)
                } else {
                    self.allMovies = result
                }
                self.movies = self.allMovies
                self.currentPage = page
                self.maxPage = max
                
                self.collectionView.isHidden = result.count == 0
                self.emptyLabel.isHidden = result.count != 0
                
                self.collectionView.reloadData()
                
                self.waiting = false
            }
        }
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

extension OnlineSearchViewController: UICollectionViewDelegate {
    
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

extension OnlineSearchViewController: UICollectionViewDataSource {
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return movies.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: Constants.CellIdentifier.Movie, for: indexPath) as! MovieCell
        
        cell.loadMovie(movie: movies[indexPath.row])
        
        return cell
    }
    
}

extension OnlineSearchViewController: UICollectionViewDelegateFlowLayout {
    
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

extension OnlineSearchViewController: UISearchBarDelegate {
    
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        self.searchText = searchText
        if searchText.isEmpty {
            allMovies = []
            movies = []
            currentPage = 1
            maxPage = 1
            collectionView.reloadData()
            collectionView.isHidden = true
            emptyLabel.isHidden = false
        }
    }
    
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        if !searchText.isEmpty {
            requestMovies(loadMore: false)
            collectionView.scrollToItem(at: IndexPath(row: 0, section: 0), at: .top, animated: true)
        }
    }
    
    func searchBarCancelButtonClicked(_ searchBar: UISearchBar) {
        allMovies = []
        movies = []
        collectionView.reloadData()
        collectionView.isHidden = true
        emptyLabel.isHidden = false
    }
    
}
