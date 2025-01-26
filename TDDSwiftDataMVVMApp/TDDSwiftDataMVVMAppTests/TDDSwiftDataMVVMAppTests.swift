//
//  TDDSwiftDataMVVMAppTests.swift
//  TDDSwiftDataMVVMAppTests
//
//  Created by Mushthak Ebrahim on 26/01/25.
//

import Testing
import SwiftData
@testable import TDDSwiftDataMVVMApp
import TDDSwiftDataMVVM
import TDDSwiftDataMVVMView

struct TDDSwiftDataMVVMAppTests {

    @Test func test_compositionRoot_schemaContainsManagedUser() {
        let schema = CompositionRoot.schema
        #expect(schema.entities.contains { $0.name == "ManagedUser" })
    }

    @Test func test_compositionRoot_containerIsCreated() {
        let container = CompositionRoot.container
        #expect(container != nil)
    }

    @Test func test_compositionRoot_storeIsSwiftDataStore() {
        let store = CompositionRoot.store
        #expect(type(of: store) == SwiftDataStore.self)
    }

    @Test func test_compositionRoot_loaderIsLocaleUserLoader() {
        let loader = CompositionRoot.loader
        #expect(type(of: loader) == LocaleUserLoader.self)
    }

    @Test func test_compositionRoot_rootViewReturnsUserListView() {
        let view = CompositionRoot.rootView()
        #expect(type(of: view) == UserListView.self)
    }

}

