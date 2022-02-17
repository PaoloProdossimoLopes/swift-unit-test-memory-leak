//
//  FirstArticleMemoryLeakTest.swift
//  MemoryLeakUnitTestTests
//
//  Created by Paolo Prodossimo Lopes on 17/02/22.
//

import Foundation
import XCTest

final class FirstArticleMememoryLeakTest: XCTestCase {
    
    func test_GIVENParentAndChild_WHENConectBoths_THENShouldBeNilInTearDownBlock() {
        //GIVEN
        let parent = Parent()
        let child = Child()
        
        //WHEN
        parent.child = child
        child.parent = parent
        
        //THEN
        addTeardownBlock { [weak child, weak parent] in
            XCTAssertNil(child)
            XCTAssertNil(parent)
        }
        
        
        
        /*
         * NOTE: If parent inside child or child inside parent must be
         * weak to be possible became nil when dealocate
        */
    }
    
    func test_GIVENParentAndChild_WHENConectBoths_THENShouldBeNilInTearDownBlock_V2() {
        let _ = makeSUT()
    }
    
    private func makeSUT(file: StaticString = #filePath, line: UInt = #line) -> (Child, Parent){
        let parent = Parent()
        let sut: Child = Child()
        sut.parent = parent
        parent.child = sut
        trackForMemoryLeaks(sut, file: file, line: line)
        trackForMemoryLeaks(parent, file: file, line: line)
        return (sut, parent)
    }
    
}

//MARK: - GREATE HELPER

extension XCTestCase {
    func trackForMemoryLeaks(
        _ instance: AnyObject,
        file: StaticString = #filePath,
        line: UInt = #line
    ) {
        addTeardownBlock { [weak instance] in
            let errorMessage: String = (
                "Instance should have been deallocated. Potential memory leak!"
            )
            XCTAssertNil(instance, errorMessage, file: file, line: line)
        }
    }
}

//MARK: - Struct nescessary

final class Child {
    weak var parent: Parent?
}

final class Parent {
    
    var child: Child?
    
}

