//
//  UserListView.swift
//  TDDSwiftDataMVVMView
//
//  Created by Mushthak Ebrahim on 23/01/25.
//

import SwiftUI
import TDDSwiftDataMVVM

struct UserListView: View {
    
    //MARK: Dependencies
    @State var viewModel: UserListViewModel
    
    var body: some View {
        
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
        .overlay {
            if viewModel.isShowingDialog {
                ZStack {
                    Color.black.opacity(0.4).ignoresSafeArea()
                    VStack(spacing: 16) {
                        Text("Add User")
                            .font(.headline)
                            .padding()
                        
                        TextField("Enter name", text: $viewModel.newName)
                            .textFieldStyle(RoundedBorderTextFieldStyle())
                            .padding(.horizontal)
                        
                        HStack {
                            Button("Cancel") {
                                viewModel.cancelAddUser()
                            }
                            .padding()
                            .background(Color.gray.opacity(0.2))
                            .cornerRadius(8)
                            
                            Button("Save") {
                                Task {
                                    await viewModel.addUser(viewModel.newName)
                                }
                            }
                            .padding()
                            .background(viewModel.newName.isEmpty ? Color.gray : Color.blue)
                            .cornerRadius(8)
                            .foregroundColor(.white)
                            .disabled(viewModel.newName.isEmpty)
                        }
                        
                        if viewModel.isInsertionErrorAlertPresented {
                            Text("\(viewModel.errorMessage ?? "")")
                                .font(.caption2)
                                .foregroundStyle(.red)
                            
                        }
                    }
                    .padding()
                    .background(Color.white)
                    .cornerRadius(12)
                    .shadow(radius: 10)
                    .frame(maxWidth: 300)
                }
            }
            
            if viewModel.isDeletionErrorAlertPresented {
                ZStack {
                    Color.black.opacity(0.4).ignoresSafeArea()
                    VStack {
                        Text("Deletion Error")
                            .font(.headline)
                            .padding()
                        Text("\(viewModel.errorMessage ?? "")")
                            .font(.callout)
                        Button("Dismiss") {
                            Task {
                                await viewModel.dismissDeletionErrorAlert()
                            }
                        }.tint(.red)
                        .padding()
                            
                    }
                    .padding()
                        .background(Color.white)
                        .cornerRadius(12)
                        .shadow(radius: 10)
                        .frame(maxWidth: 400)
                }
            }
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
    static let userListViewModelPreview: UserListViewModel = {
        class PreviewCache: UserCache {
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
