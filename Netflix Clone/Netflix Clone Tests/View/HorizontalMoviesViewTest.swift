//
//  HorizontalMoviesViewTest.swift
//  Netflix Clone Tests
//
//  Created by Wei Chu on 2024/8/8.
//

import XCTest
import SwiftUI
import ViewInspector
@testable import Netflix_Clone

final class HorizontalMoviesViewTest: XCTestCase {
    let dummyTitles: Binding<[Title]> = .init(
        wrappedValue: [.init(
            id: 0,
            media_type: "",
            original_language: "",
            original_title: "",
            original_name: "",
            poster_path: "image_path",
            overview: "",
            vote_count: 0,
            release_date: "",
            vote_average: 0
        )]
    )

    
    func testTapAction() throws {
        var actionTrigger: Bool = false
        let sut = try HorizontalMoviesView(title: "Trending Movies", titles: dummyTitles) { _ in
            actionTrigger = true
        } longPressAction: { _ in }.inspect()
        
        try sut.vStack().scrollView(1).lazyHStack().forEach(0).button(0).tap()
        XCTAssertEqual(actionTrigger, true)
    }
}
