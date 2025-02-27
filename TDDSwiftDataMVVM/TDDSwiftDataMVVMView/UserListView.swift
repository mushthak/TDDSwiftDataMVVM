//
//  UserListView.swift
//  TDDSwiftDataMVVMView
//
//  Created by Mushthak Ebrahim on 23/01/25.
//

import SwiftUI
import TDDSwiftDataMVVM

public struct UserListView: View {
    
    //MARK: Dependencies
    @State var viewModel: UserListViewModel
    
    public init(viewModel: UserListViewModel) {
        self.viewModel = viewModel
    }
    
    public var body: some View {
        
        NavigationView {
            List {
                ForEach(viewModel.users) { user in
                    Text(user.name)
                }
                .onDelete { indexSet in
                    Task {
                        guard let index = indexSet.first else { return }
                        await viewModel.deleteUser(at: index)
                    }
                }
            }
            .onEmpty(for: viewModel.isEmptyUserMessageVisible, with: viewModel.emptyUserMessage)
            .refreshable {
                await viewModel.loadUsers()
            }
            .navigationTitle("Users")
            .toolbar {
                ToolbarItem(placement: .navigationBarTrailing) {
                    Button(action: {
                        viewModel.showAddUserDialog()
                    }) {
                        Label("Add", systemImage: "plus")
                    }
                }
            }
        }
        .task {
            await viewModel.loadUsers()
        }
        .sheet(isPresented: $viewModel.isShowingDialog, onDismiss: viewModel.cancelAddUser) {
            NavigationStack {
                Form {
                    Section(header: Text("Name")) {
                        TextField("Enter name", text: $viewModel.newName)
                        if viewModel.isInsertionErrorAlertPresented {
                            Text("\(viewModel.errorMessage ?? "")")
                                .font(.caption2)
                                .foregroundStyle(.red)
                        }
                    }
                }
                .navigationTitle("Add User")
                .toolbar {
                    ToolbarItem(placement: .cancellationAction) {
                        Button("Dismiss") {
                            viewModel.cancelAddUser()
                        }
                    }
                    ToolbarItem(placement: .primaryAction) {
                        Button("Done") {
                            Task {
                                await viewModel.addUser(viewModel.newName)
                            }
                        }
                        .disabled(!viewModel.isNewNameValid)
                    }
                }
            }
            .presentationDetents([.medium, .large])
        }
        .alert(
                    "Deletion Error",
                    isPresented: $viewModel.isDeletionErrorAlertPresented,
                    presenting: viewModel.errorMessage
                ) { details in
                    Button(role: .cancel) {
                        Task {
                            await viewModel.dismissDeletionErrorAlert()
                        }
                    } label: {
                        Text("Ok")
                    }
                } message: { details in
                    Text(details)
                }
    }
}

//MARK: View Modifier
struct EmptyListView: ViewModifier {
    let condition: Bool
    let message: String
    func body(content: Content) -> some View {
        valideView(content: content)
    }
    
    @ViewBuilder
    private func valideView(content: Content) -> some View {
        if condition {
            VStack{
                Spacer()
                Text(message)
                    .font(.title2)
                    .foregroundColor(Color.gray)
                    .multilineTextAlignment(.center)
                Spacer()
            }
        } else {
            content
        }
    }
}

//MARK: View Extension
extension View {
    func onEmpty(for condition: Bool, with message: String) -> some View {
        self.modifier(EmptyListView(condition: condition, message: message))
    }
}

#Preview {
    UserListView(viewModel: PreviewHelper.userListViewModelPreview)
}


#if DEBUG
private struct PreviewHelper {
    @MainActor static let userListViewModelPreview: UserListViewModel = {
        @MainActor
        final class PreviewCache: UserCache {
            var users: [User] = [User(id: UUID(), name: "Mush")]
            
            func loadUsers() async throws -> [User] {
                return users
            }
            
            func saveUser(user: User) async throws {
                users.append(user)
            }
            
            func deleteUser(user: User) async throws {
                users.removeAll { $0.id == user.id}
            }
            
        }
        
        let viewModel: UserListViewModel = UserListViewModel(userViewModelAdapter: UserViewModelAdapter(loader: PreviewCache()))
        return viewModel
    }()
}
#endif
