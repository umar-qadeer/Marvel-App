//
//  File.swift
//  The Hitchhiker ProphecyTests
//
//  Created by Umar on 31/05/2021.
//  Copyright © 2021 SWVL. All rights reserved.
//

@testable import The_Hitchhiker_Prophecy
import XCTest
import UIKit

class HomeSceneInteractorTests: XCTestCase {

    // MARK: - Subject under test
    var sut: HomeSceneInteractor!
      
    // MARK: - Test lifecycle
    override func setUp() {
        super.setUp()
        setupHomeSceneInteractor()
    }
      
    override func tearDown() {
        super.tearDown()
        sut = nil
    }
      
    // MARK: - Test Setup
    func setupHomeSceneInteractor() {
        workerSpy = HomeWorkerMock()
        presentationLogicSpy = HomeScenePresentationLogicMock()
        sut = HomeSceneInteractor(worker: workerSpy, presenter: presentationLogicSpy)
    }
    
    // MARK: - Test Doubles
    var workerSpy: HomeWorkerType!
    var presentationLogicSpy: HomeScenePresentationLogicMock!
    
    // MARK: - Tests
    func testFetchCharactersCallsWorkerToFetch() {
        // Given
        let spy = HomeWorkerMock()
        let sut = HomeSceneInteractor(worker: spy, presenter: HomeScenePresentationLogicMock())
        
        // When
        sut.fetchCharacters()

        // Then
        XCTAssert(spy.getCharactersCalled, "fetchCharacters() should ask the worker to fetch the characters")
    }
}

class HomeWorkerMock: HomeWorkerType {
    private let service = CharacterNetworkService()
    var getCharactersCalled = false
    
    func getCharacters(_ input: Characters.Search.Input, completion: @escaping (HomeScene.Search.Response) -> Void) {
        getCharactersCalled = true
    }
}

class HomeScenePresentationLogicMock: HomeScenePresentationLogic {
    var displayView: HomeSceneDisplayView?
    var presentCharactersCalled = false
    
    func presentCharacters(_ response: HomeScene.Search.Response) {
        presentCharactersCalled = true
    }
}
