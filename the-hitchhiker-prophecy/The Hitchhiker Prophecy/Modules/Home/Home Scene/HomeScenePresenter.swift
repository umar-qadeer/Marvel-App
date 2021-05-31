//
//  HomeScenePresenter.swift
//  The Hitchhiker Prophecy
//
//  Created by Mohamed Matloub on 6/13/20.
//  Copyright © 2020 SWVL. All rights reserved.
//

import Foundation

class HomeScenePresneter: HomeScenePresentationLogic {
    weak var displayView: HomeSceneDisplayView?
    
    init(displayView: HomeSceneDisplayView) {
        self.displayView = displayView
    }
    
    func presentCharacters(_ response: HomeScene.Search.Response) {
        // TODO: Implement
        switch response {
        case .success(let result):
            let characters = result.data.results
            var viewModels: [HomeScene.Search.ViewModel] = []
            
            for character in characters {
                let imageUrl = "\(character.thumbnail.path)/\(HomeScene.Search.Constants.ImageSize.Standard.Fantastic.rawValue).\(character.thumbnail.thumbnailExtension)"
                let comics = character.comics.items.map({ $0.name }).joined(separator: ", ")
                let series = character.series.items.map({ $0.name }).joined(separator: ", ")
                let stories = character.stories.items.map({ $0.name }).joined(separator: ", ")
                let events = character.events.items.map({ $0.name }).joined(separator: ", ")
                
                let viewModel = HomeScene.Search.ViewModel(name: character.name, desc: character.resultDescription, imageUrl: imageUrl, comics: comics, series: series, stories: stories, events: events)
                viewModels.append(viewModel)
            }
            
            displayView?.didFetchCharacters(viewModels: viewModels)
        case .failure(let error):
            displayView?.failedToFetchCharacters(error: error)
        }
    }
}
