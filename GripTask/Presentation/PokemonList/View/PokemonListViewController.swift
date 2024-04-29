//
//  PokemonListViewController.swift
//  GripTask
//
//  Created by Shraddha on 22/04/24.
//

import UIKit
import SnapKit
import SDWebImage

class PokemonListViewController: UIViewController {
    
    let viewModel =  PokemonListViewModel(getPokemonsUseCase: PokemonDataSource(networkService: URLSessionNetworkService()))
    lazy var collectionView = UICollectionView(frame: .zero, collectionViewLayout: UICollectionViewFlowLayout())
    
    lazy var activityIndicator: UIActivityIndicatorView = {
        let indicator = UIActivityIndicatorView(style: .large)
        indicator.color = .gray
        indicator.hidesWhenStopped = true
        return indicator
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        viewModel.delegate = self
        setupViews()
        loadData()
    }
    
    func setupViews() {
        view.addSubview(activityIndicator)
        activityIndicator.snp.makeConstraints { make in
            make.centerX.equalToSuperview()
            make.centerY.equalToSuperview()
        }
        view.addSubview(collectionView)
        collectionView.backgroundColor = .white
        collectionView.register(PokemonCell.self, forCellWithReuseIdentifier: PokemonCell.reuseIdentifier)
        collectionView.dataSource = self
        collectionView.delegate = self
        collectionView.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }
    }
    
    private func loadData() {
        viewModel.getPokemons()
    }
    
    private func displayAlert(message: String) {
        let alertController = UIAlertController(title: "Error", message: message, preferredStyle: .alert)
        alertController.addAction(UIAlertAction(title: "OK", style: .default, handler: nil))
        self.present(alertController, animated: true, completion: nil)
    }
    
    func navigateToDetail(pokemon: PokemonModel) {
        let detailView = PokemonDetailViewController()
        detailView.selectedPokemon = pokemon
        navigationController?.pushViewController(detailView, animated: true)
    }
}

extension PokemonListViewController: PokemonListViewModelDelegate {
    func didUpdatePokemons() {
        DispatchQueue.main.async {
            self.collectionView.reloadData()
        }
    }
    
    func didEncounterError() {
        displayAlert(message: viewModel.errorMessage)
    }
    
    func showLoader(show: Bool) {
        DispatchQueue.main.async {
            if show {
                self.activityIndicator.startAnimating()
            } else {
                self.activityIndicator.stopAnimating()
            }
        }
    }
}

extension PokemonListViewController: UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return viewModel.pokemons.count
    }
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: PokemonCell.reuseIdentifier, for: indexPath) as! PokemonCell
        cell.imageView.sd_setImage(with: URL(string: viewModel.pokemons[indexPath.item].imageUrl), placeholderImage: UIImage(named: "placeholder.png"))
        cell.nameLabel.text = viewModel.pokemons[indexPath.item].name.capitalized
        return cell
    }
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        navigateToDetail(pokemon: viewModel.pokemons[indexPath.item])
    }
}

extension PokemonListViewController: UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let width = (collectionView.bounds.width - 20) / 2
        return CGSize(width: width, height: width)
    }
    
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return 10
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
        return 10
    }
}
