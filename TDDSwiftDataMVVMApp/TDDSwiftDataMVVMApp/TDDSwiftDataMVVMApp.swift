//
//  TDDSwiftDataMVVMAppApp.swift
//  TDDSwiftDataMVVMApp
//
//  Created by Mushthak Ebrahim on 26/01/25.
//

import SwiftUI
import TDDSwiftDataMVVM
import TDDSwiftDataMVVMView
import SwiftData

@main
struct TDDSwiftDataMVVMApp: App {
    var body: some Scene {
        WindowGroup {
            CompositionRoot.rootView()
        }
    }
}

struct CompositionRoot {
    static let schema = Schema([
        ManagedUser.self,
    ])
    static let container = try! ModelContainer(for: schema)
    static let store = SwiftDataStore(modelContainer: container)
    static let loader = LocaleUserLoader(store: store)
    
    static func rootView() -> UserListView {
        let viewModelAdapter = UserViewModelAdapter(loader: loader)
        let viewModel = UserListViewModel(userViewModelAdapter: viewModelAdapter)
        return UserListView(viewModel: viewModel)
    }
}
