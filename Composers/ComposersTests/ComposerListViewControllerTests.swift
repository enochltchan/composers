//
//  ComposerListViewControllerTests.swift
//  ComposersTests
//
//  Created by Enoch Chan on 4/25/21.
//

import XCTest
@testable import Composers

class ComposerListViewControllerTests: XCTestCase {
    var systemUnderTest: ComposerListViewController!
    
    override func setUpWithError() throws {
        // Put setup code here. This method is called before the invocation of each test method in the class.
        super.setUp()
        
        let storyboard = UIStoryboard(name: "Main", bundle: Bundle.main)
        var navigationController = storyboard.instantiateInitialViewController() as! UINavigationController
        self.systemUnderTest = navigationController.topViewController as? ComposerListViewController
        
        UIApplication.shared.windows
            .filter { $0.isKeyWindow }
            .first!
            .rootViewController = self.systemUnderTest
        
        XCTAssertNotNil(navigationController.view)
        XCTAssertNotNil(self.systemUnderTest.view)
    }

    

    func testTableView_loadsComposers() {
        // Given
        let mockComposerService = MockComposerService()
        let mockComposers = [
            Composer(named: "Jean Sibelius", period: "Romantic", country: "Finland", imageUrl: "https://serenademagazine.com/wp-content/uploads/2017/12/Jean_Sibelius_1913-1-e1515262530282.jpg"),
            Composer(named: "Edvard Grieg", period: "Romantic", country: "Norway", imageUrl: "https://reviews.azureedge.net/gramophone/artist/Edvard%20Grieg%20composer.jpg"),
            Composer(named: "Edward Elgar", period: "Romantic", country: "UK", imageUrl: "https://www.westminster-abbey.org/media/11013/sir-edward-elgar-1979.jpg?center=0.49402985074626865,0.45666666666666667&mode=crop&width=1200&rnd=132101820120000000")
        ]
        mockComposerService.mockComposers = mockComposers
        
        self.systemUnderTest.viewDidLoad()
        self.systemUnderTest.composerService = mockComposerService
        
        XCTAssertEqual(self.systemUnderTest.tableView.numberOfRows(inSection: 0), 0) // make sure the table view is empty at first
        
        // When
        self.systemUnderTest.viewWillAppear(false)
        
        // Then
        XCTAssertEqual(mockComposers.count, self.systemUnderTest.composersList.count)
        XCTAssertEqual(mockComposers.count, self.systemUnderTest.tableView.numberOfRows(inSection: 0)) // checks that number of mock composers = number of cells in table view now; this could trip up if the mock composer collection has more composers than would appear on screen at the same time in the view controller
    }
    
    class MockComposerService: ComposerService {
        var mockComposers: [Composer]?
        var mockError: Error?
        
        override func getComposers(completion: @escaping ([Composer]?, Error?) -> ()) {
            completion(mockComposers, mockError)
        }
    }

}
