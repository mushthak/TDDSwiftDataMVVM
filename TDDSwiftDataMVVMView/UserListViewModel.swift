//
//  UserListViewModel.swift
//  TDDSwiftDataMVVM
//
//  Created by Mushthak Ebrahim on 22/01/25.
//


public class UserListViewModel {
    //MARK: Dependencies
    let userViewModelAdapter: UserViewModelAdapter
    
    //MARK: States
    public var users: [UserViewModel] = []
    public var isEmptyUserMessageVisible: Bool = false
    public var isErrorAlertPresented: Bool = false
    public var errorMessage: String?
    
    //MARK: Constants
    let insertionErrorMsg = "Something went wrong while adding user"
    let deletionErrorMsg = "Something went wrong with deleting user"
    
    public init(userViewModelAdapter: UserViewModelAdapter) {
        self.userViewModelAdapter = userViewModelAdapter
    }
    
    public func loadUsers() async {
        users = try! await userViewModelAdapter.loadUserViewModels()
        refreshPlaceHolderText()
    }
    
    public func addUser(_ name: String) async {
        do {
            let newUser = try await userViewModelAdapter.saveUser(name: name)
            self.users.append(newUser)
            refreshPlaceHolderText()
        } catch  {
            self.isErrorAlertPresented = true
            self.errorMessage = insertionErrorMsg
        }
    }
    
    public func deleteUser(at index: Int) async {
        guard index >= 0 && index < users.count else { return }
        let userToDelete = users[index]
        do {
            try await userViewModelAdapter.deleteUser(user: userToDelete)
            self.users.remove(at: index)
            refreshPlaceHolderText()
        } catch  {
            self.isErrorAlertPresented = true
            self.errorMessage = deletionErrorMsg
        }
    }
    
    //MARK: Helpers
    private func refreshPlaceHolderText() {
        isEmptyUserMessageVisible = users.isEmpty
    }
}
