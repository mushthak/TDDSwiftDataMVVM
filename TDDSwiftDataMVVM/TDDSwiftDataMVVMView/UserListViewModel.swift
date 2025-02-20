//
//  UserListViewModel.swift
//  TDDSwiftDataMVVM
//
//  Created by Mushthak Ebrahim on 22/01/25.
//
import Observation

@Observable
public class UserListViewModel {
    //MARK: Dependencies
    let userViewModelAdapter: UserViewModelAdapter
    
    //MARK: States
    private(set) var users: [UserViewModel] = []
    private(set) var isEmptyUserMessageVisible: Bool = false
    private(set) var isInsertionErrorAlertPresented: Bool = false
    var isDeletionErrorAlertPresented: Bool = false
    private(set) var errorMessage: String?
    
    //MARK: Bindings
    var newName: String = ""
    var isShowingDialog = false
    
    var isNewNameValid: Bool {
        return !newName.trimmingCharacters(in: .whitespaces).isEmpty
    }
    
    //MARK: Constants
    let emptyUserMessage = "Press + to add users"
    let insertionErrorMsg = "Something went wrong while adding user"
    let deletionErrorMsg = "Something went wrong with deleting user"
    
    public init(userViewModelAdapter: UserViewModelAdapter) {
        self.userViewModelAdapter = userViewModelAdapter
    }
    
    @MainActor
    func loadUsers() async {
        users = try! await userViewModelAdapter.loadUserViewModels()
        refreshPlaceHolderText()
    }
    
    @MainActor
    func addUser(_ name: String) async {
        do {
            let newUser = try await userViewModelAdapter.saveUser(name: name)
            self.users.append(newUser)
            refreshPlaceHolderText()
            isShowingDialog = false
            newName = ""
        } catch  {
            self.isInsertionErrorAlertPresented = true
            self.errorMessage = insertionErrorMsg
        }
    }
    
    @MainActor
    func deleteUser(at index: Int) async {
        guard index >= 0 && index < users.count else { return }
        let userToDelete = users[index]
        do {
            try await userViewModelAdapter.deleteUser(user: userToDelete)
            self.users.remove(at: index)
            refreshPlaceHolderText()
        } catch  {
            self.isDeletionErrorAlertPresented = true
            self.errorMessage = deletionErrorMsg
        }
    }
    
    func cancelAddUser() {
        isShowingDialog = false
        newName = ""
        isInsertionErrorAlertPresented = false
        errorMessage = nil
    }
    
    func showAddUserDialog() {
        isShowingDialog = true
    }
    
    @MainActor
    func dismissDeletionErrorAlert() async {
        self.isDeletionErrorAlertPresented = false
        self.errorMessage = nil
    }
    
    //MARK: Helpers
    private func refreshPlaceHolderText() {
        isEmptyUserMessageVisible = users.isEmpty
    }
}
