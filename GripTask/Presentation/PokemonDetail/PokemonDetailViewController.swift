//
//  PokemonDetailViewController.swift
//  GripTask
//
//  Created by Shraddha on 24/04/24.
//

import Foundation
import SnapKit

class PokemonDetailViewController: UIViewController {
    
    var selectedPokemon: PokemonModel!
    let viewModel =  PokemonDetailViewModel(getPokemonDetailUseCase: PokemonDetailDataSource(networkService: URLSessionNetworkService()))
    
    private let imageView: UIImageView = {
        let imageView = UIImageView()
        imageView.contentMode = .scaleAspectFit
        return imageView
    }()
    
    private let nameLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.boldSystemFont(ofSize: 20)
        label.textColor = .black
        label.textAlignment = .center
        return label
    }()
    
    private let statLabel: UILabel = {
        let label = UILabel()
        label.textColor = .black
        label.numberOfLines = 0
        label.textAlignment = .center
        return label
    }()
    
    private let typeLabel: UILabel = {
        let label = UILabel()
        label.textColor = .black
        label.numberOfLines = 0
        label.textAlignment = .center
        return label
    }()
    
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
        view.backgroundColor = .white
        view.addSubview(activityIndicator)
        activityIndicator.snp.makeConstraints { make in
            make.centerX.equalToSuperview()
            make.centerY.equalToSuperview()
        }
        
        view.addSubview(imageView)
        imageView.snp.makeConstraints { make in
            make.top.equalTo(view.safeAreaLayoutGuide.snp.top).offset(20)
            make.leading.equalToSuperview().offset(20)
            make.trailing.equalToSuperview().offset(-20)
            make.height.equalTo(200)
        }
        
        view.addSubview(nameLabel)
        nameLabel.snp.makeConstraints { make in
            make.top.equalTo(imageView.snp.bottom).offset(20)
            make.leading.equalToSuperview().offset(20)
            make.trailing.equalToSuperview().offset(-20)
        }
        
        view.addSubview(statLabel)
        statLabel.snp.makeConstraints { make in
            make.top.equalTo(nameLabel.snp.bottom).offset(20)
            make.leading.equalToSuperview().offset(20)
            make.trailing.equalToSuperview().offset(-20)
        }
        
        view.addSubview(typeLabel)
        typeLabel.snp.makeConstraints { make in
            make.top.equalTo(statLabel.snp.bottom).offset(20)
            make.leading.equalToSuperview().offset(20)
            make.trailing.equalToSuperview().offset(-20)
        }
    }
    
    private func loadData() {
        viewModel.getPokemonDetail(url: selectedPokemon.url)
    }
    
    private func displayAlert(message: String) {
        let alertController = UIAlertController(title: "Error", message: message, preferredStyle: .alert)
        alertController.addAction(UIAlertAction(title: "OK", style: .default, handler: nil))
        self.present(alertController, animated: true, completion: nil)
    }
}

extension PokemonDetailViewController: PokemonDetailViewModelDelegate {
    func didUpdatePokemonDetail() {
        DispatchQueue.main.async {
            guard let pokemon = self.viewModel.pokemonDetail else { return }
            self.navigationItem.title = pokemon.name
            self.nameLabel.text = "Name: \(pokemon.name)"
            self.imageView.sd_setImage(with: URL(string: self.selectedPokemon.imageUrl), placeholderImage: UIImage(named: "placeholder.png"))
            // Display stats
            let arrayMap: Array = pokemon.stats.map(){ $0.stat?.name?.capitalized ?? "" }
            self.statLabel.text  = "Stats:" + arrayMap.joined(separator: ", ")
            
            let arrayType: Array = pokemon.types.map(){ $0.type?.name?.capitalized ?? "" }
            self.typeLabel.text  = "Types:" + arrayType.joined(separator: ", ")
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
